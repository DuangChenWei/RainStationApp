//
//  JHColumnChart.m
//  JHChartDemo
//
//  Created by cjatech-简豪 on 16/5/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHColumnChart.h"

@interface JHColumnChart ()<CAAnimationDelegate>




//峰值
@property (nonatomic,assign) CGFloat maxHeight;

//横向最大值
@property (nonatomic,assign) CGFloat maxWidth;

//Y轴辅助线数据源
@property (nonatomic,strong)NSMutableArray * yLineDataArr;

//所有的图层数组
@property (nonatomic,strong)NSMutableArray * layerArr;

//所有的柱状图数组
@property (nonatomic,strong)NSMutableArray * showViewArr;

@property (nonatomic,assign) CGFloat perHeight;

@property (nonatomic , strong) NSMutableArray * drawLineValue;


@end

@implementation JHColumnChart

-(NSMutableArray *)drawLineValue{
    if (!_drawLineValue) {
        _drawLineValue = [NSMutableArray array];
    }
    return _drawLineValue;
}

-(NSMutableArray *)showViewArr{
    
    
    if (!_showViewArr) {
        _showViewArr = [NSMutableArray array];
    }
    
    return _showViewArr;
    
}

-(NSMutableArray *)layerArr{
    
    
    if (!_layerArr) {
        _layerArr = [NSMutableArray array];
    }
    
    return _layerArr;
}


-(UIScrollView *)BGScrollView{
    
    
    if (!_BGScrollView) {

        _BGScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _BGScrollView.showsHorizontalScrollIndicator = NO;
//        _bgVewBackgoundColor = _bgVewBackgoundColor;
        [self addSubview:_BGScrollView];
        
    }
    
    return _BGScrollView;
    
    
}


-(void)setBgVewBackgoundColor:(UIColor *)bgVewBackgoundColor{
    
    _bgVewBackgoundColor = bgVewBackgoundColor;
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    
}


-(NSMutableArray *)yLineDataArr{
    
    
    if (!_yLineDataArr) {
        _yLineDataArr = [NSMutableArray array];
    }
    return _yLineDataArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {

        _needXandYLine = YES;
        _isShowXLine = YES;
        _lineChartPathColor = [UIColor blueColor];
        
        _lineChartValuePointColor = [UIColor yellowColor];
    }
    return self;
    
}

-(void)setLineValueArray:(NSArray *)lineValueArray{
    
    if (!_isShowLineChart) {
        return;
    }
    
    _lineValueArray = lineValueArray;
    CGFloat max = _maxWidth;
    
    for (id number in _lineValueArray) {
        
        CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
        if (currentNumber>max) {
            max = currentNumber;
        }
        
    }
    if (max<5.0) {
        _maxWidth = 5.0;
    }else if(max<10){
        _maxWidth = 10;
    }else{
        _maxWidth = max;
    }
    
    _maxWidth += 1;
    _perHeight = (CGRectGetHeight(self.frame)  - _originSize.y)/_maxWidth;
    
    
}

-(void)setValueArr:(NSArray<NSArray *> *)valueArr{
    
    
    _valueArr = valueArr;
    CGFloat max = 0;
 
    for (NSArray *arr in _valueArr) {
        
        for (id number in arr) {
            
            CGFloat currentNumber = [NSString stringWithFormat:@"%@",number].floatValue;
            if (currentNumber>max) {
                max = currentNumber;
            }
            
        }

    }
    
    if (max<5.0) {
        _maxWidth = 5.0;
    }else if(max<10){
        _maxWidth = 10;
    }else if(max<20){
        _maxWidth = 20;
    }else if(max<50){
        _maxWidth = 50;
    }else if(max<=100){
        _maxWidth = 100;
    }else if(max<200){
        _maxWidth = 200;
    }else if(max<300){
        _maxWidth = 400;
    }else if(max<400){
        _maxWidth = 500;
    }else{
        _maxWidth = max;
    }
    
    if ([self.columType isEqualToString:@"water"]) {
        _maxWidth=10;
    }else if ([self.columType isEqualToString:@"rain"]){
     
          
            if (max>100&&max<=125) {
                _maxWidth=125;
            }else if (max>125&&max<=250){
            
                _maxWidth=250;
            }else if (max>250&&max<=500){
            
                _maxWidth=500;
            }


        
    }

    
    _perHeight = (CGRectGetWidth(self.frame)  - _originSize.x-30)/_maxWidth ;
    NSLog(@"%f++++++%f   ----- %f",_perHeight,_maxWidth,_originSize.x);
    
    
}


