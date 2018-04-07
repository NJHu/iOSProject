//
//  LMJRSAViewController.m
//  iOSProject
//
//  Created by HuXuPeng on 2018/3/28.
//  Copyright © 2018年 github.com/njhu. All rights reserved.
//

#import "LMJRSAViewController.h"
#import "EncryptorTool.h"

@interface LMJRSAViewController ()
@property (nonatomic, copy) NSString *oriMsg;
/**  DES */
@property (nonatomic, copy) NSString *DESKey;
/** 私钥字符串 */
@property (nonatomic, copy) NSString *javaPriKey;
/** 公钥字符串 */
@property (nonatomic, copy) NSString *javaPubKey;

/** <#digest#> */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation LMJRSAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSteps];
    [self setUpKeys];
    
    // Der 加密 P12 解密
    [self DerP12];
    
    // Pem 加密 P12 解密
    [self PemP12];
    
    // Pem 加密 Pem 解密
    [self PemPem];
    
    // Der 加密 Pem 解密
    [self DerPem];
    
    LMJWeak(self);
    LMJWordItem *item = [LMJWordItem itemWithTitle:@"网络数据加密解密" subTitle:@"Demo" itemOperation:^(NSIndexPath *indexPath) {
        // 网络加密解密
        [weakself requestDataEncrypt];
    }];
    [self.sections addObject:[LMJItemSection sectionWithItems:@[item] andHeaderTitle:@"网络数据加密" footerTitle:@"END"]];
}

- (void)requestDataEncrypt
{
    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:@{
         @"sessionId" : @"eyJhbGciOiJIUzUxMiJ9.eyJpYXQiOjE1MjI3NTI3MjEsInN1YiI6IntcImRpc2FibGVkXCI6ZmFsc2UsXCJpZFwiOjE0NzMzMjUsXCJsb2dpbk5hbWVcIjpcIk0xNTYwMDYwMDAwMlwiLFwibW9iaWxlXCI6XCIxNTYwMDYwMDAwMlwiLFwicm9sZU5hbWVzXCI6W1wiSU5WRVNUT1JcIl19In0.ZmE_RyS2ba6g6paa_56V_YZ0FKX5QrKMaRp2X82UdoZjglUCWxOp81Nuv-FKHWyTEJupwrhGR81IwIoKPnUM8g",
         @"versionCode" : @"380",
         @"platformType" : @"5",
         @"channelId" : @"ios",
         @"deviceId" : @"06761B15-C2E0-4A8F-8C5C-BBBB07261059",
         @"msgeps" : @"",
         @"msgnonce" : @"",
         @"msgtimestamp" : @"",
         @"operationChannel": @"3"}];
    
    // 时间戳
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    dateformatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *timestmp = [dateformatter stringFromDate:[NSDate date]];
    
    // UUID
    NSString *uuid = @"0BE8421A-6A0A-4F3D-BDCE-C2DD78BD65D0";
    
    // nonce
    NSString *nonce = [[NSString stringWithFormat:@"%@%@%@%@",dictM[@"platformType"], dictM[@"deviceId"], timestmp, uuid] md5String];

    // 时间戳
    dictM[@"msgtimestamp"] = timestmp;
    // 唯一性
    dictM[@"msgnonce"] = nonce;
    
    // 把字典生成字符串
    NSString *content = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dictM options:0 error:nil] encoding:NSUTF8StringEncoding];
    
    
    // 加密, 生成随机的字符串
    NSString *pkey = [NSString ret24BitString];
    NSString *mkey = [NSString ret24BitString];
    
    //把pkey， mkey 做rsa加密, 放到请求头, 服务器得到请求头后rsa解密拿到pkey, mkey,  前24位 pkey, 后24位 mkey
    //   @"%@%@", pkey, mkey  RSA
    NSString *key = [RSAEncryptor encryptString:[NSString stringWithFormat:@"%@%@", pkey, mkey] publicKeyWithContentsOfFile:publicKeyFile_];
    [self.manager.requestSerializer setValue:key forHTTPHeaderField:@"msgkey"];
    
    
    //    @"%@%@%@", pkey, content, mkey    DES3   mkey, 服务器拿到消息内容作对比
    NSString *sign = [DES3Encryptor DES3EncryptString:[NSString stringWithFormat:@"%@%@%@", pkey, content, mkey].md5String keyString:mkey ivString:@"01234567"];
    [self.manager.requestSerializer setValue:sign forHTTPHeaderField:@"msgsign"];
    
    //content DES3 pkey
    NSString *contentDES = [DES3Encryptor DES3EncryptString:content keyString:pkey ivString:@"01234567"];
    
    [self.manager POST:@"https://mob-test-tech.meme2c.com/ums/app/mmUserInfo" parameters:contentDES progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            return ;
        }
        NSString *responseString = [DES3Encryptor DES3EncryptString:responseObject[@"msg"] keyString:pkey ivString:@"01234567"];
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        
        NSLog(@"%@", responseDict);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@", task.response);
        NSLog(@"%@", error);
        
    }];
}

