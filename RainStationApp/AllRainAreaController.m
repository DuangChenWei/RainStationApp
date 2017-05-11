//
//  AllRainAreaController.m
//  RainStationApp
//
//  Created by vp on 2017/5/10.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "AllRainAreaController.h"
#import "JHChartHeader.h"
#import "NetWorkManager.h"
#import "RainModel.h"
@interface AllRainAreaController ()
{
    
    JHColumnChart *column;

    
    NSMutableArray *colorArray;
}
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,strong)UILabel *topLabel;
@end

@implementation AllRainAreaController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainTitleBar:@"开发区降雨监测"];
    self.topLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthOn(0), appNavigationBarHeight, k_ScreenWidth, widthOn(50))];
    
    [self.topLabel setTextColor:[UIColor grayColor]];
    self.topLabel.textAlignment=NSTextAlignmentCenter;
    self.topLabel.font=[UIFont systemFontOfSize:widthOn(24)];
    [self.view addSubview:self.topLabel];
    
    self.valueArray=[NSMutableArray array];
    
    // Do any additional setup after loading the view.
    column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLabel.frame), k_ScreenWidth-widthOn(130), k_ScreenHeight-CGRectGetMaxY(self.topLabel.frame))];
    
    column.originSize = CGPointMake(widthOn(150), widthOn(60));
    column.drawFromOriginX = 0;
    column.typeSpace = widthOn(40);
    column.isShowXLine = YES;
    column.columnHeight = widthOn(60);
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
    
    
    
    [self getRainMessage];
    

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


//柱状图
- (void)showColumnView{
    
    
    NSMutableArray *valueArr=[NSMutableArray array];
    
    NSMutableArray *xShowInfoText=[NSMutableArray array];
    float jiangshuiNum=0;
    for (RainModel  *model in self.valueArray) {
        [valueArr addObject:[NSArray arrayWithObject:model.BZValue]];
        
        [xShowInfoText addObject:model.BZName];
        
        jiangshuiNum=jiangshuiNum+[model.BZValue doubleValue];
        
    }
    
    
    column.valueArr = valueArr;
    
    
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
    
    
    
    /*        Module prompt         */
    column.xShowInfoText =xShowInfoText;
    
    [column showAnimation];
    self.topLabel.text=[NSString stringWithFormat:@"24小时区域平均降雨量为 %.1f毫米",(jiangshuiNum/self.valueArray.count)];
}


-(void)getRainMessage{
    
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    if ([NetWorkManager sharedInstance].isAppStoreNum ) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
            
            
            NSError *error;
            
            NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:data error:&error];
            [self showColumnViewWithDic:dicMessage];
            
        });
        
        return;
        
    }
    
    
    NSString *urlStr=@"Get_RealTimeRainfall_List";
    
    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:urlStr parameters:nil success:^(NSDictionary *response) {
        //        [self.columnJiangYU stopLoading];
        [SVProgressHUD dismiss];
        //        NSLog(@"%@",response);
        
        [self showColumnViewWithDic:response];
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"获取雨量信息失败，请检查网络后重试"];
        
    }];
    
}

-(void)showColumnViewWithDic:(NSDictionary *)response{
    
    id respon=response
    [@"RainFall"];
    
    if ([respon isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dic in respon) {
            RainModel *model=[[RainModel alloc] init];
            [model setMessageWithDic:dic];
            
            //                NSLog(@"%@",model.BZName);
            //当初是自己处理了返回来的数据，不影响现在使用
            NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF.BZName CONTAINS[c] %@", model.BZName];
            //过滤数据
            NSMutableArray *tempArr= [NSMutableArray arrayWithArray:[self.valueArray filteredArrayUsingPredicate:preicate]];
            
            if (tempArr.count>0) {
                for (RainModel *mod in self.valueArray) {
                    if ([model.BZName isEqualToString:mod.BZName]) {
                        mod.BZValue=[NSString stringWithFormat:@"%.1f",([mod.BZValue doubleValue]+[model.BZValue doubleValue])];
                    }
                    
                    
                }
            }else{
                
                [self.valueArray addObject:model];
            }
            
            
            
        }
    }else if ([respon isKindOfClass:[NSDictionary class]]){
        RainModel *model=[[RainModel alloc] init];
        [model setMessageWithDic:respon];
        [self.valueArray addObject:model];
    }else{
        
    }
    
    [self showColumnView];
    
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
