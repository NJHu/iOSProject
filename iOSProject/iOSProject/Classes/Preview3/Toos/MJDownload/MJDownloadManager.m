//
//  MJDownloadManager.m
//  MJDownloadExample
//
//  Created by MJ Lee on 15/7/16.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "MJDownloadManager.h"
#import "NSString+MJDownload.h"
#import "MJDownloadConst.h"

/** 存放所有的文件大小 */
static NSMutableDictionary *_totalFileSizes;
/** 存放所有的文件大小的文件路径 */
static NSString *_totalFileSizesFile;

/** 根文件夹 */
static NSString * const MJDownloadRootDir = @"com_github_njhu_www_mjdownload";

/** 默认manager的标识 */
static NSString * const MJDowndloadManagerDefaultIdentifier = @"com.github.njhu.www.downloadmanager";

/****************** MJDownloadInfo Begin ******************/
@interface MJDownloadInfo()
{
    MJDownloadState _state;
    NSInteger _totalBytesWritten;
}
/******** Readonly Begin ********/
/** 下载状态 */
@property (assign, nonatomic) MJDownloadState state;
/** 这次写入的数量 */
@property (assign, nonatomic) NSInteger bytesWritten;
/** 已下载的数量 */
@property (assign, nonatomic) NSInteger totalBytesWritten;
/** 文件的总大小 */
@property (assign, nonatomic) NSInteger totalBytesExpectedToWrite;
/** 文件名 */
@property (copy, nonatomic) NSString *filename;
/** 文件路径 */
@property (copy, nonatomic) NSString *file;
/** 文件url */
@property (copy, nonatomic) NSString *url;
/** 下载的错误信息 */
@property (strong, nonatomic) NSError *error;
/** 下载速度 */
@property (strong, nonatomic) NSNumber *speed;
/******** Readonly End ********/

/** 存放所有的进度回调 */
@property (copy, nonatomic) MJDownloadProgressChangeBlock progressChangeBlock;
/** 存放所有的完毕回调 */
@property (copy, nonatomic) MJDownloadStateChangeBlock stateChangeBlock;
/** 任务 */
@property (strong, nonatomic) NSURLSessionDataTask *task;
/** 文件流 */
@property (strong, nonatomic) NSOutputStream *stream;
@end

@implementation MJDownloadInfo
- (NSString *)file
{
    if (_file == nil) {
        _file = [[NSString stringWithFormat:@"%@/%@", MJDownloadRootDir, self.filename] prependCaches];
    }
    if (_file && ![[NSFileManager defaultManager] fileExistsAtPath:_file]) {
        
        NSString *dir = [_file stringByDeletingLastPathComponent]; // caches/rootDir/asd.mp4
        
        BOOL isDir = NO;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir]) {
            if (!isDir) {
                 [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }

    }
    return _file;
}

- (NSString *)filename
{
    if (_filename == nil) {
        NSString *pathExtension = self.url.pathExtension;
        if (pathExtension.length) {
            _filename = [NSString stringWithFormat:@"%@.%@", self.url.MD5, pathExtension];
        } else {
            _filename = self.url.MD5;
        }
    }
    return _filename;
}

- (NSOutputStream *)stream
{
    if (_stream == nil) {
        _stream = [NSOutputStream outputStreamToFileAtPath:self.file append:YES];
    }
    return _stream;
}

- (NSInteger)totalBytesWritten
{
    return [[[NSFileManager defaultManager] attributesOfItemAtPath:self.file error:nil][NSFileSize] integerValue];
}

- (NSInteger)totalBytesExpectedToWrite
{
    if (!_totalBytesExpectedToWrite) {
        _totalBytesExpectedToWrite = [_totalFileSizes[self.url] integerValue];
    }
    return _totalBytesExpectedToWrite;
}

- (MJDownloadState)state
{
    // 如果是下载完毕
    if (self.totalBytesExpectedToWrite > 0 && self.totalBytesWritten >= self.totalBytesExpectedToWrite) {
        return MJDownloadStateCompleted;
    }
//    NSURLSessionTaskStateRunning = 0,                     /* The task is currently being serviced by the session */
//    NSURLSessionTaskStateSuspended = 1,
//    NSURLSessionTaskStateCanceling = 2,                   /* The task has been told to cancel.  The session will receive a URLSession:task:didCompleteWithError: message. */
//    NSURLSessionTaskStateCompleted = 3,                   /* The task has completed and the session will receive no more delegate notifications */
    
    // 如果下载失败
    if (self.task.error) return MJDownloadStateNone;
    return _state;
}

