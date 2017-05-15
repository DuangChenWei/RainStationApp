//
//  RainModel.m
//  DemoDPSDK
//
//  Created by vp on 2017/4/19.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import "RainModel.h"

@implementation RainModel
-(instancetype)init{

    self=[super init];
    if (self) {
        
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
}
-(void)setMessageWithDic:(NSDictionary *)dic{

    self.BZName=dic[@"DevName"][@"text"];
    self.BZValue=dic[@"ValueX"][@"text"];
}

@end
