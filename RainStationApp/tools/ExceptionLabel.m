//
//  ExceptionLabel.m
//  CassiaHubApp
//
//  Created by liyuexin on 15/10/30.
//  Copyright (c) 2015年 cassia. All rights reserved.
//

#import "ExceptionLabel.h"




#define ex_singleLineWidth (180.0/320.0)*k_ScreenWidth
#define ex_multyLineWidth (130.0/320.0)*k_ScreenWidth
#define ex_singleLineHeight (20.0/568.0)*k_ScreenHeight



@implementation ExceptionLabel
{
    NSTimer *closeLableT;
}

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.65];
        
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:15];
//        self.bounds = CGRectMake(k_ScreenWidth, 20, k_ScreenWidth, (25.0/568.0)*k_ScreenHeight);
        
        self.center = CGPointMake(k_ScreenWidth/2, 4*k_ScreenHeight/5);
        
        self.textAlignment = NSTextAlignmentCenter;
        self.numberOfLines = 0;
        self.alpha = 0;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;

    }
    
    return self;
}

-(void)showExceptionLableWithException:(NSString*)reason
{
    CGSize size = [self calculateTheSizeWithString:reason];
    self.bounds = CGRectMake(0, 0, size.width+5, size.height+5);
    self.text = reason;
    [UIView animateWithDuration:.3 animations:^{
        
        self.alpha = 0.9;
        
    }];
    
    if (closeLableT) {
        [closeLableT invalidate];
        closeLableT = nil;
        closeLableT = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(closeExceptionLable) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:closeLableT forMode:UITrackingRunLoopMode];
    }else{
        closeLableT = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(closeExceptionLable) userInfo:nil repeats:NO];
        
        [[NSRunLoop currentRunLoop] addTimer:closeLableT forMode:UITrackingRunLoopMode];
    }

}



-(void)closeExceptionLable
{
    [UIView animateWithDuration:.8 animations:^{
        
        
        self.alpha = 0;
    }];
}



-(CGSize)calculateTheSizeWithString:(NSString*)string
{
    
    CGSize exSize = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 0)];
    
    
    if (exSize.width<ex_singleLineWidth) {
        
        return CGSizeMake(exSize.width+10, ex_singleLineHeight);
        
    }else if (exSize.width<2*ex_multyLineWidth){
        
        return CGSizeMake(ex_multyLineWidth+10, ex_singleLineHeight*2);
        
        
    }else if (exSize.width<2*ex_singleLineWidth){
        
        return CGSizeMake(ex_singleLineWidth+10, ex_singleLineHeight*2);
        
    }else if (exSize.width<3*ex_multyLineWidth){
        
        return CGSizeMake(ex_multyLineWidth+10, ex_singleLineHeight*3);
        
    }else if (exSize.width<3*ex_singleLineWidth){
        
        return CGSizeMake(ex_singleLineWidth+10, ex_singleLineHeight*3);
        
    }else if (exSize.width<4*ex_multyLineWidth){
        return CGSizeMake(ex_multyLineWidth+10, ex_singleLineHeight*4);
        
    }else if (exSize.width<4*ex_singleLineWidth){
        
        return CGSizeMake(ex_singleLineWidth+10, ex_singleLineHeight*4);
        
    }
    
    
    
    return CGSizeMake(ex_singleLineWidth+10, ex_singleLineHeight*6);
}

@end
