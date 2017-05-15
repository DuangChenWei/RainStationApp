//
//  BaseViewController.m
//  RainStationApp
//
//  Created by vp on 2017/4/27.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "BaseViewController.h"
#import "InquiriesViewController.h"
@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.setPopGestureRecognizerOn) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
        
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        if (self.setPopGestureRecognizerOn) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
}
- (void) initTitleBar:(NSString *) title{
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    [headerView setBackgroundColor:appMainColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    [label setText:title];
    [headerView addSubview:label];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:17];
    [self.view addSubview:headerView];
    
    
    
    
    self.backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.backBtn];
    
    UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backicon.png"]];
    image.frame=CGRectMake(widthOn(30), 34, 16, 16);
    [self.backBtn addSubview:image];
    
    
    
    self.menubtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth -44, 20, 44, 44)];
    [self.menubtn setImage:[UIImage imageNamed:@"历史记录icon.png"] forState:UIControlStateNormal];
    
    [headerView addSubview:self.menubtn];
    self.menubtn.hidden=YES;
    

    
}


- (void) initMainTitleBar:(NSString *) title{
    int screenWidth = [UIScreen mainScreen].bounds.size.width;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    [label setText:title];
    [headerView addSubview:label];
    [label setTextColor:[UIColor blackColor]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font=[UIFont boldSystemFontOfSize:17];
    [self.view addSubview:headerView];
    
    
    
    
    self.backBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    self.backBtn.frame=CGRectMake(0, 0, 64, 64);
    [self.backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.backBtn];
    
    UIImageView *image=[[UIImageView alloc] init];
    image.frame=CGRectMake(widthOn(30), 34, 16, 16);
//    image.image = [[UIImage imageNamed:@"backicon.png"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
//    [image setTintColor:appMainColor];
    image.image=[UIImage imageNamed:@"MainBackIcon.png"];
    [self.backBtn addSubview:image];
    
    
    
    self.menubtn = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth -44, 20, 44, 44)];
    [self.menubtn setImage:[UIImage imageNamed:@"历史记录icon.png"] forState:UIControlStateNormal];
    [self.menubtn addTarget:self action:@selector(onClickOpenMenu) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.menubtn];
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 63, k_ScreenWidth, 1)];
    lineView.backgroundColor=appLineColor;
    [headerView addSubview:lineView];
    
    
    
}


-(void)onClickOpenMenu{
    
    InquiriesViewController *mv=[[InquiriesViewController alloc] init];
    [self.navigationController pushViewController:mv animated:YES];
}

-(void)backAction{
    
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
