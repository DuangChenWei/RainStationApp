//
//  SoapService.m
//  SOAP-IOS
//
//  Created by Elliott on 13-7-26.
//  Copyright (c) 2013年 Elliott. All rights reserved.
//

#import "SoapService.h"
#import "HYBNetworking.h"

@implementation ResponseData 

@end

@implementation SoapService

-(id)initWithPostUrl:(NSString *)url SoapAction:(NSString *)soapAction{
    self=[super init];
    if(self){
        self.PostUrl=url;
        self.SoapAction=soapAction;
    }
    return self;
}



-(void)PostAsync:(NSString *)postData Success:(SuccessBlock)success falure:(FailureBlock)failure{
    
    
    
    
    NSURL *url = [[NSURL alloc] initWithString:self.PostUrl];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = nil;
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.securityPolicy.allowInvalidCertificates = YES;//忽略https证书
    manager.securityPolicy.validatesDomainName = NO;//是否验证域名
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[url host] forHTTPHeaderField:@"Host"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%@",self.SoapAction] forHTTPHeaderField:@"SOAPAction"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return postData;
    }];
    
    [manager POST:self.PostUrl parameters:postData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *response = [[NSString alloc] initWithData:(NSData *)responseObject encoding:NSUTF8StringEncoding];
        success(response);
        //        NSLog(@"****success =  %@", response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"****fail = %@@", error);
        failure(error);
    }];

    
    
    
    
    
    
}


@end
