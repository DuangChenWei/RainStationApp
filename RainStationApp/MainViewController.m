//
//  MainViewController.m
//  RainStationApp
//
//  Created by vp on 2017/4/27.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "MainViewController.h"
#import "NetWorkManager.h"
#import "InquiriesViewController.h"
#import <ArcGIS/ArcGIS.h>
#import "AllRainAreaController.h"
#import "RainModel.h"
@interface MainViewController ()<AGSMapViewLayerDelegate,AGSQueryTaskDelegate,AGSMapViewTouchDelegate,AGSQueryTaskDelegate>
{

    UIButton *btnSelect;
    UIButton *btnColumn;
    
    BOOL isOpenTapMap;
    
    NSMutableArray *colorArray;
    
    BOOL isLoadMap;
    BOOL isLoadQueryTask;
    
}
@property(nonatomic,strong)AGSMapView *mapView;
@property(nonatomic,strong)NSMutableArray *mapArray;
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,strong)AGSQueryTask *queryTask;
@property(nonatomic,strong)AGSQuery *query;
@property(nonatomic,strong)AGSGraphicsLayer *graphicsLayer;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.setPopGestureRecognizerOn=YES;
    [self initMainTitleBar:@"开发区降雨监测"];
    self.backBtn.hidden=YES;

    self.mapArray=[NSMutableArray array];
    self.valueArray=[NSMutableArray array];
    colorArray=[NSMutableArray arrayWithObjects:ColorWithAlpha(0xFFC6F7, 0.45),
                ColorWithAlpha(0xFE00F7, 0.45),
                ColorWithAlpha(0xC500BE, 0.45),
                ColorWithAlpha(0x8E0090, 0.45),
                ColorWithAlpha(0x9B0005, 0.45),
                ColorWithAlpha(0xC60005, 0.45),
                ColorWithAlpha(0xFF0005, 0.45),
                ColorWithAlpha(0xFF9305, 0.45),
                ColorWithAlpha(0xFFC905, 0.45),
                ColorWithAlpha(0xFFFA05, 0.45),
                ColorWithAlpha(0x2FFF00, 0.45),
                ColorWithAlpha(0x3E9609, 0.45),
                ColorWithAlpha(0x0066FA, 0.45),
                ColorWithAlpha(0x0098FD, 0.45),
                ColorWithAlpha(0x00CBFB, 0.45),
                ColorWithAlpha(0x9AFEFD, 0.45),
                ColorWithAlpha(0xC3BEBD, 0.45),
                ColorWithAlpha(0xff2121, 0.45),nil];
    
    self.mapView=[[AGSMapView alloc] initWithFrame:CGRectMake(0, appNavigationBarHeight, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height-appNavigationBarHeight)];
  
    self.mapView.backgroundColor=[UIColor whiteColor];
    self.mapView.touchDelegate=self;
    self.mapView.layerDelegate=self;
    [self.view addSubview:self.mapView];
    
    
    
    [self LoadMap];
    
   
    [self addRightButton];
}
- (void) addRightButton{
    int baseY = heightOn(180);
    int btnWidth = widthOn(69);
    int btnPaddingRight = widthOn(10);
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    btnSelect = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - btnWidth - btnPaddingRight, baseY, btnWidth, btnWidth)];
    [btnSelect setBackgroundImage:[UIImage imageNamed:@"selectMap.png"] forState:UIControlStateNormal];
    [btnSelect addTarget:self action:@selector(onClickSelectPoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSelect];
    
    btnColumn = [[UIButton alloc] initWithFrame:CGRectMake(btnSelect.frame.origin.x, btnSelect.frame.origin.y + btnSelect.frame.size.height + btnPaddingRight, btnWidth, btnWidth)];
    [btnColumn setBackgroundImage:[UIImage imageNamed:@"mapColumn.png"] forState:UIControlStateNormal];
    [self.view addSubview:btnColumn];
    
    [btnColumn addTarget:self action:@selector(onClickColumn) forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)onClickSelectPoint{

    isOpenTapMap=!isOpenTapMap;
}
-(void)onClickColumn{
 
    
    AllRainAreaController *mv=[[AllRainAreaController alloc] init];
    mv.valueArray=self.valueArray;
    [self.navigationController pushViewController:mv animated:NO];
}
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    
    if (isOpenTapMap) {
    
 
        
        NSArray *ValueArr=[graphics allValues];
        for (NSArray *arr in ValueArr) {
            
            AGSGraphic *grappp=arr[0];
             NSLog(@"点击了点击了%@,,,%@",[grappp allAttributes][@"DocPath"],[grappp allAttributes][@"RefName"]);

        }
        
    }else{
    
        NSLog(@"处于关闭查询");
  
        
    }
    

}



-(void)LoadMap
{
    [SVProgressHUD showWithStatus:@"正在加载地图"];
    
    NSURL *urlBengzhan= [NSURL URLWithString:@"http://ysmapservices.sytxmap.com/arcgis/rest/services/KFQ_YuLiangJianCe/MapServer"];
    AGSDynamicMapServiceLayer *  layerBengzhan111 = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:urlBengzhan];

    layerBengzhan111.name = @"dynamicLayer";

    //    [self reFreshMapLayer];
    [self.mapView addMapLayer:layerBengzhan111 withName:@"BengzhanLayer"];
    
    self.graphicsLayer=[AGSGraphicsLayer graphicsLayer];
    [self.mapView addMapLayer:self.graphicsLayer withName:@"grapLayer"];
    
    
    self.queryTask = [AGSQueryTask queryTaskWithURL:[NSURL URLWithString:@"http://ysmapservices.sytxmap.com/arcgis/rest/services/KFQ_YuLiangJianCe/MapServer/0"]];
    
    self.queryTask.delegate = self;
                      //return all fields in query
    
    self.query = [AGSQuery query];
    
    self.query.outFields = [NSArray arrayWithObjects:@"*",nil];
    
    self.query.returnGeometry = YES;
    
    self.query.whereClause=@"1=1";