/**
 *  初始化任务
 */
- (void)setupTask:(NSURLSession *)session
{
    if (self.task) return;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.totalBytesWritten];
    [request setValue:range forHTTPHeaderField:@"Range"];
    
    self.task = [session dataTaskWithRequest:request];
    // 设置描述
    self.task.taskDescription = self.url;
}

/**
 *  通知进度改变
 */
- (void)notifyProgressChange
{
    !self.progressChangeBlock ? : self.progressChangeBlock(self.bytesWritten, self.totalBytesWritten, self.totalBytesExpectedToWrite);
    [MJDownloadNoteCenter postNotificationName:MJDownloadProgressDidChangeNotification
                                        object:self
                                      userInfo:@{MJDownloadInfoKey : self}];
}

/**
 *  通知下载状态改变
 */
- (void)notifyStateChange
{
    !self.stateChangeBlock ? : self.stateChangeBlock(self.state, self.file, self.error);
    [MJDownloadNoteCenter postNotificationName:MJDownloadStateDidChangeNotification
                                        object:self
                                      userInfo:@{MJDownloadInfoKey : self}];
}

#pragma mark - 状态控制
- (void)setState:(MJDownloadState)state
{
    if (!self.task) {
        return;
    }
    
    MJDownloadState oldState = _state;
    if (state == oldState) return;
    _state = state;
    
    // 发通知
    [self notifyStateChange];
}

/**
 *  取消
 */
- (void)cancel
{
    if (self.state == MJDownloadStateCompleted || self.state == MJDownloadStateNone) return;
    [self.task cancel];
    self.state = MJDownloadStateNone;
}

/**
 *  恢复
 */
- (void)resume
{
//    MJDownloadStateNone = 0,     // 闲置状态（除后面几种状态以外的其他状态）
//    MJDownloadStateWillResume = 1,   // 即将下载（等待下载）
//    MJDownloadStateResumed = 2,      // 下载中
//    MJDownloadStateSuspened = 3,     // 暂停中
//    MJDownloadStateCompleted = 4     // 已经完全下载完毕
    
    if (self.state == MJDownloadStateCompleted || self.state == MJDownloadStateResumed) return;
    
    [self.task resume];
    self.state = MJDownloadStateResumed;
}

/**
 * 等待下载
 */
- (void)willResume
{
    if (self.state == MJDownloadStateCompleted || self.state == MJDownloadStateWillResume) return;
    self.state = MJDownloadStateWillResume;
}

/**
 *  暂停
 */
- (void)suspend
{
    if (self.state == MJDownloadStateCompleted || self.state == MJDownloadStateSuspened) return;
    
    if (self.state == MJDownloadStateResumed) { // 如果是正在下载
        [self.task suspend];
        self.state = MJDownloadStateSuspened;
    } else { // 如果是等待下载
        self.state = MJDownloadStateNone;
    }
}

#pragma mark - 代理方法处理
- (void)didReceiveResponse:(NSHTTPURLResponse *)response
{
    // 获得文件总长度
    if (!self.totalBytesExpectedToWrite) {
        NSLog(@"%@", response.allHeaderFields);
        NSLog(@"==== %zd =====", (NSUInteger)response.expectedContentLength);
        self.totalBytesExpectedToWrite = [response.allHeaderFields[@"Content-Length"] integerValue] + self.totalBytesWritten;
        
        // 存储文件总长度
        _totalFileSizes[self.url] = @(self.totalBytesExpectedToWrite);
        [_totalFileSizes writeToFile:_totalFileSizesFile atomically:YES];
    }
    
    // 打开流
    [self.stream open];
    
    // 清空错误
    self.error = nil;
}

- (void)didReceiveData:(NSData *)data
{
    // 写数据
    NSInteger result = [self.stream write:data.bytes maxLength:data.length];
    
    if (result == -1) {
        self.error = self.stream.streamError;
        [self.task cancel]; // 取消请求
    }else{
        self.bytesWritten = data.length;
        [self notifyProgressChange]; // 通知进度改变
    }
}

