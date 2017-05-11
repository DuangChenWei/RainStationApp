//
//  RainModel.h
//  DemoDPSDK
//
//  Created by vp on 2017/4/19.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RainModel : NSObject
@property(nonatomic,copy)NSString *BZName;
@property(nonatomic,copy)NSString *BZValue;

-(void)setMessageWithDic:(NSDictionary *)dic;

@end
