//
//  NetWorkManager.m
//  DemoDPSDK
//
//  Created by vp on 2017/3/7.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
#import "XMLReader.h"
static NetWorkManager* g_shareInstance = nil;
@implementation NetWorkManager
+ (NetWorkManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_shareInstance = [[self alloc] init];
    });
    return g_shareInstance;
}
- (void)GetDictionaryMethodWithUrl:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(id response))success
                           failure:(void (^)(NSError *error))failure
{
    
    
    NSDictionary *dic=parameters;
    
    NSString *responseStr=[NSString stringWithFormat:@"%@Response",URLString];
    NSString *resultStr=[NSString stringWithFormat:@"%@Result",URLString];
    
    
    NSString *methodName=URLString;//@"Get_Car_List";
    SoapUtility *soaputility=[[SoapUtility alloc] initFromFile:@"BeiDouService"];
    NSString *postData=[soaputility BuildSoap12withMethodNameNoParam:methodName];
    if (parameters) {
        postData=[soaputility BuildSoap12withMethodName:methodName  withParas:dic];
    }
    SoapService *soaprequest=[[SoapService alloc] init];
    soaprequest.PostUrl=[NSString stringWithFormat:@"%@:5963/GPSService.asmx",BeiDouServiceUrl];
    soaprequest.SoapAction=[soaputility GetSoapActionByMethodName:methodName SoapType:SOAP];
    
    if ([NetWorkManager sharedInstance].isAppStoreNum&&[URLString isEqualToString:@"Get_CarNoPic_List"]) {
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"beiDouList" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
            
            NSError *error;
            
            NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:data error:&error];
            
            success(dicMessage);
            
        });
        
        return;
        
    }
    
    
    [soaprequest PostAsync:postData Success:^(NSString *response)
     {
         
         NSError *error;
         
         NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:response error:&error];
         
         id respon=dicMessage[@"soap:Envelope"]
         [@"soap:Body"]
         [responseStr]
         [resultStr];
         
         
         success(respon);
         
         
         
     } falure:^(NSError *response) {
         NSLog(@"WebService Erro=%@",response);
         
         failure(response);
     }];
    
    
    
    
}

-(void)setUserInfoMessageWithDic:(NSDictionary *)dic{

    
    if (!self.userInfoDic) {
        self.userInfoDic=[NSMutableDictionary dictionary];
    }
    [self.userInfoDic setValue:dic[@"GROUPNAME"][@"text"] forKey:@"groupName"];
    [self.userInfoDic setValue:dic[@"HaveIMG"][@"text"] forKey:@"haveIMG"];
    [self.userInfoDic setValue:dic[@"IsAuthorizedLogin"][@"text"] forKey:@"isAuthorizedLogin"];
    [self.userInfoDic setValue:dic[@"NAME"][@"text"] forKey:@"name"];
    [self.userInfoDic setValue:dic[@"PERID"][@"text"] forKey:@"perId"];
    [self.userInfoDic setValue:dic[@"Power"][@"text"] forKey:@"power"];
    [self.userInfoDic setValue:dic[@"SEX"][@"text"] forKey:@"sex"];
    [self.userInfoDic setValue:dic[@"TELNUMBER"][@"text"] forKey:@"tel"];
    [self.userInfoDic setValue:dic[@"CARNUM"][@"text"] forKey:@"carNum"];

    if ([[NetWorkManager sharedInstance].userInfoDic[@"power"] isEqualToString:@"0"]) {
        self.powerStatus=Boss;
    }else if ([[NetWorkManager sharedInstance].userInfoDic[@"power"] isEqualToString:@"2"]){
        self.powerStatus=NormalUser;
    }else{
        self.powerStatus=Driver;
    }
    
    
}


