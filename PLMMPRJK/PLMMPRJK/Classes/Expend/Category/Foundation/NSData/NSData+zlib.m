@import Foundation;

#import <zlib.h>

#import "NSData+zlib.h"

static const uInt CHUNK_SIZE = 65536;

NSString *const BBSZlibErrorDomain = @"se.bitba.ZlibErrorDomain";
NSString *const BBSZlibErrorInfoKey = @"zerror";

@implementation NSData (zlib)

- (NSData *)bbs_dataByInflatingWithError:(NSError *__autoreleasing *)error
{
    if (![self length]) return [self copy];
    NSMutableData *outData = [NSMutableData data];
    [self inflate:^(NSData *toAppend) {
        [outData appendData:toAppend];
    }
            error:error];
    return outData;
}

- (NSData *)bbs_dataByDeflatingWithError:(NSError *__autoreleasing *)error
{
    if (![self length]) return [self copy];
    NSMutableData *outData = [NSMutableData data];
    [self deflate:^(NSData *toAppend) {
        [outData appendData:toAppend];
    }
            error:error];
    return outData;
}

// Adapted from http://www.zlib.net/zpipe.c
- (BOOL)inflate:(void (^)(NSData *))processBlock
          error:(NSError *__autoreleasing *)error
{
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = 0;
    stream.next_in = Z_NULL;

    int ret = inflateInit(&stream);
    if (ret != Z_OK) {
        if (error) *error = [NSError errorWithDomain:BBSZlibErrorDomain
                                                code:BBSZlibErrorCodeInflationError
                                            userInfo:@{BBSZlibErrorInfoKey : @(ret)}];
        return NO;
    }
    Bytef *source = (Bytef *)[self bytes]; // yay
    uInt offset = 0;
    uInt len = (uInt)[self length];

    do {
        stream.avail_in = MIN(CHUNK_SIZE, len - offset);
        if (stream.avail_in == 0) break;
        stream.next_in = source + offset;
        offset += stream.avail_in;
        do {
            Bytef out[CHUNK_SIZE];
            stream.avail_out = CHUNK_SIZE;
            stream.next_out = out;
            ret = inflate(&stream, Z_NO_FLUSH);
            switch (ret) {
                case Z_NEED_DICT:
                case Z_DATA_ERROR:
                case Z_MEM_ERROR:
                case Z_STREAM_ERROR:
                    inflateEnd(&stream);
                    if (error) *error = [NSError errorWithDomain:BBSZlibErrorDomain
                                                            code:BBSZlibErrorCodeInflationError
                                                        userInfo:@{BBSZlibErrorInfoKey : @(ret)}];
                    return NO;
            }
            processBlock([NSData dataWithBytesNoCopy:out
                                              length:CHUNK_SIZE - stream.avail_out
                                        freeWhenDone:NO]);
        } while (stream.avail_out == 0);
    } while (ret != Z_STREAM_END);

    inflateEnd(&stream);
    return YES;
}

// Adapted from http://www.zlib.net/zpipe.c
- (BOOL)deflate:(void (^)(NSData *))processBlock
          error:(NSError *__autoreleasing *)error
{
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;

    int ret = deflateInit(&stream, 9);
    if (ret != Z_OK) {
        if (error) *error = [NSError errorWithDomain:BBSZlibErrorDomain
                                                code:BBSZlibErrorCodeDeflationError
                                            userInfo:@{BBSZlibErrorInfoKey : @(ret)}];
        return NO;
    }
    Bytef *source = (Bytef *)[self bytes]; // yay
    uInt offset = 0;
    uInt len = (uInt)[self length];
    int flush;

    do {
        stream.avail_in = MIN(CHUNK_SIZE, len - offset);
        stream.next_in = source + offset;
        offset += stream.avail_in;
        flush = offset > len - 1 ? Z_FINISH : Z_NO_FLUSH;
        do {
            Bytef out[CHUNK_SIZE];
            stream.avail_out = CHUNK_SIZE;
            stream.next_out = out;
            ret = deflate(&stream, flush);
            if (ret == Z_STREAM_ERROR) {
                if (error) *error = [NSError errorWithDomain:BBSZlibErrorDomain
                                                        code:BBSZlibErrorCodeDeflationError
                                                    userInfo:@{BBSZlibErrorInfoKey : @(ret)}];
                return NO;
            }
            processBlock([NSData dataWithBytesNoCopy:out
                                              length:CHUNK_SIZE - stream.avail_out
                                        freeWhenDone:NO]);
        } while (stream.avail_out == 0);
    } while (flush != Z_FINISH);
    deflateEnd(&stream);
    return YES;
}

- (BOOL)bbs_writeDeflatedToFile:(NSString *)path
                          error:(NSError *__autoreleasing *)error
{
    NSFileHandle *f = createOrOpenFileAtPath(path, error);
    if (!f) return NO;
    BOOL success = YES;
    if ([self length]) {
        success = [self deflate:
                   ^(NSData *toAppend) {
                       [f writeData:toAppend];
                   }
                          error:error];
    } else {
        [f writeData:self];
    }
    [f closeFile];
    return success;
}

- (BOOL)bbs_writeInflatedToFile:(NSString *)path
                          error:(NSError *__autoreleasing *)error
{
    NSFileHandle *f = createOrOpenFileAtPath(path, error);
    if (!f) return NO;
    BOOL success = YES;
    if ([self length]) {
        success = [self inflate:
                   ^(NSData *toAppend) {
                       [f writeData:toAppend];
                   }
                          error:error];
    } else {
        [f writeData:self];
    }
    [f closeFile];
    return success;
}

static NSFileHandle *createOrOpenFileAtPath(NSString *path, NSError *__autoreleasing *error)
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL success = [[NSFileManager defaultManager] createFileAtPath:path
                                                               contents:nil
                                                             attributes:nil];
        if (!success) {
            if (error) *error = [NSError errorWithDomain:BBSZlibErrorDomain
                                                    code:BBSZlibErrorCodeCouldNotCreateFileError
                                                userInfo:nil];
            return nil;
        }
    }
    return [NSFileHandle fileHandleForWritingAtPath:path];
}

@end
