//
//  datePickerView.m
//  DemoDPSDK
//
//  Created by vp on 2017/3/30.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import "datePickerView.h"

@implementation datePickerView


-(instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=ColorWithAlpha(0x999999, 0.2);
        self.dayPickerBackView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-widthOn(375)-widthOn(75), k_ScreenWidth, widthOn(375)+widthOn(75))];
        self.dayPickerBackView.backgroundColor=[UIColor whiteColor];
        self.dayPickerBackView.clipsToBounds=YES;
        [self addSubview:self.dayPickerBackView];
        
        UIButton *closePickerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        closePickerBtn.frame=CGRectMake(k_ScreenWidth*0.5, 0, k_ScreenWidth*0.5, widthOn(75));
        [closePickerBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.dayPickerBackView addSubview:closePickerBtn];
        [closePickerBtn addTarget:self action:@selector(closePickkerView) forControlEvents:UIControlEventTouchUpInside];
        //    [closePickerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closePickerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -widthOn(225))];
        //    [closePickerBtn setBackgroundColor:[UIColor yellowColor]];
        
        self.dayPicker=[[ UIDatePicker alloc] init];
        self.dayPicker.frame=CGRectMake(0, widthOn(75), k_ScreenWidth, widthOn(375));
        self.dayPicker.datePickerMode = UIDatePickerModeDate;
        self.dayPicker.backgroundColor=[UIColor whiteColor];
        [ _dayPicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
        self.dayPicker.maximumDate = [NSDate date];
//        NSLog(@"高度：：：%f...%f",self.dayPicker.frame.size.height,CGRectGetHeight(frame));
        [self.dayPickerBackView addSubview:self.dayPicker];
        
        UIView * lineView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(closePickerBtn.frame), k_ScreenWidth, 1)];
        lineView.backgroundColor=appLineColor;
        [self.dayPickerBackView addSubview:lineView];

        NSDate *theDate = [NSDate date];

        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = @"YYYY-MM-dd";
        NSString *dateStr=[dateFormatter1 stringFromDate:theDate];
     
        self.dateArray=[NSMutableArray arrayWithArray:[dateStr componentsSeparatedByString:@"-"]];
        
        
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePickkerView)];
        [self addGestureRecognizer:tap];
        
        
        
        
    }
    return self;
}

-(void)closePickkerView{

    if (self.delegate) {
        [self.delegate closeDatePickView];
    }
    
    
}

- (void)dateChanged
{
    NSDate *theDate = _dayPicker.date;

    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"YYYY-MM-dd";
    NSString *dateStr=[dateFormatter1 stringFromDate:theDate];
    self.dateArray=[NSMutableArray arrayWithArray:[dateStr componentsSeparatedByString:@"-"]];
}

//*********************************分界线************************************