-(void)showAnimation{

    [self clear];
    
    _columnHeight = (_columnHeight<=0?30:_columnHeight);
    if (_valueArr.count<1) {
        return;
    }
    NSInteger count = _valueArr.count * [_valueArr[0] count];
    _typeSpace = (_typeSpace<=0?15:_typeSpace);
    _maxHeight = count * _columnHeight + _valueArr.count * _typeSpace + _typeSpace +_originSize.y;
    self.BGScrollView.contentSize = CGSizeMake(0, _maxHeight);
    self.BGScrollView.backgroundColor = _bgVewBackgoundColor;
    self.BGScrollView.showsVerticalScrollIndicator=NO;
    self.BGScrollView.showsHorizontalScrollIndicator=NO;
    
    
    /*        绘制X、Y轴  可以在此改动X、Y轴字体大小       */
    if (_needXandYLine) {
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        [self.layerArr addObject:layer];
        
        UIBezierPath *bezier = [UIBezierPath bezierPath];
        
        
        
        [bezier moveToPoint:CGPointMake(self.originSize.x, self.originSize.y)];
    
        [bezier addLineToPoint:P_M(self.originSize.x,_maxHeight )];
        if (self.isShowXLine) {
            [bezier moveToPoint:CGPointMake(self.originSize.x, self.originSize.y)];
            [bezier addLineToPoint:P_M(CGRectGetWidth(self.frame), self.originSize.y)];
        }
        
        layer.path = bezier.CGPath;
        
        layer.strokeColor = (_colorForXYLine==nil?([UIColor blackColor].CGColor):_colorForXYLine.CGColor);
        
        
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic.duration = self.isShowXLine?1.5:0.75;
        
        basic.fromValue = @(0);
        
        basic.toValue = @(1);
        
        basic.autoreverses = NO;
        
        basic.fillMode = kCAFillModeForwards;
        
        
        [layer addAnimation:basic forKey:nil];
        
        [self.BGScrollView.layer addSublayer:layer];
        

        
        /*        设置虚线辅助线         */
        UIBezierPath *second = [UIBezierPath bezierPath];
        
        UIBezierPath *secondRed=[UIBezierPath bezierPath];
        
        for (NSInteger i = 0; i<5; i++) {
            NSInteger pace = (_maxWidth) / 5.0;
            CGFloat height = _perHeight * (i+1)*pace;
//            NSLog(@"++++++++++++%f",height);
           
            NSString *text =[NSString stringWithFormat:@"%ld",(i + 1) * pace];
            
            
            if ([self.columType isEqualToString:@"water"]&&[text isEqualToString:@"6"]) {
                [secondRed moveToPoint:P_M(_originSize.x +height,_originSize.y )];
                [secondRed addLineToPoint:P_M(_originSize.x +height,_maxHeight)];

            }else if ([self.columType isEqualToString:@"rain"]&&[text isEqualToString:@"100"]){
                [secondRed moveToPoint:P_M(_originSize.x +height,_originSize.y )];
                [secondRed addLineToPoint:P_M(_originSize.x +height,_maxHeight)];

            }else{
                [second moveToPoint:P_M(_originSize.x +height,_originSize.y )];
                [second addLineToPoint:P_M(_originSize.x +height,_maxHeight)];

            }

            
            
            
            
            CATextLayer *textLayer = [CATextLayer layer];
            NSString *textStr=[NSString stringWithFormat:@"%@mm",text];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            
            CGFloat be = [self sizeOfStringWithMaxSize:XORYLINEMAXSIZE textFont:self.yDescTextFontSize aimString:textStr].width;
            textLayer.frame = CGRectMake( _originSize.x +height -be*0.5, _originSize.y -15, be, 15);
            
            UIFont *font = [UIFont systemFontOfSize:[text floatValue]>99?10:self.yDescTextFontSize];
            CFStringRef fontName = (__bridge CFStringRef)font.fontName;
            CGFontRef fontRef = CGFontCreateWithFontName(fontName);
            textLayer.font = fontRef;
            textLayer.fontSize = font.pointSize;
            CGFontRelease(fontRef);
            
            textLayer.string = textStr;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.foregroundColor = (_drawTextColorForX_Y==nil?[UIColor blackColor].CGColor:_drawTextColorForX_Y.CGColor);
            [_BGScrollView.layer addSublayer:textLayer];
            [self.layerArr addObject:textLayer];

        }
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        
        shapeLayer.path = second.CGPath;
        
        shapeLayer.strokeColor = (_dashColor==nil?([UIColor darkGrayColor].CGColor):_dashColor.CGColor);
        
        shapeLayer.lineWidth = 0.5;
        
        [shapeLayer setLineDashPattern:@[@(3),@(3)]];
        
        
        CAShapeLayer *shapeLayerRed = [CAShapeLayer layer];
        
        shapeLayerRed.path = secondRed.CGPath;
        
        shapeLayerRed.strokeColor = [[UIColor colorWithRed:255/255.0 green:33/255.0 blue:33/255.0 alpha:1] CGColor];
        
        shapeLayerRed.lineWidth = 0.5;
        
//        [shapeLayerRed setLineDashPattern:@[@(3),@(3)]];
        
        
        CABasicAnimation *basic2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        
        
        basic2.duration = 1.5;
        
        basic2.fromValue = @(0);
        
        basic2.toValue = @(1);
        
        basic2.autoreverses = NO;
        
        
        
        basic2.fillMode = kCAFillModeForwards;
        
        [shapeLayer addAnimation:basic2 forKey:nil];
        [shapeLayerRed addAnimation:basic2 forKey:nil];
        
        [self.BGScrollView.layer addSublayer:shapeLayer];
        [self.layerArr addObject:shapeLayer];
        
        [self.BGScrollView.layer addSublayer:shapeLayerRed];
        [self.layerArr addObject:shapeLayerRed];
        
    }
    
    
    

    /*        绘制X轴提示语  不管是否设置了是否绘制X、Y轴 提示语都应有         */
    if (_xShowInfoText.count == _valueArr.count&&_xShowInfoText.count>0) {
        
        NSInteger count = [_valueArr[0] count];
        
        for (NSInteger i = 0; i<_xShowInfoText.count; i++) {
            

            
            CATextLayer *textLayer = [CATextLayer layer];
            
         
            
            
            
            CGSize size = [_xShowInfoText[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.xDescTextFontSize]} context:nil].size;
            
        
            textLayer.frame = CGRectMake( _originSize.x-size.width-3, i * (count * _columnHeight + _typeSpace) + _typeSpace + _originSize.y+_columnHeight*0.5-size.height*0.5,size.width, size.height);
            textLayer.string = [NSString stringWithFormat:@"%@",_xShowInfoText[i]];
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            UIFont *font = [UIFont systemFontOfSize:self.xDescTextFontSize];
            

            
            textLayer.fontSize = font.pointSize;
            
            textLayer.foregroundColor = _drawTextColorForX_Y.CGColor;
            
            textLayer.alignmentMode = kCAAlignmentCenter;
            
            [_BGScrollView.layer addSublayer:textLayer];
            
            [self.layerArr addObject:textLayer];
            
            
        }
        
        
    }
    
    
    
    
    
    
    /*        动画展示         */
    for (NSInteger i = 0; i<_valueArr.count; i++) {
        
        
        NSArray *arr = _valueArr[i];

        for (NSInteger j = 0; j<arr.count; j++) {
            

            CGFloat height =[arr[j] floatValue] *_perHeight;
            

            UIView *itemsView = [UIView new];
            [self.showViewArr addObject:itemsView];

            itemsView.frame = CGRectMake(_originSize.x,(i * arr.count + j)*_columnHeight + i*_typeSpace+_originSize.y + _typeSpace , 0, _columnHeight);
            
            
            
            itemsView.backgroundColor = (UIColor *)(_columnBGcolorsArr.count<arr.count?[UIColor greenColor]:_columnBGcolorsArr[i]);
            [UIView animateWithDuration:1 animations:^{
                
                 itemsView.frame = CGRectMake(_originSize.x,(i * arr.count + j)*_columnHeight + i*_typeSpace+_originSize.y + _typeSpace , height, _columnHeight);
                
            } completion:^(BOOL finished) {
                /*        动画结束后添加提示文字         */
                if (finished) {
                    
                    CATextLayer *textLayer = [CATextLayer layer];
                    
                    [self.layerArr addObject:textLayer];
                    NSString *str = [NSString stringWithFormat:@"%@",arr[j]];
                    
                    CGSize size = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9]} context:nil].size;

                    textLayer.frame = CGRectMake( _originSize.x +height, (i * arr.count + j)*_columnHeight + i*_typeSpace+_originSize.y + _typeSpace+_columnHeight*0.5-size.height*0.5, size.width+2, size.height);
//                    NSLog(@"%@",str);
                    textLayer.string = str;
                    
                    textLayer.fontSize = 9.0;
                    
                    textLayer.alignmentMode = kCAAlignmentCenter;
                    textLayer.contentsScale = [UIScreen mainScreen].scale;
                    textLayer.foregroundColor = _drawTextColorForX_Y.CGColor;
                    
                    [_BGScrollView.layer addSublayer:textLayer];
                 
                    
                    
                    
                }
                
            }];
            
            [self.BGScrollView addSubview:itemsView];
            

        }
        
    }
    
    
    
    
    
}


-(void)clear{
    
    
    for (CALayer *lay in self.layerArr) {
        [lay removeAllAnimations];
        [lay removeFromSuperlayer];
    }
    
    for (UIView *subV in self.showViewArr) {
        [subV removeFromSuperview];
    }
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
    if (flag) {
        
        if (_isShowLineChart) {
            

                for (int32_t m=0;m<_lineValueArray.count;m++) {
                    NSLog(@"%@",_drawLineValue[m]);


                        
                        CAShapeLayer *roundLayer = [CAShapeLayer layer];
                        UIBezierPath *roundPath = [UIBezierPath bezierPathWithArcCenter:[_drawLineValue[m] CGPointValue] radius:4.5 startAngle:M_PI_2 endAngle:M_PI_2 + M_PI * 2 clockwise:YES];
                        roundLayer.path = roundPath.CGPath;
                        roundLayer.fillColor = _lineChartValuePointColor.CGColor;
                    [self.layerArr addObject:roundLayer];
                        [self.BGScrollView.layer addSublayer:roundLayer];
                        

                    
                }
                

            
        }
        
    }
    
    
}







@end