// Der 加密 P12 解密
- (void)DerP12
{
    LMJWeak(self);
    // ======================================================================================================
    self.addItem([LMJWordItem itemWithTitle:@"点击加密: " subTitle:self.oriMsg itemOperation:^(NSIndexPath *indexPath) {
        NSString *encryptedMsg = [EncryptorTool EncryptMsg:weakself.oriMsg DESKey:weakself.DESKey];
        
        LMJWordItem *item1 = weakself.sections[0].items[1];
        item1.subTitle = encryptedMsg;
        
        [weakself.tableView reloadRow:1 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }])
    .addItem([LMJWordItem itemWithTitle:@"加密后的内容:" subTitle:@"" ])
    .addItem([LMJWordItem itemWithTitle:@"点击解密: " subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        LMJWordItem *item1 = weakself.sections[0].items[1];
        NSString *encryptedMsg = item1.subTitle;
        
        LMJWordItem *item2 = weakself.sections[0].items[2];
        item2.subTitle = [EncryptorTool DecryptMsg:encryptedMsg DESKey:weakself.DESKey];
        
        [weakself.tableView reloadRow:2 inSection:0 withRowAnimation:UITableViewRowAnimationFade];
    }]);
    
    weakself.sections.firstObject.headerTitle = @".der加密, .p12解密";
    weakself.sections.firstObject.footerTitle = @"END";
    
}

