//
//  ZLGetUUID.m
//  SmartCity
//
//  Created by vp on 2017/3/17.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "ZLGetUUID.h"
#import "ZLKeyChainStore.h"

#define  KEY_USERNAME_PASSWORD @"com.company.app.usernamepassword"
#define  KEY_USERNAME @"com.company.app.username"
#define  KEY_PASSWORD @"com.company.app.password"
@implementation ZLGetUUID
+ (NSString *)getUUID {
    
    NSString * strUUID = (NSString *)[ZLKeyChainStore load:@"com.company.app.usernamepassword"];
    
    // 首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {
        //生成一个uuid的方法
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        
        //将该uuid保存到keychain
        [ZLKeyChainStore save:KEY_USERNAME_PASSWORD data:strUUID];
        
    }
    return strUUID;
}

@end
