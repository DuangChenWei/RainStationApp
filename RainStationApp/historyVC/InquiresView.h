//
//  InquiresView.h
//  RainStationApp
//
//  Created by vp on 2017/5/10.
//  Copyright © 2017年 vp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "datePickerView.h"
@protocol HSearchDelegate <NSObject>

-(void)getStationArrayMessage;

@end
@interface InquiresView : UIView<closePickerViewDelegate>

@property(nonatomic,strong)UILabel *chooseStationNameLabel;
@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)UILabel *endTimeLabel;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,copy)NSString *selectBengZhanId;
@property(nonatomic,strong)NSMutableArray *stationArray;


@property(nonatomic,strong)datePickerView *chooseStationPicker;
@property(nonatomic,strong)datePickerView *chooseStartTimePicker;
@property(nonatomic,strong)datePickerView *chooseEndTimePicker;

@property(nonatomic,assign)int selectTag;

@property(nonatomic,assign)id<HSearchDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame sationArray:(NSMutableArray *)stationArr stationName:(NSString *)stationName isAddRangeView:(BOOL)addRangeView;
@end
