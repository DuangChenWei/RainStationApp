//
//  InquiresView.m
//  RainStationApp
//
//  Created by vp on 2017/5/10.
//  Copyright © 2017年 vp. All rights reserved.
//

#import "InquiresView.h"

@implementation InquiresView
-(instancetype)initWithFrame:(CGRect)frame sationArray:(NSMutableArray *)stationArr stationName:(NSString *)stationName isAddRangeView:(BOOL)addRangeView{
    
    self=[super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor=ColorWithAlpha(0xf9f9f9, 1);
        self.stationArray=stationArr;
        
     
        
        
        //    泵站名称
        //    范围
        UILabel *bengzhanTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(widthOn(50), 0, k_ScreenWidth*0.5-widthOn(50), widthOn(90))];
        
        bengzhanTextLabel.text = stationName;
        bengzhanTextLabel.font = [UIFont systemFontOfSize:widthOn(34)];
        bengzhanTextLabel.textColor=[UIColor darkGrayColor];
        [self addSubview:bengzhanTextLabel];
        
        UIView *lineVV=[[UIView alloc] initWithFrame:CGRectMake(k_ScreenWidth*0.5-0.5, CGRectGetMidY(bengzhanTextLabel.frame)-widthOn(20), 1, widthOn(40))];
        lineVV.backgroundColor=appLineColor;
        [self addSubview:lineVV];
        
        //    定义
        self.chooseStationNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bengzhanTextLabel.frame), CGRectGetMinY(bengzhanTextLabel.frame), CGRectGetWidth(bengzhanTextLabel.frame)-widthOn(27), CGRectGetHeight(bengzhanTextLabel.frame))];
        
        self.chooseStationNameLabel.text = @"全区";
        self.chooseStationNameLabel.textAlignment = NSTextAlignmentRight;
        self.chooseStationNameLabel.font = bengzhanTextLabel.font;
        [self addSubview:self.chooseStationNameLabel];
        
        UIImageView *iconImv=[[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.chooseStationNameLabel.frame)+widthOn(10), CGRectGetMidY(self.chooseStationNameLabel.frame)-widthOn(7), widthOn(17), widthOn(14))];
        iconImv.image=[UIImage imageNamed:@"chooseIcon.png"];
        [self addSubview:iconImv];
        
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.chooseStationNameLabel.frame), CGRectGetMinY(self.chooseStationNameLabel.frame), CGRectGetMaxX(iconImv.frame)-CGRectGetMinX(self.chooseStationNameLabel.frame), CGRectGetHeight(self.chooseStationNameLabel.frame))];
        [btn addTarget:self action:@selector(chooseStationPickerAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        //    下划线
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(bengzhanTextLabel.frame), CGRectGetMaxY(self.chooseStationNameLabel.frame),k_ScreenWidth-CGRectGetMinX(bengzhanTextLabel.frame)*2, 1)];
        line.backgroundColor=appLineColor;
        [self addSubview:line];
        
        
        UILabel *startLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bengzhanTextLabel.frame), CGRectGetMaxY(line.frame), CGRectGetWidth(bengzhanTextLabel.frame), CGRectGetHeight(bengzhanTextLabel.frame))];
        startLab.text=@"开始时间";
        startLab.font=bengzhanTextLabel.font;
        startLab.textColor=bengzhanTextLabel.textColor;
        [self addSubview:startLab];
        
        UILabel *endLab=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.chooseStationNameLabel.frame), CGRectGetMaxY(line.frame), CGRectGetWidth(bengzhanTextLabel.frame), CGRectGetHeight(bengzhanTextLabel.frame))];
        endLab.text=@"结束时间";
        endLab.textAlignment=NSTextAlignmentRight;
        endLab.font=bengzhanTextLabel.font;
        endLab.textColor=bengzhanTextLabel.textColor;
        [self addSubview:endLab];
        
        
        UIView *line1=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(line.frame), CGRectGetMaxY(startLab.frame), CGRectGetWidth(line.frame), CGRectGetHeight(line.frame))];
        line1.backgroundColor=line.backgroundColor;
        [self addSubview:line1];
        
        //    按钮部分
        self.startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(bengzhanTextLabel.frame), CGRectGetMaxY(line1.frame), CGRectGetWidth(line1.frame)*0.5-widthOn(20), CGRectGetHeight(bengzhanTextLabel.frame))];
        self.startTimeLabel.textColor = [UIColor blackColor];
        //    _startTime.backgroundColor = [UIColor redColor];
        self.startTimeLabel.text = @"请选择开始时间";
        self.startTimeLabel.font =bengzhanTextLabel.font;
        self.startTimeLabel.userInteractionEnabled = YES;
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.startTimeLabel];
        UITapGestureRecognizer *tapStartTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStartTimePickerAction)];
        
        [self.startTimeLabel addGestureRecognizer:tapStartTime];
        //    中间的字
        UILabel *zhi = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.startTimeLabel.frame), CGRectGetMaxY(line1.frame), widthOn(40), CGRectGetHeight(bengzhanTextLabel.frame))];
        
        zhi.text = @"至";
        zhi.textColor = [UIColor grayColor];
        zhi.textAlignment=NSTextAlignmentCenter;
        zhi.font = [UIFont systemFontOfSize:widthOn(30)];
        [self addSubview:zhi];
        
        self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(zhi.frame), CGRectGetMaxY(line1.frame), CGRectGetWidth(self.startTimeLabel.frame), CGRectGetHeight(bengzhanTextLabel.frame))];
        //    _fineshTime.backgroundColor = [UIColor blueColor];
        self.endTimeLabel.font = self.startTimeLabel.font;
        self.endTimeLabel.userInteractionEnabled = YES;
        self.endTimeLabel.text = @"请选择结束时间";
        self.endTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.endTimeLabel];
        
        UITapGestureRecognizer *tapFinshTime = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseStoptimePickerAction)];
        
        [self.endTimeLabel addGestureRecognizer:tapFinshTime];
        //    下划线
        UIImageView *line2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(line1.frame), CGRectGetMaxY(self.endTimeLabel.frame),CGRectGetWidth(line1.frame), CGRectGetHeight(line1.frame))];
        line2.backgroundColor=appLineColor;
        [self addSubview:line2];
        
        self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(bengzhanTextLabel.frame), CGRectGetHeight(self.frame)-widthOn(260), CGRectGetWidth(line1.frame),widthOn(100))];
        [self.searchBtn setBackgroundColor:appMainColor];
        self.searchBtn.titleLabel.font=[UIFont systemFontOfSize:widthOn(40)];
        [self.searchBtn setTitle:@"搜  索" forState:UIControlStateNormal];
        [self.searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.searchBtn.layer.cornerRadius=widthOn(20);
        self.searchBtn.clipsToBounds=YES;
   
        [self addSubview:self.searchBtn];
        
        
        
        
        [self addPickerViews];
        
        
        
    }
    return self;
}
//***********************************