-(instancetype)initWithFrame:(CGRect)frame bengZhanList:(NSMutableArray *)bengZhanArray{

    self=[super initWithFrame:frame];
    if (self) {
        self.backgroundColor=ColorWithAlpha(0x999999, 0.2);
        self.contentArray=bengZhanArray;
        if (self.contentArray.count>0) {
            if ([self.contentArray[0] isKindOfClass:[NSDictionary class]]) {
                self.bengZhanName=[self.contentArray[0] objectForKey:@"name"];
                self.bengZhanId=self.contentArray[0][@"id"];
            }else{
                
                self.bengZhanName=self.contentArray[0];
            }
        }else{
        
            self.bengZhanName=@"全区";
        }
       
        
        self.dayPickerBackView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame)-widthOn(375)-widthOn(75), k_ScreenWidth, widthOn(375)+widthOn(75))];
        self.dayPickerBackView.backgroundColor=[UIColor whiteColor];
        self.dayPickerBackView.clipsToBounds=YES;
        [self addSubview:self.dayPickerBackView];
        
        UIButton *closePickerBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        closePickerBtn.frame=CGRectMake(k_ScreenWidth*0.5, 0, k_ScreenWidth*0.5, widthOn(75));
        [closePickerBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.dayPickerBackView addSubview:closePickerBtn];
        [closePickerBtn addTarget:self action:@selector(closePickkerView) forControlEvents:UIControlEventTouchUpInside];
        //    [closePickerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closePickerBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -widthOn(225))];
        //    [closePickerBtn setBackgroundColor:[UIColor yellowColor]];
        
        self.pick=[[UIPickerView alloc] initWithFrame:CGRectZero];
        self.pick.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        self.pick.frame = CGRectMake(0, CGRectGetMaxY(closePickerBtn.frame), [UIScreen mainScreen].bounds.size.width, 100);
        
        CALayer *viewLayer = self.pick.layer;
        
        [viewLayer setFrame:CGRectMake(0, CGRectGetMaxY(closePickerBtn.frame), [UIScreen mainScreen].bounds.size.width , 150)];
        
        
        self.pick.delegate=self;
        self.pick.dataSource=self;
        self.pick.showsSelectionIndicator=YES;
        [self.dayPickerBackView addSubview:self.pick];

       
        UIView * lineView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(closePickerBtn.frame), k_ScreenWidth, 1)];
        lineView.backgroundColor=appLineColor;
        [self.dayPickerBackView addSubview:lineView];
        
        UIView *lineTopView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(closePickerBtn.frame), k_ScreenWidth, 1)];
        lineTopView.backgroundColor=appLineColor;
        [self.dayPickerBackView addSubview:lineTopView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePickkerView)];
        [self addGestureRecognizer:tap];

        
           }
    return self;


}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSString *str=@"";
    NSString *idStr=@"";
    if (self.contentArray.count>0) {
        if ([self.contentArray[row] isKindOfClass:[NSDictionary class]]) {
            str=[self.contentArray[row] objectForKey:@"name"];
            idStr=self.contentArray[row][@"id"];
        }else{
            
            str=self.contentArray[row];
            idStr=self.contentArray[row];
        }

    }
    self.bengZhanName=str;
    
    self.bengZhanId=idStr;
    
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    
    return 1;     //这个picker里的组键数
    
}



- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    
    return _contentArray.count;//数组个数
    
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    
    UILabel *myView = nil;
    
    if (component == 0) {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width, 51)];
        
        myView.textAlignment = NSTextAlignmentCenter;
        NSString *str=@"";
        if ([self.contentArray[row] isKindOfClass:[NSDictionary class]]) {
            str=[self.contentArray[row] objectForKey:@"name"];
        }else{
            
            str=self.contentArray[row];
        }
        myView.text =[NSString stringWithFormat:@"%@",str];
        
        myView.font = [UIFont boldSystemFontOfSize:17];         //用label来设置字体大小
        
//        myView.backgroundColor = [UIColor yellowColor];
        
    }
    return myView;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component

{
    
    
    
    return [UIScreen mainScreen].bounds.size.width;
    
}



- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component

{
    
    return 51.0;
    
}






//****************
-(void)closeDatePickerView{
    if (CGRectGetMinY(self.frame)!=k_ScreenHeight) {
        CGRect rect=self.frame;
        rect.origin.y=k_ScreenHeight;
        [UIView animateWithDuration:0.15 animations:^{
            self.frame=rect;
            
        }];
    }
}
-(void)viewDatePickerView{
    CGRect rect=self.frame;
    rect.origin.y=0;
    [UIView animateWithDuration:0.15 animations:^{
        self.frame=rect;
    }];
}

-(void)updateContentArrayMessageWithArray:(NSMutableArray *)arrBengZhan{

    self.contentArray=arrBengZhan;
    NSString *str=@"";
    NSString *idStr=@"";
    if (self.contentArray.count>0) {
        if ([self.contentArray[0] isKindOfClass:[NSDictionary class]]) {
            str=[self.contentArray[0] objectForKey:@"name"];
            idStr=self.contentArray[0][@"id"];
        }else{
            
            str=self.contentArray[0];
            idStr=self.contentArray[0];
        }
        self.bengZhanName=str;
        
        self.bengZhanId=idStr;
    }

    
    [self.pick reloadAllComponents];
    [self viewDatePickerView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
