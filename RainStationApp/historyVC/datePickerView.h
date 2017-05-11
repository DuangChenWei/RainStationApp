//
//  datePickerView.h
//  DemoDPSDK
//
//  Created by vp on 2017/3/30.
//  Copyright © 2017年 jiang_bin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol closePickerViewDelegate <NSObject>

-(void)closeDatePickView;

@end


@interface datePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)UIView *dayPickerBackView;

@property(nonatomic,strong)UIDatePicker *dayPicker;
@property(nonatomic,assign)id<closePickerViewDelegate> delegate;
@property(nonatomic,strong)NSMutableArray *dateArray;


-(instancetype)initWithFrame:(CGRect)frame bengZhanList:(NSMutableArray *)bengZhanArray;
@property(nonatomic,strong)NSMutableArray *contentArray;
@property(nonatomic,strong)UIPickerView *pick;
@property(nonatomic,strong)NSString *bengZhanName;
@property(nonatomic,strong)NSString *bengZhanId;

-(void)closeDatePickerView;
-(void)viewDatePickerView;
-(void)updateContentArrayMessageWithArray:(NSMutableArray *)arrBengZhan;
@end