//    self.query.text = @"Ring0";
    
    [self.queryTask executeWithQuery:self.query];
    
    

    
}

-(void) mapViewDidLoad:(AGSMapView *)mapView{
    AGSEnvelope *fullEnv = [[AGSEnvelope alloc] initWithXmin:41489475.648039 ymin:4629936.377077 xmax:41527078.378675 ymax:4595382.516492 spatialReference:[[AGSSpatialReference alloc] initWithWKID:2365 WKT:nil]];//
    
   [self.mapView zoomToEnvelope:fullEnv animated:YES];
    
    [SVProgressHUD dismiss];
  
    isLoadMap=YES;
    if (isLoadQueryTask) {
        [self getRainMessage];
    }
    
}




-(void)queryTask: (AGSQueryTask*) queryTask operation:(NSOperation*) op didExecuteWithFeatureSetResult:(AGSFeatureSet*) featureSet{
    
     NSLog(@"成功");
    isLoadQueryTask=YES;
    //get feature, and load in to table
    if(featureSet.features.count>0)
    {
        for (AGSGraphic *graphic in featureSet.features) {
            
            NSLog(@"成功了成功了%@,,,%@",[graphic allAttributes][@"DocPath"],[graphic allAttributes][@"RefName"]);
            
            NSMutableDictionary  *dic=[NSMutableDictionary dictionary];
            [dic setValue:graphic.geometry.envelope forKey:@"envelope"];
            [dic setValue:[graphic allAttributes][@"DocPath"] forKey:@"layerId"];
            [dic setValue:[graphic allAttributes][@"RefName"] forKey:@"layerName"];
            [dic setValue:graphic forKey:@"graphic"];
            [self.mapArray addObject:dic];
 
            
            
        }
      
        if (isLoadMap) {
            [self getRainMessage];
        }
        
        
        
    }

}
//if there’s an error with the query display it to the uesr 在Query失败后响应，弹出错误提示框
-(void)queryTask: (AGSQueryTask*)queryTask operation:(NSOperation*)op didFailWithError:(NSError*)error{

    NSLog(@"querytask查询失败");
    
}
-(void)addRainLayers{

    for (NSDictionary *dic in self.mapArray) {
        
        NSString *name=dic[@"layerName"];
        
        
        AGSGraphic *graphic=dic[@"graphic"];
        //定义多边形要素的渲染样式
        AGSSimpleFillSymbol *outerSymbol = [AGSSimpleFillSymbol simpleFillSymbol];
      
        outerSymbol.color = [[self getColorWithName:name] colorWithAlphaComponent:0.25];
        outerSymbol.outline.color = ColorWithAlpha(0x999999, 1);
        graphic.symbol = outerSymbol;
        [self.graphicsLayer addGraphic:graphic];
        
        [self.graphicsLayer refresh];
        
        
    }
}
-(void)getRainMessage{
    
    
    [SVProgressHUD showWithStatus:@"正在加载..."];
    
    if ([NetWorkManager sharedInstance].isAppStoreNum ) {
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//            NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"rain" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
//            
//            
//            NSError *error;
//            
//            NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:data error:&error];
//            [self showColumnViewWithDic:dicMessage];
//            
//        });
//        
//        return;
        
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
    
    [self.graphicsLayer removeAllGraphics];
    
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
    
    [self addRainLayers];
    
}

-(UIColor *)getColorWithName:(NSString *)name{

    NSString *value=@"0";
    
    for (RainModel *model in self.valueArray) {
        if ([model.BZName isEqualToString:name]) {
            value=model.BZValue;
        }
    }
    
    if ([value floatValue]>=300) {
        return colorArray[0];
    }else if ([value floatValue]>= 200){
        
        return colorArray[1];
    }else if ([value floatValue]>= 150){
        
        return colorArray[2];
    }else if ([value floatValue]>= 130){
        
        return colorArray[3];
    }else if ([value floatValue]>= 110){
        
        return colorArray[4];
    }else if ([value floatValue]>= 90){
        
        return colorArray[5];
    }else if ([value floatValue]>= 70){
        
        return colorArray[6];
    }else if ([value floatValue]>= 50){
        
        return colorArray[7];
    }else if ([value floatValue]>= 40){
        
        return colorArray[8];
    }else if ([value floatValue]>= 30){
        
        return colorArray[9];
    }else if ([value floatValue]>= 20){
        
        return colorArray[10];
    }else if ([value floatValue]>= 15){
        
        return colorArray[11];
    }else if ([value floatValue]>= 10){
        
        return colorArray[12];
    }else if ([value floatValue]>= 6){
        
        return colorArray[13];
    }else if ([value floatValue]>= 2){
        
        return colorArray[14];
    }else if ([value floatValue]>= 1){
        
        return colorArray[15];
    }else if ([value floatValue]>= 0){
        
        return colorArray[16];
    }else{
        return colorArray[0];
    }

    
    
    
    
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
