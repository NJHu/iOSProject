//
//  SINUser.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/21.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SINUser : NSObject

/** id */
@property (nonatomic, copy) NSString *idstr;

/** 昵称 */
@property (nonatomic, copy) NSString *screen_name;

/** "31",  */
@property (nonatomic, copy) NSString *province;

/** 1000 */
@property (nonatomic, copy) NSString *city;

/** 上海 */
@property (nonatomic, copy) NSString *location;

/** <#digest#> */
@property (nonatomic, copy) NSString *userDesText;

/** <#digest#> */
@property (nonatomic, strong) NSURL *url;

/** 用户头像地址（中图），50×50像素 */
@property (nonatomic, strong) NSURL *profile_image_url;

/** <#digest#> */
@property (nonatomic, strong) NSURL *cover_image;

/** <#digest#> */
@property (nonatomic, strong) NSURL *cover_image_phone;

/** gender	string	性别，m：男、f：女、n：未知*/
@property (copy, nonatomic) NSString *gender;

/** <#digest#> */
@property (nonatomic, copy) NSString *followers_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *friends_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *pagefriends_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *statuses_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *favourites_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *created_at;

/** <#digest#> */
@property (nonatomic, assign) BOOL following;

/** <#digest#> */
@property (assign, nonatomic) BOOL allow_all_act_msg;

/** <#digest#> */
@property (assign, nonatomic) BOOL geo_enabled;

/** 是否是微博认证用户，即加V用户，true：是，false：否 */
@property (assign, nonatomic) BOOL verified;

/** 认证类型. -1表示没有认证, 0表示个人认证,
 
 ///处理认证加v的图片
 switch user.verified_type
 {
 case 0:
 verifiedTypeImage_lmj = UIImage(named: "avatar_vip")?.mjGetVertifiedImage()
 case 2, 3, 5:
 verifiedTypeImage_lmj = UIImage(named: "avatar_enterprise_vip")?.mjGetVertifiedImage()
 case 220:
 verifiedTypeImage_lmj = UIImage(named: "avatar_grassroot")?.mjGetVertifiedImage()
 default:
 verifiedTypeImage_lmj = nil
 }
 
 */
@property (assign, nonatomic) NSInteger verified_type;

/** <#digest#> */
@property (nonatomic, copy) NSString *remark;


/** <#digest#> */
@property (nonatomic, copy) NSString *ptype;

/** <#digest#> */
@property (assign, nonatomic) BOOL allow_all_comment;

/** <#digest#> */
@property (nonatomic, strong) NSURL *avatar_large;

/** <#digest#> */
@property (nonatomic, strong) NSURL *avatar_hd;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_reason;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_trade;

/** <#digest#> */
@property (nonatomic, strong) NSURL *verified_reason_url;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_source;

/** <#digest#> */
@property (nonatomic, strong) NSURL *verified_source_url;


/** <#digest#> */
@property (assign, nonatomic) NSInteger verified_state;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_level;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_type_ext;

/** <#digest#> */
@property (nonatomic, copy) NSString *pay_remind;


/** <#digest#> */
@property (nonatomic, copy) NSString *pay_date;

/** <#digest#> */
@property (assign, nonatomic) BOOL has_service_tel;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_reason_modified;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_contact_name;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_contact_email;

/** <#digest#> */
@property (nonatomic, copy) NSString *verified_contact_mobile;

/** <#digest#> */
@property (assign, nonatomic) BOOL follow_me;

/** <#digest#> */
@property (assign, nonatomic) BOOL online_status;


/** <#digest#> */
@property (nonatomic, copy) NSString *bi_followers_count;

/** <#digest#> */
@property (nonatomic, copy) NSString *lang;

/** <#digest#> */
@property (nonatomic, copy) NSString *star;

/** <#digest#> */
@property (nonatomic, copy) NSString *mbtype;

/** vip的等级
 ///如理VIP等级
 if user.mbrank > 0 && user.mbrank < 7
 {
 vipImage_lmj = UIImage(named: "common_icon_membership_level\(user.mbrank)")
 }
 */
@property (nonatomic, copy) NSString *mbrank;

/** <#digest#> */
@property (nonatomic, copy) NSString *block_word;

/** <#digest#> */
@property (nonatomic, copy) NSString *block_app;

/** <#digest#> */
@property (nonatomic, copy) NSString *credit_score;

/** <#digest#> */
@property (nonatomic, copy) NSString *user_ability;

/** <#digest#> */
@property (nonatomic, copy) NSString *urank;

/** <#digest#> */
@property (nonatomic, copy) NSString *story_read_state;




@end












