//
//  PermissionDetector.m
//  IFlyMFVDemo
//
//  Created by 付正 on 16/3/1.
//
//

#import "PermissionDetector.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PermissionDetector

/**
 *  检测麦克风权限，仅支持iOS7.0以上系统
 *
 *  @return 准许返回YES;否则返回NO
 */
+(BOOL)isMicrophonePermissionGranted{
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        __block BOOL isGranted=YES;
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            isGranted=granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        return isGranted;
    }
    else{
        return YES;
    }
}

/**
 *  检测相机权限
 *
 *  @return 准许返回YES;否则返回NO
 */
+(BOOL)isCapturePermissionGranted{
    if([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)]){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus ==AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
            return NO;
        }
        else if(authStatus==AVAuthorizationStatusNotDetermined){
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL isGranted=YES;
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                 isGranted=granted;
                 dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return isGranted;
        }
        else{
            return YES;
        }
    }
    else{
        return YES;
    }
}

/**
 *  检测相册权限
 *
 *  @return 准许返回YES;否则返回NO
 */
+(BOOL)isAssetsLibraryPermissionGranted{
    if([ALAssetsLibrary respondsToSelector:@selector(authorizationStatus)]){
        ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusRestricted || authStatus ==ALAuthorizationStatusDenied){
             return NO;
        }
        else if( authStatus== ALAuthorizationStatusNotDetermined){
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            __block BOOL isGranted=YES;
            
            dispatch_queue_t dispatchQueue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(dispatchQueue, ^(void) {
                ALAssetsLibrary * assetsLibrary=[[ALAssetsLibrary alloc] init];
                [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                    isGranted=YES;
                    *stop = YES;
                    NSLog(@"enumerate");
                    dispatch_semaphore_signal(sema);
                } failureBlock:^(NSError *error) {
                    isGranted=NO;
                    NSLog(@"error:%ld %@",(long)error.code,error.description);
                    dispatch_semaphore_signal(sema);
                }];
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            return isGranted;
        }
        else{
            return YES;
        }
    }else{
        return YES;
    }
}

@end
