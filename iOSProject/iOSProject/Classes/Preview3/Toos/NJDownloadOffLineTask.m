
#import "NJDownloadOffLineTask.h"
#import <NSString+YYAdd.h>
#import "NJDownLoadHelper.h"

@interface NJDownloadOffLineTask ()<NSURLSessionDataDelegate>
/** session任务集合 */
@property (nonatomic, strong) NSURLSession *session;

/** <#digest#> */
@property (assign, nonatomic) NSString *taskURL_String;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *task;

/** 文件写入的流 */
@property (nonatomic, strong) NSOutputStream *stream;

/** 文件的总长度 */
@property (assign, nonatomic) NSInteger contentLength;

@end

@implementation NJDownloadOffLineTask


- (NSURLSession *)session
{
    if(_session == nil)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        configuration.timeoutIntervalForRequest = 18.0;
        configuration.allowsCellularAccess = NO;
        
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
    return _session;
}

- (NSOutputStream *)stream
{
    if(_stream == nil)
    {
        _stream = [NSOutputStream outputStreamToFileAtPath:nj_getFilePath(self.taskURL_String) append:YES];
    }
    return _stream;
}

- (NSURLSessionDataTask *)task
{
    if(_task == nil)
    {
        // 先从写入的保存的字典中文件中获得当前需要下载文件的总大小
        self.contentLength = nj_getExpectedContentLength(self.taskURL_String, nil);
        
        // 如果下载文件的大小==总大小, 就跳过,
        if(self.contentLength && self.contentLength == nj_getCompleteContentLength(self.taskURL_String, nil))
        {
            self.completBlock(nil, nj_getFilePath(self.taskURL_String));
            
            return nil;
        }
        
        // 如果从来没有下载过contentlength == 0, 或者没有下载完,
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.taskURL_String]];
        
        // 就接着下载
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", nj_getCompleteContentLength(self.taskURL_String, nil)];
        
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        _task = [self.session dataTaskWithRequest:request];
    }
    return _task;
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [self.stream open];
    completionHandler(NSURLSessionResponseAllow);
    
    // 如果在懒加载中, 没有获得文件的总大小, 就表示第一次下载该文件
    if(self.contentLength == 0)
    {
        self.contentLength = response.expectedContentLength;
        // 写入文件
        nj_saveExpectedContentLength(self.taskURL_String, response.expectedContentLength);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.stream write:data.bytes maxLength:data.length];
    
    CGFloat progresspp = 1.0 * nj_getCompleteContentLength(self.taskURL_String, nil) / self.contentLength;
    
    
    //    NSLog(@"---%f---", progresspp);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressBlock(progresspp);
    });
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [self.stream close];
    
    self.stream = nil;
    
    self.task = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completBlock(error, nj_getFilePath(self.taskURL_String));
    });
}

- (void)start
{
    if(self.task)
    {
        if(self.task.state == NSURLSessionTaskStateSuspended)
        {
            [self.task resume];
        }
    }
}

- (void)suspend
{
    if(_task)
    {
        if(_task.state == NSURLSessionTaskStateRunning)
        {
            [_task suspend];
        }
    }
}

+ (instancetype)downloadTaskWithURL:(NSString *)URLStr progress:(void(^)(CGFloat progress))progress complete:(void(^)(NSError *error, NSString *filePath))complete
{
    NJDownloadOffLineTask *task = [[self alloc] init];
    
    task.taskURL_String = URLStr;
    
    task.progressBlock = progress;
    
    task.completBlock = complete;
    
    return task;
}

@end
