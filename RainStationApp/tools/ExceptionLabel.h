//
//  ExceptionLabel.h
//  CassiaHubApp
//
//  Created by liyuexin on 15/10/30.
//  Copyright (c) 2015年 cassia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExceptionLabel : UILabel

-(instancetype)init;
-(void)showExceptionLableWithException:(NSString*)reason;
@end
