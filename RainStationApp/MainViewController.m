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
@interface MainViewController ()<AGSMapViewLayerDelegate,AGSQueryTaskDelegate,AGSMapViewTouchDelegate>
{

    UIButton *btnSelect;
    UIButton *btnColumn;
    
    BOOL isOpenTapMap;
    
}
@property(nonatomic,strong)AGSMapView *mapView;
@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.setPopGestureRecognizerOn=YES;
    [self initMainTitleBar:@"开发区降雨监测"];
    self.backBtn.hidden=YES;

    
    
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
    [self.navigationController pushViewController:mv animated:NO];
}
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics{
    
    if (isOpenTapMap) {
        NSLog(@"开始查询");
    }else{
    
        NSLog(@"关闭了查询");
    }

    
}
-(void)LoadMap
{
    [SVProgressHUD showWithStatus:@"正在加载地图"];
    
    NSURL *urlBengzhan= [NSURL URLWithString:@"http://ysmapservices.sytxmap.com/arcgis/rest/services/New/ZongTu_Wai/MapServer"];
    AGSDynamicMapServiceLayer *  layerBengzhan111 = [AGSDynamicMapServiceLayer dynamicMapServiceLayerWithURL:urlBengzhan];
    NSLog(@"%@",layerBengzhan111);
    
    //    [self reFreshMapLayer];
    [self.mapView addMapLayer:layerBengzhan111 withName:@"BengzhanLayer"];
    

    
}

-(void) mapViewDidLoad:(AGSMapView *)mapView{
    AGSEnvelope *fullEnv = [[AGSEnvelope alloc] initWithXmin:41508571.340459 ymin:4602901.254403 xmax:41528301.423954 ymax:4637976.958395 spatialReference:[[AGSSpatialReference alloc] initWithWKID:2365 WKT:nil]];; //
    
   [self.mapView zoomToEnvelope:fullEnv animated:YES];
    
    [SVProgressHUD dismiss];
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