- (void)didCompleteWithError:(NSError *)error
{
    // 关闭流
    [self.stream close];
    
    // 错误(避免nil的error覆盖掉之前设置的self.error)
    self.error = error ? error : self.error;
    
    // 通知(如果下载完毕 或者 下载出错了)
    if (self.state == MJDownloadStateCompleted || error) {
        // 设置状态
        self.state = error ? MJDownloadStateNone : MJDownloadStateCompleted;
    }
    
    self.bytesWritten = 0;
    self.stream = nil;
    self.task = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"url = %@, state = %zd", self.url, self.state];
}

@end
/****************** MJDownloadInfo End ******************/


/****************** MJDownloadManager Begin ******************/
@interface MJDownloadManager() <NSURLSessionDataDelegate>
/** session */
@property (strong, nonatomic) NSURLSession *session;
///** 存放所有文件的下载信息 */
//@property (strong, nonatomic) NSMutableArray<MJDownloadInfo *> *downloadInfoArray;
/** 是否正在批量处理 */
@property (assign, nonatomic, getter=isBatching) BOOL batching;
@end

@implementation MJDownloadManager

/** 存放所有的manager */
static NSMutableDictionary *_managers;
/** 锁 */
static NSLock *_lock;

+ (void)initialize
{
    _totalFileSizesFile = [[NSString stringWithFormat:@"%@/%@", MJDownloadRootDir, @"MJDownloadFileSizes.plist".MD5] prependCaches];
    
    _totalFileSizes = [NSMutableDictionary dictionaryWithContentsOfFile:_totalFileSizesFile];
    if (_totalFileSizes == nil) {
        _totalFileSizes = [NSMutableDictionary dictionary];
    }
    
    _managers = [NSMutableDictionary dictionary];
    
    _lock = [[NSLock alloc] init];
}

+ (instancetype)defaultManager
{
    return [self managerWithIdentifier:MJDowndloadManagerDefaultIdentifier];
}

+ (instancetype)manager
{
    return [[self alloc] init];
}

+ (instancetype)managerWithIdentifier:(NSString *)identifier
{
    if (identifier == nil) return [self manager];
    
    MJDownloadManager *mgr = _managers[identifier];
    if (!mgr) {
        mgr = [self manager];
        _managers[identifier] = mgr;
    }
    return mgr;
}

- (instancetype)init {
    if (self = [super init]) {
        _maxDownloadingCount = 3;
    }
    return self;
}

#pragma mark - 懒加载
- (NSURLSession *)session
{
    if (!_session) {
        // 配置
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        cfg.timeoutIntervalForRequest = 18.0;
        // session
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:self.queue];
    }
    return _session;
}

- (NSOperationQueue *)queue
{
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

- (NSMutableArray<MJDownloadInfo *> *)downloadInfoArray
{
    if (!_downloadInfoArray) {
        _downloadInfoArray = [NSMutableArray array];
    }
    return _downloadInfoArray;
}


#pragma mark - 公共方法
- (MJDownloadInfo *)download:(NSString *)url toDestinationPath:(NSString *)destinationPath progress:(MJDownloadProgressChangeBlock)progress state:(MJDownloadStateChangeBlock)state
{
    if (url == nil) return nil;
    
    // 下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 设置block
    info.progressChangeBlock = progress;
    info.stateChangeBlock = state;
    
    // 设置文件路径
    if (destinationPath) {
        info.file = destinationPath;
        info.filename = [destinationPath lastPathComponent];
    }
    
    // 如果已经下载完毕
    if (info.state == MJDownloadStateCompleted) {
        // 完毕
        [info notifyStateChange];
        return info;
    } else if (info.state == MJDownloadStateResumed) {
        return info;
    }
    
    // 创建任务
    [info setupTask:self.session];
    
    // 开始任务
    [self resume:url];
    
    return info;
}

- (MJDownloadInfo *)download:(NSString *)url progress:(MJDownloadProgressChangeBlock)progress state:(MJDownloadStateChangeBlock)state
{
    return [self download:url toDestinationPath:nil progress:progress state:state];
}

- (MJDownloadInfo *)download:(NSString *)url state:(MJDownloadStateChangeBlock)state
{
    return [self download:url toDestinationPath:nil progress:nil state:state];
}

- (MJDownloadInfo *)download:(NSString *)url
{
    return [self download:url toDestinationPath:nil progress:nil state:nil];
}

#pragma mark - 文件操作
/**
 * 让第一个等待下载的文件开始下载
 */
- (void)resumeFirstWillResume
{
    if (self.isBatching) return;
    
        if (self.downloadInfoArray.count > 0) {
            MJDownloadInfo *willInfo = [self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateWillResume]].firstObject;
            [self resume:willInfo.url];
        }
    
//    @synchronized(self) {
//        [self.downloadInfoArray enumerateObjectsUsingBlock:^(MJDownloadInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//            if (obj.state == MJDownloadStateWillResume) {
//                [self resume:obj.url];
//                *stop = YES;
//            }
//        }];
//    }
}