- (void)PemP12
{
    LMJWeak(self);
    LMJWordItem *item10 = [LMJWordItem itemWithTitle:@"点击加密: " subTitle:self.oriMsg itemOperation:^(NSIndexPath *indexPath) {
        
        NSString *encryptedMsg = [RSAEncryptor encryptString:weakself.oriMsg publicKey:weakself.javaPubKey];
        
        LMJWordItem *item1 = weakself.sections[1].items[1];
        item1.subTitle = encryptedMsg;
        
        [weakself.tableView reloadRow:1 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    LMJWordItem *item11 = [LMJWordItem itemWithTitle:@"加密后的内容:" subTitle:@""];
    
    LMJWordItem *item12 = [LMJWordItem itemWithTitle:@"点击解密: " subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        
        LMJWordItem *item1 = weakself.sections[1].items[1];
        NSString *encryptedMsg = item1.subTitle;
        
        LMJWordItem *item2 = weakself.sections[1].items[2];
        NSLog(@"%@", privateKeyFile_);
        NSLog(@"%@", privateKeyFileP12Password_);
        item2.subTitle = [RSAEncryptor decryptString:encryptedMsg privateKeyWithContentsOfFile:privateKeyFile_ password:privateKeyFileP12Password_];
        
        [weakself.tableView reloadRow:2 inSection:1 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    LMJItemSection *section1 = [LMJItemSection sectionWithItems:@[item10, item11, item12] andHeaderTitle:@"pub.pem加密, .p12解密" footerTitle:@"END"];
    
    [self.sections addObject:section1];
}


- (void)PemPem
{
    LMJWeak(self);
    LMJWordItem *item20 = [LMJWordItem itemWithTitle:@"点击加密: " subTitle:self.oriMsg itemOperation:^(NSIndexPath *indexPath) {
        
        NSString *encryptedMsg = [RSAEncryptor encryptString:weakself.oriMsg publicKey:weakself.javaPubKey];
        
        LMJWordItem *item1 = weakself.sections[2].items[1];
        item1.subTitle = encryptedMsg;
        
        [weakself.tableView reloadRow:1 inSection:2 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    LMJWordItem *item21 = [LMJWordItem itemWithTitle:@"加密后的内容:" subTitle:@""];
    
    LMJWordItem *item22 = [LMJWordItem itemWithTitle:@"点击解密: " subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        LMJWordItem *item1 = weakself.sections[2].items[1];
        NSString *encryptedMsg = item1.subTitle;
        
        LMJWordItem *item2 = weakself.sections[2].items[2];
        
        item2.subTitle = [RSAEncryptor decryptString:encryptedMsg privateKey:weakself.javaPriKey];
        
        [weakself.tableView reloadRow:2 inSection:2 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    LMJItemSection *section2 = [LMJItemSection sectionWithItems:@[item20, item21, item22] andHeaderTitle:@"pub.pem加密, pri.pem解密" footerTitle:@"END"];
    [self.sections addObject:section2];
}

- (void)DerPem
{
    LMJWeak(self);
    LMJWordItem *item30 = [LMJWordItem itemWithTitle:@"点击加密: " subTitle:self.oriMsg itemOperation:^(NSIndexPath *indexPath) {
        
        NSString *encryptedMsg = [RSAEncryptor encryptString:weakself.oriMsg publicKeyWithContentsOfFile:publicKeyFile_];
        
        LMJWordItem *item1 = weakself.sections[3].items[1];
        item1.subTitle = encryptedMsg;
        
        [weakself.tableView reloadRow:1 inSection:3 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    LMJWordItem *item31 = [LMJWordItem itemWithTitle:@"加密后的内容:" subTitle:@""];
    
    LMJWordItem *item32 = [LMJWordItem itemWithTitle:@"点击解密: " subTitle:@"" itemOperation:^(NSIndexPath *indexPath) {
        
        LMJWordItem *item1 = weakself.sections[3].items[1];
        NSString *encryptedMsg = item1.subTitle;
        
        LMJWordItem *item2 = weakself.sections[3].items[2];
        
        item2.subTitle = [RSAEncryptor decryptString:encryptedMsg privateKey:weakself.javaPriKey];
        
        [weakself.tableView reloadRow:2 inSection:3 withRowAnimation:UITableViewRowAnimationFade];
        
    }];
    
    LMJItemSection *section3 = [LMJItemSection sectionWithItems:@[item30, item31, item32] andHeaderTitle:@".der加密, pri.pem解密" footerTitle:@"END"];
    
    [self.sections addObject:section3];
}

- (void)setUpKeys
{
    self.javaPriKey = @"-----BEGIN PRIVATE KEY-----\
    MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAK0IhWKuHWSnGmyL\
    0224gICKcG7LkZoh/8w82XABjcFA3eiDdcREE9+d3i0lFs3RvPKD6VWHuolRoICy\
    GeJC1CnU/dFvRMVZIthzcF4XXt85S/R5yjz2BQEbzZToCLKstFyuzAs+wfipaBYI\
    uAAo7wvZICRceFJf5qb+yevhc+oPAgMBAAECgYEAlUrR0zeJEsv+x4LJFFTpQn6v\
    zViEsuj8zFn//VzJ0uDF1hR+qq1WPEz4YhkrGMAK92+LBgnKjypHgmKoZIjmhhoW\
    slHwub3nXfpBp+KamLxoe0VWnEUZYtpFnBgyOUfDHUkRg1OEkVMW39QEUMZnXqnV\
    NZ6iBQZAo9Y3J6s2GnECQQDT0m9oSE8QpfG5SlCU8a6J/jO0LFoivMi716FzHNm9\
    Rp1tNeIzTwoIt3r7T1TTNZj2ckPK9x4jMRM1ugBUs4kpAkEA0R8VsWe3gY80ufEp\
    1gbWo9Nro9/zfxRDrTx9gY9sbrRtmrMcbmwWZKNRdwzARnP0EF2OHd5JzL1tZgRa\
    bGLodwJARs46BV7eZw9BfRGVXCRplqENgXWt75yxcPEEe+kx864uI3p2kXYjQYSr\
    rGP5U9y/s+nANZFjVpop9LSnNakJ+QJBAJsJK6EBnreLvvBXjceh/EEqvfOZVcGR\
    +XaWkQmbli0g0N1PCrYGpjdoKT5UkrvovTng0jrskNQcX92xPoR6c5MCQGSUoZWk\
    j1GZFm0GOm3L4SzkHEfMqqRjU3+Y0TgW8CGijLUQH6TsZzoHpWELwG6EZbGohGAH\
    4v9yhn+nuHaSD0I=\
    -----END PRIVATE KEY-----";
    
    self.javaPubKey = @"-----BEGIN PUBLIC KEY-----\
    MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCtCIVirh1kpxpsi9NtuICAinBu\
    y5GaIf/MPNlwAY3BQN3og3XERBPfnd4tJRbN0bzyg+lVh7qJUaCAshniQtQp1P3R\
    b0TFWSLYc3BeF17fOUv0eco89gUBG82U6AiyrLRcrswLPsH4qWgWCLgAKO8L2SAk\
    XHhSX+am/snr4XPqDwIDAQAB\
    -----END PUBLIC KEY-----";
    
    
    self.oriMsg = @"16612345678";
    // 生成 des key
    self.DESKey = [NSString ret24BitString];
    
}

- (void)setSteps
{
    UILabel *he = [[UILabel alloc] init];
    he.numberOfLines = 0;
    he.textColor = [UIColor redColor];
    he.text = @"iOS 公钥.der私钥.p12的证书文件 \n和 java 的公钥私钥key字符串 \"是\" \n相互通用和可以相互混用的";
    he.width = kScreenWidth;
    he.font = [UIFont boldSystemFontOfSize:20];
    he.textAlignment = NSTextAlignmentCenter;
    [he sizeToFit];
    self.tableView.tableHeaderView = he;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"RSA证书" ofType: nil];
    path = [path stringByAppendingPathComponent:@"readMe.txt"];
    NSString *des = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
    
    UILabel *l  = [[UILabel alloc] init];
    l.textColor = [UIColor blackColor];
    l.width = kScreenWidth;
    l.text = des;
    l.numberOfLines = 0;
    [l sizeToFit];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, l.height, kScreenWidth, 200)];
    [imgV sd_setImageWithURL:[NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1803339-3ef995aa667e40f6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700"]];
    [l addSubview:imgV];
    
    
    self.tableView.tableFooterView = l;
    UIEdgeInsets contentInset = self.tableView.contentInset;
    contentInset.bottom += 300;
    self.tableView.contentInset = contentInset;
}

- (AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
            return parameters;
        }];
        _manager = manager;
    }
    return _manager;
}

#pragma mark - LMJNavUIBaseViewControllerDataSource

/** 导航条左边的按钮 */
- (UIImage *)lmjNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(LMJNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"NavgationBar_white_back"] forState:UIControlStateHighlighted];
    
    return [UIImage imageNamed:@"NavgationBar_blue_back"];
}

#pragma mark - LMJNavUIBaseViewControllerDelegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(LMJNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
