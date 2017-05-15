//
//  RainColumnViewController.m
//  RainStationApp
//
//  Created by vp on 2017/5/10.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "RainColumnViewController.h"
#import "JHChartHeader.h"
#import "NetWorkManager.h"
@interface RainColumnViewController ()
{
    JHColumnChart *column;
    NSMutableArray *colorArray;
}

@end

@implementation RainColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMainTitleBar:[NSString stringWithFormat:@"%@降雨量",self.name]];
     self.menubtn.hidden=YES;
    NSLog(@"%@",self.bengZhanID);
    
    
    
    if (self.dateArray==nil) {
        self.dateArray=[NSMutableArray array];
    }
    
    
    
    column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, appNavigationBarHeight, k_ScreenWidth-widthOn(130), k_ScreenHeight-appNavigationBarHeight)];
    
    column.originSize = CGPointMake(widthOn(180), widthOn(60));
    if (self.isFrom24hours) {
        column.originSize = CGPointMake(widthOn(200), widthOn(60));
    }
    column.drawFromOriginX = 0;
    column.typeSpace = widthOn(20);
    column.isShowXLine = YES;
    column.columnHeight = widthOn(50);
    column.bgVewBackgoundColor = [UIColor whiteColor];
    column.drawTextColorForX_Y = [UIColor darkGrayColor];
    column.colorForXYLine = [UIColor lightGrayColor];
    column.xDescTextFontSize=widthOn(24);
    column.yDescTextFontSize=widthOn(24);
    column.columType=@"rain";
    [self.view addSubview:column];
    
    
    
    colorArray=[NSMutableArray arrayWithObjects:ColorWithAlpha(0xFFC6F7, 1),
                ColorWithAlpha(0xFE00F7, 1),
                ColorWithAlpha(0xC500BE, 1),
                ColorWithAlpha(0x8E0090, 1),
                ColorWithAlpha(0x9B0005, 1),
                ColorWithAlpha(0xC60005, 1),
                ColorWithAlpha(0xFF0005, 1),
                ColorWithAlpha(0xFF9305, 1),
                ColorWithAlpha(0xFFC905, 1),
                ColorWithAlpha(0xFFFA05, 1),
                ColorWithAlpha(0x2FFF00, 1),
                ColorWithAlpha(0x3E9609, 1),
                ColorWithAlpha(0x0066FA, 1),
                ColorWithAlpha(0x0098FD, 1),
                ColorWithAlpha(0x00CBFB, 1),
                ColorWithAlpha(0x9AFEFD, 1),
                ColorWithAlpha(0xC3BEBD, 1),
                ColorWithAlpha(0xff2121, 1),nil];
    
    NSMutableArray *textArr=[NSMutableArray arrayWithObjects:@"以上",@"300",@"200",@"150",@"130",@"110",@"90",@"70",@"50",@"40",@"30",@"20",@"15",@"10",@"6",@"2",@"1",nil];
    
    for (int i=0; i<textArr.count; i++) {
        
        [self initViewsWithFrame:CGRectMake(CGRectGetMaxX(column.frame)+widthOn(10), CGRectGetMinY(column.frame)+widthOn(30)*i+widthOn(60), k_ScreenWidth-CGRectGetMaxX(column.frame)-widthOn(10), widthOn(20)) backgroundColor:colorArray[i] title:textArr[i]];
    }
    
    
    
   

    if (self.dateArray.count>0) {
        [self showColumnView];
    }else{
        if (self.bengZhanID) {
            [self getDataFromNet];
        }else{
            [self getAllDataFromNet];
        }
    }
    
    
    // Do any additional setup after loading the view.
}

-(void)initViewsWithFrame:(CGRect)rect backgroundColor:(UIColor *)backgroundColor title:(NSString *)title{
    
    UIView *backView=[[UIView alloc] initWithFrame:rect];
    [self.view addSubview:backView];
    
    UIView *colorView=[[UIView alloc] initWithFrame:CGRectMake(rect.size.width-widthOn(60), 0,widthOn(40), rect.size.height)];
    colorView.backgroundColor=backgroundColor;
//    if ([title isEqualToString:@"警戒线"]) {
//        colorView.frame=CGRectMake(rect.size.width-widthOn(60), rect.size.height*0.5-1,widthOn(40), 2);
//    }else{
//        colorView.layer.cornerRadius=rect.size.height*0.5;
//        colorView.clipsToBounds=YES;
//    }
    
    [backView addSubview:colorView];
    
    UILabel *textLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,CGRectGetMinX(colorView.frame)-widthOn(10), rect.size.height)];
    textLabel.text=title;
    textLabel.textColor=[UIColor darkGrayColor];
    textLabel.textAlignment=NSTextAlignmentRight;
    textLabel.font=[UIFont systemFontOfSize:widthOn(24)];
    [backView addSubview:textLabel];
    
    
    
}

