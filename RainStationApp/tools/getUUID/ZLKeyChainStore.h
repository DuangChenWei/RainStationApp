//
//  ZLKeyChainStore.h
//  SmartCity
//
//  Created by vp on 2017/3/17.
//  Copyright © 2017年 vp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZLKeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
