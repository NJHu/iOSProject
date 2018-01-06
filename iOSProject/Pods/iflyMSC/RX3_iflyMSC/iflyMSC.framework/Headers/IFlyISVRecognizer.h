//
//  IFlyISVRecognizer.h
//  ISV
//
//  Created by wangdan on 14-9-6.
//  Copyright (c) 2014年 IFlyTEK. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "IFlyISVDelegate.h"

/**
 *  声纹接口类
 */
@interface IFlyISVRecognizer : NSObject 
{

}
@property (assign) id<IFlyISVDelegate> delegate;



/*
 * FlyISVRecognizer is a kind of Singleton calss
 * the function can be used as below:
   IFLyISVRecognizer *recognizer=[IFlyISVRecognizer creteRecognizer: self];
 */

+(IFlyISVRecognizer *) sharedInstance;


/*
 * genrerate a serial number password
 * princeple:
   1.number serial has no 1 in itself;
   2.the nuber serial has no same number("98765432"is right while "99876543" is wrong)
 * @length: the serial number's length,length of "98765432" is 8,  
   generally length is 8 and other value is forbidden
 */

-(NSString*) generatePassword:(int)length;



/*
 * Used to get password from server
 * @pwdt:
   when pwdt is 1,the function will return chinese text;
   while pwdt is 2, the funciton will return number serial
 */

-(NSArray*) getPasswordList:(int)pwdt;


/*
 * Used to judge if the engine is running in listenning
 * return value:
   YES: the engine is listenning;
   No : the engine is not listenning
 */
-(BOOL) isListening;



/*
 * Used to query or delete the voiceprint model in server
 * @cmd:
    "del": delete model
    "que": query model
 * @authid: user id ,can be @"tianxia" or other;
 * @pwdt: voiceprint type
    1: fixed txt voiceprint code ,like @"我的地盘我做主"   
    2: free voiceprint code , user can speek anything,but 5 times 
       trainning the speech shall be same
    3: number serial voiceprint code ,like @"98765432" and so on
 * @ptxt: voiceprint txt,only fixed voiceprint and number serial have this,
    in free voiceprint model this param shall be set nil
 * @vid: another voiceprint type model,user can use this to query or delete
    model in server can be @"jakillasdfasdjjjlajlsdfhdfdsadff",totally 32 bits;
 * NOTES:
   when vid is not nil,then the server will judge the vid first
   while the vid is nil, server can still query or delete the voiceprint model 
   by other params
 */
-(BOOL) sendRequest:(NSString*)cmd authid:(NSString *)auth_id  pwdt:(int)pwdt ptxt:(NSString *)ptxt vid:(NSString *)vid err:(int *)err;


/*
 * set the voiceprint params
 * @"sst"            : @"train" or @"verify"
 * @"auth_id"        : @"tianxia" or ther
 * @"sub"            : @"ivp"
 * @"ptxt"           :
 * @"rgn"            : @"5"
 * @"pwdt"           : @"1",or @"2", or @"3"
 * @"auf"            : @"audio/L16;rate=16000" or @"audio/L16;rate=8000"
 * @"vad_enable      : @"1" or @"0"
 * @"vad_timeout"    : @"3000"
 * @"vad_speech_tail": @"100"
 */
-(BOOL) setParameter:(NSString *)value forKey:(NSString *)key;



/*
 * get the voiceprint params
 * used the same as function of setParameter
 */
-(NSString*) getParameter:(NSString *)key;


/*
 * start recording
 */
-(void) startListening;


/*
 * stop recording
 */
-(void) stopListening;


/*
 * cancel recording,like function stopListening
 */
-(void) cancel;                                                         /* cancel recognization */




@end