-(void)getMapLayers{

    [self setMapLayers];
    
   [self GetMessageUseNSURLSessionWithUrl:[NSString stringWithFormat:@"%@:5963/mapLayers.xml",BeiDouServiceUrl] success:^(NSString *response) {
       NSError *error;
       
       NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:response error:&error];
       NSDictionary *layDic=dicMessage[@"mapLayers"];
       
       [[NSUserDefaults standardUserDefaults] setObject:layDic forKey:@"mapLayers"];
       [[NSUserDefaults standardUserDefaults] synchronize];

       
       NSLog(@"++++----****%@",dicMessage);
       [self setMapLayers];
       
       

   } failure:^(NSString *error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if (![[NSUserDefaults standardUserDefaults] objectForKey:@"mapLayers"]) {
                [self getMapLayers];
           }
          
       });
   }];

}
-(void)setMapLayers{
    NSDictionary *layDic=[[NSUserDefaults standardUserDefaults] objectForKey:@"mapLayers"];
    if (layDic) {
        self.LvWangLayer=[layDic[@"LvWangLayer"][@"text"] intValue];
        self.bengZhanNameLayer=[layDic[@"bengZhanNameLayer"][@"text"] intValue];
        self.layersNumber=[layDic[@"layersNumber"][@"text"] intValue];
        self.qiyeLineLayer=[layDic[@"qiyeLineLayer"][@"text"] intValue];
        self.yuanQuFanWeiLayer=[layDic[@"yuanQuFanWeiLayer"][@"text"] intValue];
        self.luWangLayer=[layDic[@"LvWangLayer"][@"text"] intValue];
        
        self.HidensNumberArray = [layDic[@"HidensNumber"][@"text"] componentsSeparatedByString:@","];

    }
    
}
-(void)checkAppVersionNeedUpdate{

    NSString *localVersion=[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];//Version
    NSString *URLStr=@"https://itunes.apple.com/cn/lookup?id=1236615944";
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    NSLog(@"请求APP更新接口");
    [manager GET:URLStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求APP更新接口%@",responseObject);
        NSNumber *resultCount=responseObject[@"resultCount"];
        if (responseObject&&[resultCount intValue]==1) {
            //对比版本
            NSArray *infoArray = responseObject[@"results"];
            NSString * versionAppStore=@"";
            NSString *url = @"";
            if ([infoArray count]) {
                NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
                versionAppStore = releaseInfo[@"version"];
                url=releaseInfo[@"trackViewUrl"];
            }
            
            double doubleLocalVersion=[self versionStrChangeDoubleWithString:localVersion];
            double doubleAppStoreVersion=[self versionStrChangeDoubleWithString:versionAppStore];
            
            NSLog(@"+++++++++++++++++++doubleLocalVersion:%lf,,doubleAppStoreVersion:%lf",doubleLocalVersion,doubleAppStoreVersion);
            if (doubleAppStoreVersion>doubleLocalVersion) {
                
                
                [[NSUserDefaults standardUserDefaults] setObject:url forKey:@"updateUrl"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                UIAlertView *art2=[[UIAlertView alloc] initWithTitle: MYLocalizedString(@"雨量监测系统发现新的版本需要升级", nil) message:nil delegate:self cancelButtonTitle:@"现在升级" otherButtonTitles:nil, nil];
                art2.tag=205;
                [art2 show];
           
               
                
            }
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取更新数据请求失败");
    }];

    

    
    
}
-(double)versionStrChangeDoubleWithString:(NSString *)VersionStr{
    
    double doubleVersion=[VersionStr doubleValue];
    NSArray *arr=[NSArray arrayWithArray:[VersionStr componentsSeparatedByString:@"."]];
    if (arr.count>=3) {
        NSString *changeVersion=[NSString stringWithFormat:@"%@.%@%@",arr[0],arr[1],arr[2]];
        doubleVersion=[changeVersion doubleValue];
    }
    
    return doubleVersion;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (alertView.tag==205) {
      
        if (buttonIndex==0) {
            
            NSString *updateUrl=[[NSUserDefaults standardUserDefaults] objectForKey:@"updateUrl"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateUrl]];
            
            
        }
    }
}


-(void)GetMessageUseNSURLSessionWithUrl:(NSString *)URLString
                   success:(void (^)(NSString *response))success
                   failure:(void (^)(NSString *error))failure{

    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config ];
    NSURLSessionDataTask *dataaa=[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            // 响应状态代码为200，代表请求数据成功，判断成功后我们再进行数据解析
            NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (httpResp.statusCode == 200) {
                    
                    NSString *ver = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    success(ver);
                    
                }else{
                    failure(@"");
                }
            });
        }else{
        
            failure(@"");
        }
        
        
    }];
    [dataaa resume];

}


-(void)checkNotificationMessage{

    [self GetMessageUseNSURLSessionWithUrl:[NSString stringWithFormat:@"%@:5963/notification.xml",BeiDouServiceUrl] success:^(NSString *response) {
        NSError *error;
        
        NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:response error:&error];
        NSDictionary *layDic=dicMessage[@"notification"];
        NSLog(@"获取通知%@",dicMessage);
        if ([layDic[@"code"][@"text"] isEqualToString:@"1"]) {
            UIAlertView *art=[[UIAlertView alloc] initWithTitle:layDic[@"title"][@"text"] message:layDic[@"content"][@"text"] delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
            [art show];
        }
        
        
      
        
        
        
    } failure:^(NSString *error) {
        
    }];

    
}


-(void)showExceptionMessageWithString:(NSString*)message{
    
    NSException *e = [[NSException alloc] initWithName:@"" reason:message userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"exceptionMessage" object:nil userInfo:@{@"message":e}];
    
}


@end
