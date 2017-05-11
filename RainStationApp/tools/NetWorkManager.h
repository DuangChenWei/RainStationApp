//
//  NetWorkManager.h
//  DemoDPSDK
//
//  Created by vp on 2017/3/7.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Soap.h"

#import "SVProgressHUD.h"

//#import "AFNetworking.h"


typedef enum
{
    // Apple NetworkStatus Compatible Names.
    Boss     = 0,
    Driver = 1,
    NormalUser = 2
   
    
} PowerStatus;


@interface NetWorkManager : NSObject<UIAlertViewDelegate>


@property(nonatomic,assign)BOOL isAppStoreNum;



@property(nonatomic,assign)int layersNumber;
@property(nonatomic,assign)int LvWangLayer;
@property(nonatomic,assign)int bengZhanNameLayer;
@property(nonatomic,assign)int qiyeLineLayer;
@property(nonatomic,assign)int yuanQuFanWeiLayer;
@property(nonatomic,assign)int luWangLayer;
@property(nonatomic,strong)NSArray *HidensNumberArray;





+ (NetWorkManager *) sharedInstance;

- (void)GetDictionaryMethodWithUrl:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *error))failure;




@property(nonatomic,strong)NSMutableDictionary *userInfoDic;
@property(nonatomic,assign)PowerStatus powerStatus;
-(void)setUserInfoMessageWithDic:(NSDictionary *)dic;
- (void)GetUserInfo;
-(void)getMapLayers;
-(void)checkAppVersionNeedUpdate;

-(void)checkNotificationMessage;


-(void)showExceptionMessageWithString:(NSString*)message;


@end
