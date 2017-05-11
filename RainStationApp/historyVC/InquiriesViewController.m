//
//  InquiriesViewController.m
//  RainStationApp
//
//  Created by vp on 2017/5/10.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "InquiriesViewController.h"
#import "InquiresView.h"
#import "NetWorkManager.h"
#import "RainColumnViewController.h"
@interface InquiriesViewController ()<HSearchDelegate>
{

    NSMutableArray *nameArray;
}
@property(nonatomic,strong)InquiresView *myView;
@end

@implementation InquiriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMainTitleBar:@"全区降雨量"];
    self.menubtn.hidden=YES;
    nameArray=[NSMutableArray array];
    self.myView=[[InquiresView alloc] initWithFrame:CGRectMake(0, appNavigationBarHeight, k_ScreenWidth, k_ScreenHeight-appNavigationBarHeight) sationArray:[NSMutableArray array] stationName:@"选择区域" isAddRangeView:NO];
    self.myView.delegate=self;
    [self.myView.searchBtn addTarget:self action:@selector(onClickSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myView];

   
    
    // Do any additional setup after loading the view.
}
-(void)onClickSearch{
    if ([self.myView.startTimeLabel.text isEqualToString:@"请选择开始时间"] || [self.myView.endTimeLabel.text isEqualToString:@"请选择结束时间"] ) {
       [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"请选择时间范围"];
        return ;
    }

    
    RainColumnViewController *history = [[RainColumnViewController alloc]init];
    history.name=self.myView.chooseStationNameLabel.text;
    NSString *StartStr1 = [self.myView.startTimeLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *StartStr2 = [StartStr1 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *StartStr3 = [StartStr2 stringByReplacingOccurrencesOfString:@"日" withString:@""];
    history.startTime = StartStr3;
    NSString *EndStr1 = [self.myView.endTimeLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    NSString *EndStr2 = [EndStr1 stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    NSString *EndStr3 = [EndStr2 stringByReplacingOccurrencesOfString:@"日" withString:@""];
    history.endTime = EndStr3;
    history.bengZhanID=self.myView.selectBengZhanId;
    [self.navigationController pushViewController:history animated:YES];
}
-(void)getStationArrayMessage{
    
    [SVProgressHUD showWithStatus:@"正在查询..."];
    
    if ([NetWorkManager sharedInstance].isAppStoreNum) {
        [SVProgressHUD dismiss];
        
        NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"yuLiang10JieDaoList" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        
        
        NSError *error;
        
        NSDictionary *dicMessage = [XMLReader dictionaryForXMLString:data error:&error];
        
        
        
        [self initBengZhanButtonListWithDic:dicMessage];
        return;
    }
    
    
    
    NSString *urlStr=@"Get_RainStationName_List";
    
    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:urlStr parameters:nil success:^(NSDictionary *response) {
       
        [SVProgressHUD dismiss];
                NSLog(@"%@",response);
        
        
        
        [self initBengZhanButtonListWithDic:response];
        
        
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"获取区域列表失败，请检查网络后重试"];
    }];
    

    
}

- (void) initBengZhanButtonListWithDic:(NSDictionary *)response{
    [nameArray removeAllObjects];
    
    id respon=response[@"RainStationInfo"];
    
    if ([respon isKindOfClass:[NSArray class]]) {
        for (NSDictionary *carDic in respon) {
            NSMutableDictionary *dic=[NSMutableDictionary dictionary];
            [dic setValue:carDic[@"ID"][@"text"] forKey:@"id"];
            
            [dic setValue:carDic[@"NAME"][@"text"]  forKey:@"name"];
            
            [nameArray addObject:dic];
            
            
        }
    }else if ([respon isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        [dic setValue:respon[@"ID"][@"text"] forKey:@"id"];
        
        [dic setValue:respon[@"NAME"][@"text"]  forKey:@"name"];
        
        [nameArray addObject:dic];
    }else{
        
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setValue:@"全区"  forKey:@"name"];
    
    [nameArray insertObject:dic atIndex:0];
    [self.myView.chooseStationPicker updateContentArrayMessageWithArray:nameArray];
    
    
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