-(void)showColumnView{
    
    
    NSMutableArray *valueArr=[NSMutableArray array];
    
    NSMutableArray *xShowInfoText=[NSMutableArray array];
    
    for (NSMutableDictionary *dic in self.dateArray) {
        
        if (self.isFrom24hours || [dic[@"ValueX"] floatValue]>0) {
            [valueArr addObject:[NSArray arrayWithObject:dic[@"ValueX"]]];
            [xShowInfoText addObject:dic[@"HH"]];
        }
//        else{
//            if ([dic[@"ValueX"] floatValue]>0) {
//                [valueArr addObject:[NSArray arrayWithObject:dic[@"ValueX"]]];
//                [xShowInfoText addObject:dic[@"HH"]];
//                
//            }
//        }
        
        
        
       
        
        
        
        
    }
    
    column.valueArr =valueArr;
    
    
    NSMutableArray *tempArr=[NSMutableArray array];
    for (NSArray *vArr in valueArr) {
        
        if ([vArr[0] floatValue]>=300) {
            [tempArr addObject:colorArray[0]];
        }else if ([vArr[0] floatValue]>= 200){
            
            [tempArr addObject:colorArray[1]];
        }else if ([vArr[0] floatValue]>= 150){
            
            [tempArr addObject:colorArray[2]];
        }else if ([vArr[0] floatValue]>= 130){
            
            [tempArr addObject:colorArray[3]];
        }else if ([vArr[0] floatValue]>= 110){
            
            [tempArr addObject:colorArray[4]];
        }else if ([vArr[0] floatValue]>= 90){
            
            [tempArr addObject:colorArray[5]];
        }else if ([vArr[0] floatValue]>= 70){
            
            [tempArr addObject:colorArray[6]];
        }else if ([vArr[0] floatValue]>= 50){
            
            [tempArr addObject:colorArray[7]];
        }else if ([vArr[0] floatValue]>= 40){
            
            [tempArr addObject:colorArray[8]];
        }else if ([vArr[0] floatValue]>= 30){
            
            [tempArr addObject:colorArray[9]];
        }else if ([vArr[0] floatValue]>= 20){
            
            [tempArr addObject:colorArray[10]];
        }else if ([vArr[0] floatValue]>= 15){
            
            [tempArr addObject:colorArray[11]];
        }else if ([vArr[0] floatValue]>= 10){
            
            [tempArr addObject:colorArray[12]];
        }else if ([vArr[0] floatValue]>= 6){
            
            [tempArr addObject:colorArray[13]];
        }else if ([vArr[0] floatValue]>= 2){
            
            [tempArr addObject:colorArray[14]];
        }else if ([vArr[0] floatValue]>= 1){
            
            [tempArr addObject:colorArray[15]];
        }else if ([vArr[0] floatValue]>= 0){
            
            [tempArr addObject:colorArray[16]];
        }else{
            [tempArr addObject:colorArray[0]];
        }
    }
    
    
    column.columnBGcolorsArr=tempArr;
    
    column.xShowInfoText = xShowInfoText;
    
    if (valueArr.count>0) {
        [column showAnimation];
    }else{
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"暂无降雨量数据"];
        
    }
    
    
    
}
- (void) getDataFromNet{
    
    [SVProgressHUD showWithStatus:@"正在查询..."];
    
    
    if ([NetWorkManager sharedInstance].isAppStoreNum ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"暂无降雨量数据"];
        });
        
        return;
        
    }
    
    
    NSMutableDictionary *BodyDic=[NSMutableDictionary dictionary];
    [BodyDic setValue:self.startTime forKey:@"startTime"];
    [BodyDic setValue:self.endTime forKey:@"endTime"];
    [BodyDic setValue:self.bengZhanID forKey:@"id"];
    NSLog(@"雨量历史记录传的参数%@",BodyDic);
    NSString *urlStr=@"Get_CheckRainFallHistory_List";

    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:urlStr parameters:BodyDic success:^(NSDictionary *response) {
        
        [SVProgressHUD dismiss];
        
       [self setMessageWithDic:response];        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"查询失败,请检查网络后重试"];
    }];
}



- (void) getAllDataFromNet{
    
    [SVProgressHUD showWithStatus:@"正在查询..."];
    
    
    if ([NetWorkManager sharedInstance].isAppStoreNum ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"暂无降雨量数据"];
        });
        
        return;
        
    }
    
    
    NSMutableDictionary *BodyDic=[NSMutableDictionary dictionary];
    [BodyDic setValue:self.startTime forKey:@"startTime"];
    [BodyDic setValue:self.endTime forKey:@"endTime"];
  
    NSLog(@"雨量历史记录传的参数%@",BodyDic);
    NSString *urlStr=@"Get_CheckAllRainFallHistory_List";
    
    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:urlStr parameters:BodyDic success:^(NSDictionary *response) {
        
        [SVProgressHUD dismiss];
        
        
        [self setMessageWithDic:response];
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"查询失败,请检查网络后重试"];
    }];
}

-(void)setMessageWithDic:(NSDictionary *)response{
    id carList=response
    [@"RainFall"];
    
    [self.dateArray removeAllObjects];
    
    if ([carList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *carDic in carList) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:carDic[@"TIME"][@"text"] forKey:@"HH"];
            float valu=[carDic[@"ValueX"][@"text"] doubleValue];
            [dic setValue:[NSString stringWithFormat:@"%.1f",valu] forKey:@"ValueX"];
            
            [self.dateArray addObject:dic];
        }
        
    }else if([carList isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:carList[@"TIME"][@"text"] forKey:@"HH"];
        float valu=[carList[@"ValueX"][@"text"] doubleValue];
        [dic setValue:[NSString stringWithFormat:@"%.1f",valu] forKey:@"ValueX"];
        [self.dateArray addObject:dic];
        
    }else{
        
    }
    
    if (self.dateArray.count<1) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"暂无降雨量数据"];
    }
    
    [self showColumnView];

    
}

- (void) onClickBack:(id) sender{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
