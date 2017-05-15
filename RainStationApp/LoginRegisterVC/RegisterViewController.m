//
//  RegisterViewController.m
//  RainStationApp
//
//  Created by vp on 2017/5/9.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "RegisterViewController.h"
#import "NetWorkManager.h"
@interface RegisterViewController ()<UITextFieldDelegate>
{

    CGFloat viewHeight;
}

@property(nonatomic,strong)UITextField *nameTextField;
@property(nonatomic,strong)UITextField *telTextField;
@property(nonatomic,strong)UITextField *passWordTextField;
@property(nonatomic,strong)UITextField *surePassWordField;
@property(nonatomic,strong)UITextField *codeTextField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initTitleBar:@"注册"];
    viewHeight=widthOn(90);
    CGFloat topY=appNavigationBarHeight+widthOn(20);
    self.nameTextField=[self creatTextfieldWithTitle:@"姓名" placeHoder:@"请输入姓名" viewY:topY];

    self.telTextField=[self creatTextfieldWithTitle:@"手机号码" placeHoder:@"请输入手机号" viewY:topY+viewHeight*1];
    self.telTextField.keyboardType=UIKeyboardTypeNumberPad;
    self.passWordTextField=[self creatTextfieldWithTitle:@"输入密码" placeHoder:@"请输入密码" viewY:topY+viewHeight*2];
    self.passWordTextField.secureTextEntry = YES;
    self.surePassWordField=[self creatTextfieldWithTitle:@"确认密码" placeHoder:@"请再次输入密码" viewY:topY+viewHeight*3];
    self.surePassWordField.secureTextEntry = YES;
    self.codeTextField=[self creatTextfieldWithTitle:@"验证码" placeHoder:@"请输入验证码" viewY:topY+viewHeight*4];
    self.codeTextField.keyboardType=UIKeyboardTypeNumberPad;
    
    self.codeTextField.delegate=self;
    self.nameTextField.delegate=self;
    self.telTextField.delegate=self;
    self.passWordTextField.delegate=self;
    self.surePassWordField.delegate=self;
    
    UIButton *registerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font=[UIFont boldSystemFontOfSize:widthOn(36)];
    [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:appMainColor];
    [registerBtn addTarget:self action:@selector(regisbtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    registerBtn.sd_layout.topSpaceToView(self.codeTextField, widthOn(80)).centerXEqualToView(self.view).widthIs(widthOn(450)).heightIs(widthOn(80));
    registerBtn.sd_cornerRadiusFromHeightRatio=@0.5;
    
    
    UIButton *agreeMentBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    NSString *messageStr=@"• 注册代表同意《开发区降雨监测用户协议》";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:messageStr];
    NSRange strRange = [messageStr rangeOfString:@"《"];
    if (strRange.location<[messageStr length]&&strRange.location>0) {
        NSRange colorRange=NSMakeRange(strRange.location, [messageStr length]-strRange.location);
        
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:colorRange];
        [str addAttribute:NSForegroundColorAttributeName
         
                    value:[UIColor darkGrayColor]
         
                    range:NSMakeRange(0, colorRange.location)];
        [str addAttribute:NSForegroundColorAttributeName
         
                    value:appMainColor
         
                    range:colorRange];
        [agreeMentBtn setAttributedTitle:str forState:UIControlStateNormal];
    }else{
        
        [agreeMentBtn setTitle:messageStr forState:UIControlStateNormal];
    }

    agreeMentBtn.titleLabel.font=[UIFont systemFontOfSize:widthOn(26)];
    agreeMentBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:agreeMentBtn];
    agreeMentBtn.sd_layout.topSpaceToView(registerBtn, widthOn(20)).centerXEqualToView(registerBtn).widthRatioToView(registerBtn, 1.5).heightIs(widthOn(60));
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backKeyBoard)];
    [self.view addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}
-(UITextField *)creatTextfieldWithTitle:(NSString *)title placeHoder:(NSString *)hoder viewY:(CGFloat)viewY{

    UILabel *titlelabel=[[UILabel alloc] init];
    titlelabel.text=title;
    titlelabel.font=[UIFont systemFontOfSize:widthOn(34)];
    [self.view addSubview:titlelabel];
    
    UITextField *textField=[[UITextField alloc] init];
    textField.placeholder=hoder;
    textField.font=titlelabel.font;
    [self.view addSubview:textField];
    
    UIView *lineView=[[UIView alloc] init];
    lineView.backgroundColor=appLineColor;
    [self.view addSubview:lineView];
    
    titlelabel.sd_layout.leftSpaceToView(self.view, widthOn(40)).topSpaceToView(self.view, viewY).widthIs(widthOn(150)).heightIs(viewHeight);
    textField.sd_layout.leftSpaceToView(titlelabel, widthOn(40)).topEqualToView(titlelabel).rightSpaceToView(self.view, widthOn(40)).heightRatioToView(titlelabel, 1);
    lineView.sd_layout.leftEqualToView(titlelabel).rightEqualToView(textField).topSpaceToView(titlelabel, 0).heightIs(1);
    
    return textField;
    
    
}
-(void)regisbtnAction{

     [self backKeyBoard];
    
    if ([self.nameTextField.text isEqualToString:@""]) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写姓名"];
        return;
    }
    if ([self.telTextField.text isEqualToString:@""]) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写手机号码"];
        return;
    }
    if ([self.passWordTextField.text isEqualToString:@""]) {
       [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写密码"];
        return;
    }
    if ([self.codeTextField.text isEqualToString:@""]) {
       [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"清填写验证码"];
        return;
    }
    if (![self.passWordTextField.text isEqualToString:self.surePassWordField.text]) {
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"两次输入的密码不一致"];
        return;
    }
    
    
   
    [SVProgressHUD showWithStatus:@"正在提交"];
    
    NSMutableDictionary *BodyDic=[NSMutableDictionary dictionary];
    [BodyDic setValue:self.telTextField.text forKey:@"loginName"];
    [BodyDic setValue:self.passWordTextField.text forKey:@"loginPwd"];
    [BodyDic setValue:self.nameTextField.text forKey:@"NAME"];
    [BodyDic setValue:self.codeTextField.text forKey:@"IDCode"];
 
    NSLog(@"传的注册参数：%@",BodyDic);
    
    [[NetWorkManager sharedInstance] GetDictionaryMethodWithUrl:@"Insert_RainLoginUser" parameters:BodyDic success:^(id response) {
        [SVProgressHUD dismiss];
        NSLog(@"注册返回值%@",response);
        NSString *returnStr=response[@"RETURNNUM"][@"text"];
        if ([returnStr isEqualToString:@"0"]) {
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else if ([returnStr isEqualToString:@"1"]){
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，验证码错误"];
        }else if ([returnStr isEqualToString:@"2"]){
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，账号已存在"];
        }else if ([returnStr isEqualToString:@"3"]){
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，请联系管理员"];
        }else{
            [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，未知错误，请联系管理员"];
        }
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        
        [[NetWorkManager sharedInstance] showExceptionMessageWithString:@"注册失败，请检查网络后重试"];
    }];

    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;
}
-(void)backKeyBoard{

    [self.codeTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.telTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    [self.surePassWordField resignFirstResponder];
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