- (void)cancelAll
{
    self.batching = YES;
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(MJDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self cancel:info.url];
    }];
    self.batching = NO;
}

+ (void)cancelAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(cancelAll)];
}

- (void)suspendAll
{
    // 暂停
    self.batching = YES;
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(MJDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self suspend:info.url];
    }];
    self.batching = NO;
}

+ (void)suspendAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(suspendAll)];
}

- (void)resumeAll
{
    self.batching = YES;
    [self.downloadInfoArray enumerateObjectsUsingBlock:^(MJDownloadInfo *info, NSUInteger idx, BOOL *stop) {
        [self resume:info.url];
    }];
    self.batching = NO;
}

+ (void)resumeAll
{
    [_managers.allValues makeObjectsPerformSelector:@selector(resumeAll)];
}

- (void)cancel:(NSString *)url
{
    if (url == nil) return;
    
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 取消
    [info cancel];
    
    // 这里不需要取出第一个等待下载的，因为调用cancel会触发-URLSession:task:didCompleteWithError:
//    [self resumeFirstWillResume];
}

- (void)suspend:(NSString *)url
{
    if (url == nil) return;
    
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 暂停
    [info suspend];
    
    // 取出第一个等待下载的
    [self resumeFirstWillResume];
}

- (void)resume:(NSString *)url
{
    if (url == nil) return;
    
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:url];
    
    // 状态已经在下载啦
    if (info.state == MJDownloadStateResumed) {
        return;
    }
    
    // 下载中的
//    NSArray *downloadingDownloadInfoArray = [self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateResumed]];
    
    // 加锁, 多个线程同时访问就不准确了
    @synchronized(self) {
        if (self.downloadInfoArray.count == 0) {
            return;
        }
        
        // 需要调用 getter 方法
        NSArray<MJDownloadInfo *> *downloadingDownloadInfoArrayM = [self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"state==%d", MJDownloadStateResumed]];
        if (self.maxDownloadingCount > 0 && downloadingDownloadInfoArrayM.count >= self.maxDownloadingCount) {
            // 等待下载
            [info willResume];
        } else {
            // MJ Bug fix
            // 出错以后就没有 task 了...bug fix, 下载失败重新下载
            if (info.error && !info.task) {
                [info setupTask:self.session];
            }
            // 继续
            [info resume];
        }
        
    }
}

#pragma mark - 获得下载信息
- (MJDownloadInfo *)downloadInfoForURL:(NSString *)url
{
    if (url == nil) return nil;
    // 加锁, 防止多个线程同时下载一个 URL
    [_lock lock];
    MJDownloadInfo *info = [self.downloadInfoArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"url==%@", url]].firstObject;
    if (info == nil) {
        info = [[MJDownloadInfo alloc] init];
        info.url = url; // 设置url
        [self.downloadInfoArray addObject:info];
    }
    [_lock unlock];
    return info;
}

#pragma mark - <NSURLSessionDataDelegate>
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSHTTPURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
    
    // 处理响应
    [info didReceiveResponse:response];
    
    // 继续
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:dataTask.taskDescription];
    
    // 处理数据
    [info didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 获得下载信息
    MJDownloadInfo *info = [self downloadInfoForURL:task.taskDescription];
    
    // 处理结束
    [info didCompleteWithError:error];
    
    // 恢复等待下载的
    [self resumeFirstWillResume];
}
@end
/****************** MJDownloadManager End ******************/
