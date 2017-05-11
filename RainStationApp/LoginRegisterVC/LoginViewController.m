//
//  LoginViewController.m
//  RainStationApp
//
//  Created by vp on 2017/5/9.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "LoginViewController.h"
#import "NetWorkManager.h"
#import "RegisterViewController.h"
@interface LoginViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *backScroller;
@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *passwordTextField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.setPopGestureRecognizerOn=YES;

    [self addAllViews];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backKeyBoard)];
    [self.backScroller addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)backKeyBoard{

    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}

-(void)addAllViews{
    
    
    
    
    self.backScroller=[[UIScrollView alloc] init];
    self.backScroller.backgroundColor=[UIColor whiteColor];
    self.backScroller.delegate=self;
    [self.view addSubview:self.backScroller];
    self.backScroller.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).topSpaceToView(self.view, 0).bottomSpaceToView(self.view, 0);
    
    UIImageView *BackIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginBack.png"]];
    [self.backScroller addSubview:BackIcon];
    BackIcon.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    UIImageView *topIcon=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Loginlogo.png"]];
    [self.backScroller addSubview:topIcon];
    topIcon.sd_layout.topSpaceToView(self.backScroller, widthOn(100)).centerXEqualToView(self.backScroller).autoHeightRatio(1);
    
    
    
    
    self.nameTextField=[self creatLogintextFieldViewWithIcon:@"userNameicon.png" placehoder:@"请输入用户名" frameY:widthOn(500)];
    self.nameTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.passwordTextField=[self creatLogintextFieldViewWithIcon:@"passwordIcon.png" placehoder:@"请输入密码" frameY:widthOn(600)];
    self.passwordTextField.secureTextEntry = YES;
    
    self.nameTextField.delegate=self;
    self.passwordTextField.delegate=self;

    NSString  *telStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"tel"];
    NSString  *passwordStr=[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];

    if (telStr) {
        self.nameTextField.text=telStr;
    }
    if (passwordStr) {
        self.passwordTextField.text=passwordStr;
    }
    
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font=[UIFont boldSystemFontOfSize:widthOn(36)];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginBtn.backgroundColor=appMainColor;
    
    [self.backScroller addSubview:loginBtn];
    loginBtn.sd_layout.centerXEqualToView(self.backScroller).topSpaceToView(self.passwordTextField.superview, widthOn(50)).widthIs(k_ScreenWidth*0.5).heightIs(widthOn(80));
    loginBtn.sd_cornerRadiusFromHeightRatio=@0.5;
    
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:@"立即注册?" forState:UIControlStateNormal];
    [registerBtn setTitleColor:appMainColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:widthOn(34)];
    [self.backScroller addSubview:registerBtn];
    registerBtn.sd_layout.topSpaceToView(loginBtn, 5).widthRatioToView(loginBtn, 1).centerXEqualToView(loginBtn).heightRatioToView(loginBtn, 1);
    
    
    [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn addTarget:self action:@selector(regisBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(UITextField *)creatLogintextFieldViewWithIcon:(NSString *)icon placehoder:(NSString *)hoder frameY:( CGFloat )floatY{

    UIView *view=[[UIView alloc] init];
    view.layer.borderWidth=1.5;
    view.layer.borderColor=appMainColor.CGColor;
    view.backgroundColor=[UIColor whiteColor];
//    if ([hoder isEqualToString:@"请输入密码"]) {
//        view.layer.borderColor=appLineColor.CGColor;
//    }
    view.clipsToBounds=YES;
    [self.backScroller addSubview:view];
    view.sd_layout.leftSpaceToView(self.backScroller, widthOn(100)).topSpaceToView(self.backScroller, floatY).rightSpaceToView(self.backScroller, widthOn(100)).heightIs(widthOn(80));
    
    
    UIImageView *iconImv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    [view addSubview:iconImv];
    iconImv.sd_layout.leftSpaceToView(view, widthOn(35)).centerYEqualToView(view).widthIs(widthOn(36));
    
    UITextField *textField=[[UITextField alloc] init];
    textField.placeholder=hoder;
    textField.font=[UIFont systemFontOfSize:widthOn(34)];
    [view addSubview:textField];
    textField.sd_layout.leftSpaceToView(iconImv, widthOn(35)).topSpaceToView(view, 0).bottomSpaceToView(view, 0).rightSpaceToView(view, 0);
    
    return textField;
    
    
    
}

-(void)loginAction{

    [self backKeyBoard];
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写手机号"];
        return;
    }
    
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写密码"];
        return;
    }
    
    
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    
    NSMutableDictionary *BodyDic=[NSMutableDictionary dictionary];
    [BodyDic setValue:self.nameTextField.text forKey:@"loginName"];
    [BodyDic setValue:self.passwordTextField.text forKey:@"loginPwd"];

    
    NSLog(@"传的注册参数：%@",BodyDic);
    
    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:@"Get_RainLoginOKOrNo" parameters:BodyDic success:^(id response) {
        [SVProgressHUD dismiss];
        NSLog(@"登录返回值%@",response);
        NSString *returnStr=response[@"RETURNNUM"][@"text"];
        if ([returnStr isEqualToString:@"0"]) {
//            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"登录成功"];
            [[NSUserDefaults standardUserDefaults] setObject:self.nameTextField.text forKey:@"tel"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSegueWithIdentifier:@"pushToMain" sender:self];
        }else if ([returnStr isEqualToString:@"2"]){
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"登录失败，账号或密码错误"];
        }else{
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"登录失败，未知错误，请联系管理员"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，请检查网络后重试"];
    }];
    

    
}
-(void)regisBtnAction{

    RegisterViewController *vc=[[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAutoLayout”属性来设置要不要触发自动布局计算
    self.backScroller.sd_closeAutoLayout = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 由于scrollview在滚动时会不断调用layoutSubvies方法，这就会不断触发自动布局计算，而很多时候这种计算是不必要的，所以可以通过控制“sd_closeAutoLayout”属性来设置要不要触发自动布局计算
    self.backScroller.sd_closeAutoLayout = NO;
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