-(void)chooseStationPickerAction{
    self.selectTag=2;
    if (self.chooseStationPicker.contentArray.count>0) {
        [self.chooseStationPicker viewDatePickerView];
    }else{
        
        if (self.delegate) {
            [self.delegate getStationArrayMessage];
        }
    }
    
    NSLog(@"选择区域");
    
}
-(void)chooseStartTimePickerAction{
    self.selectTag=3;
    [self.chooseStartTimePicker viewDatePickerView];
    NSLog(@"选择开始时间");
    
}
-(void)chooseStoptimePickerAction{
    self.selectTag=4;
    [self.chooseEndTimePicker viewDatePickerView];
    NSLog(@"选择结束时间");
    
}
//*************************************
-(void)addPickerViews{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
   
        self.chooseStationPicker=[[datePickerView alloc] initWithFrame:CGRectMake(0, k_ScreenHeight, k_ScreenWidth, CGRectGetHeight(self.frame)) bengZhanList:self.stationArray];
        self.chooseStationPicker.delegate=self;
        [self addSubview:self.chooseStationPicker];
        
        self.chooseStartTimePicker=[[datePickerView alloc] initWithFrame:CGRectMake(0, k_ScreenHeight, k_ScreenWidth, CGRectGetHeight(self.frame))];
        self.chooseStartTimePicker.delegate=self;
        [self addSubview:self.chooseStartTimePicker];
        
        self.chooseEndTimePicker=[[datePickerView alloc] initWithFrame:CGRectMake(0, k_ScreenHeight, k_ScreenWidth, CGRectGetHeight(self.frame))];
        self.chooseEndTimePicker.delegate=self;
        [self addSubview:self.chooseEndTimePicker];
        
    });
    
    
    
}


//代理
-(void)closeDatePickView{
    
    if (self.selectTag==1) {
       
        
        
        
    }else if (self.selectTag==2){
        
        self.chooseStationNameLabel.text=self.chooseStationPicker.bengZhanName;
        self.selectBengZhanId=self.chooseStationPicker.bengZhanId;
        [self.chooseStationPicker closeDatePickerView];
    }else if (self.selectTag==3){
        NSString *startTime=[NSString stringWithFormat:@"%@年%@月%@日",self.chooseStartTimePicker.dateArray[0],self.chooseStartTimePicker.dateArray[1],self.chooseStartTimePicker.dateArray[2]];
        self.startTimeLabel.text=startTime;
        [self.chooseStartTimePicker closeDatePickerView];
        
        
        
        
    }else if (self.selectTag==4){
        NSString *endTime=[NSString stringWithFormat:@"%@年%@月%@日",self.chooseEndTimePicker.dateArray[0],self.chooseEndTimePicker.dateArray[1],self.chooseEndTimePicker.dateArray[2]];
        self.endTimeLabel.text=endTime;
        [self.chooseEndTimePicker closeDatePickerView];
        
        
        
        
        
    }
    
    
    
}
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
-(NSMutableAttributedString*) changeLabelWithText:(NSString*)needText
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:needText];
    UIFont *font = [UIFont systemFontOfSize:widthOn(30)];
    [attrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,5)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:widthOn(36)] range:NSMakeRange(5,needText.length-5)];
    
    return attrString;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
