//
//  ViewController.m
//  RainStationApp
//
//  Created by vp on 2017/4/27.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "ViewController.h"
#import "ZLGetUUID.h"
@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    
    
//     NSString *uuid=[ZLGetUUID getUUID];
//     NSLog(@"%@",uuid);

    [self performSegueWithIdentifier:@"pushLogin" sender:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
