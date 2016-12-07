//
//  DrawView.m
//  QLProduct
//
//  Created by Qiulong-CQ on 16/11/23.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "DrawView.h"

static CGRect myFrame;

@interface DrawView()

@property (nonatomic,assign) float Xspace;
@property (nonatomic,assign) float Yspace;

@property (nonatomic,copy) ChooseValue chooseValue;

@end

@implementation DrawView

//初始化画布
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        //背景视图
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backView.backgroundColor = [UIColor clearColor];
        [self addSubview:backView];
        
        myFrame = frame;
    }
    return self;
    
}

/**
 *  画坐标轴
 */
-(void)drawXYLine:(NSMutableArray *)x_names{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //先算出每格的间距
    self.Xspace = (CGRectGetWidth(myFrame) - RightMargin) / 7;
    self.Yspace = (CGRectGetHeight(myFrame) - TopMargin - BottomMargin - BottomLabelHeight) / 10;
    
    //画竖线
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = self.Xspace*i;
        CGFloat Y = CGRectGetHeight(myFrame) - BottomMargin - BottomLabelHeight;
        CGPoint point = CGPointMake(X,Y);
        [path moveToPoint:point];
        [path addLineToPoint:CGPointMake(point.x, TopMargin)];
    }
    
    //X轴名称 点击button
    for (int i=0; i<x_names.count; i++) {
        CGFloat X = self.Xspace*i - self.Xspace/2;
        CGFloat Y = CGRectGetHeight(myFrame)-BottomLabelHeight - BottomMargin;
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(X,Y, self.Xspace, BottomLabelHeight)];
        textLabel.text = x_names[i];
        textLabel.font = [UIFont systemFontOfSize:10];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor blueColor];
        [self.subviews[0] addSubview:textLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(X, TopMargin, self.Xspace, CGRectGetHeight(myFrame) - BottomMargin);
        btn.tag = i + 1;
        [btn setBackgroundColor:[UIColor clearColor]];
        [self.subviews[0] addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            textLabel.hidden = YES;
            btn.hidden = YES;
        }else{
            textLabel.hidden = NO;
            btn.hidden = NO;
        }
    }
    
    //渲染路径
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor colorWithRed:112/255.f green:112/255.f blue:112/255.f alpha:0.1].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}


/**
 *  区域点击方法
 */
- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    NSString *str = self.x_names[btn.tag - 1];
    
    NSLog(@"%@",str);
    
    [self cleanChooseLayers];
    
    self.chooseLayers = [[NSMutableArray alloc] initWithCapacity:0];
    
    int a = 0;
    int b = 0;
    int c = 0;
    
    for (NSArray *arr in self.targetValues){
        NSLog(@"--%@",arr[btn.tag - 1]);
        int index = [self.targetValues indexOfObject:arr];

        int i = btn.tag - 1;
        
        CGFloat X = self.Xspace*i;
        CGFloat Y = CGRectGetHeight(myFrame)-BottomMargin - BottomLabelHeight -[arr[i] floatValue] * self.Yspace/10;
        CGPoint point = CGPointMake(X,Y);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-3, point.y-3, 6, 6) cornerRadius:3];
        CAShapeLayer *layer = [CAShapeLayer layer];
        if (index == 0) {
            layer.strokeColor = color1;
            layer.fillColor = color1;

        }else if (index == 1){
            layer.strokeColor = color2;
            layer.fillColor = color2;

        }else{
            layer.strokeColor = color3;
            layer.fillColor = color3;
        }
        layer.path = path.CGPath;
        [self.subviews[0].layer addSublayer:layer];
        [self.chooseLayers addObject:layer];
        
        
        if (index == 0) {

            a = [arr[btn.tag - 1] intValue];
        }else if (index == 1) {

            b = [arr[btn.tag - 1] intValue];

        }else{
            c = [arr[btn.tag - 1] intValue];

        }
        
    }
    _chooseValue(a,b,c);
}


/**
 *  坐标点
 */
- (NSMutableArray *)points:(NSArray *)array
{
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        CGFloat X = self.Xspace*i;
        CGFloat Y = CGRectGetHeight(myFrame)-BottomMargin - BottomLabelHeight-[array[i] floatValue] * self.Yspace/10;
        CGPoint point = CGPointMake(X,Y);
        [points addObject:[NSValue valueWithCGPoint:point]];
    }
    return points;
}
/**
 *  根据坐标点绘制出path
 */
- (UIBezierPath *)pathWithPoints:(NSArray *)points LineType:(LineType) lineType
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[points[0] CGPointValue]];
    CGPoint PrePonit;
    switch (lineType) {
        case LineType_Straight: //直线
            for (int i =1; i<points.count; i++) {
                CGPoint point = [points[i] CGPointValue];
                [path addLineToPoint:point];
            }
            break;
        case LineType_Curve:   //曲线
            for (int i =0; i<points.count; i++) {
                if (i==0) {
                    PrePonit = [points[0] CGPointValue];
                }else{
                    CGPoint NowPoint = [points[i] CGPointValue];
                    [path addCurveToPoint:NowPoint controlPoint1:CGPointMake((PrePonit.x+NowPoint.x)/2, PrePonit.y) controlPoint2:CGPointMake((PrePonit.x+NowPoint.x)/2, NowPoint.y)]; //三次曲线
                    PrePonit = NowPoint;
                }
            }
            break;
    }
    return path;
}
/**
 *  根据path画线
 */
- (void)drawLineWithPath:(UIBezierPath *)path index:(NSInteger)index
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    
    if (index == 0) {
        shapeLayer.strokeColor = color1; //随机颜色的线 XYQRandomColor.CGColor
    }else if (index == 1){
        shapeLayer.strokeColor = color2;
    }else{
        shapeLayer.strokeColor = color3;
        
    }
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 2.0;
    [self.subviews[0].layer addSublayer:shapeLayer];
}
/**
 *  坐标点值label
 */
- (void)drawLabelWithPoints:(NSArray *)points array:(NSArray *)arr
{
    CGPoint PrePonit = CGPointMake(0, 0);
    for (int i =0; i<points.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.subviews[0] addSubview:label];

        if (i==0) {
            CGPoint NowPoint = [points[0] CGPointValue];
            label.text = [NSString stringWithFormat:@"%.0f",[arr[i] floatValue]];
            label.frame = CGRectMake(NowPoint.x-self.Xspace/2, NowPoint.y-20, self.Xspace, 20);
            PrePonit = NowPoint;
        }else{
            CGPoint NowPoint = [points[i] CGPointValue];
            if (NowPoint.y<PrePonit.y) {  //文字置于点上方
                label.frame = CGRectMake(NowPoint.x-self.Xspace/2, NowPoint.y-20, self.Xspace, 20);
            }else{ //文字置于点下方
                label.frame = CGRectMake(NowPoint.x-self.Xspace/2, NowPoint.y, self.Xspace, 20);
            }
            label.text = [NSString stringWithFormat:@"%.0f",[arr[i] floatValue]];
            PrePonit = NowPoint;
        }
    }

}
/**
 *  绘制渐变色
 */
- (void)drawShadowLayerWithIndex:(NSInteger)index path:(UIBezierPath *)path points:(NSArray *)points{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, CGRectGetHeight(myFrame));
    if (index == 0) {
        gradientLayer.colors = colorArray1;
    }else if(index == 1){
        gradientLayer.colors = colorArray2;
    }else{
        gradientLayer.colors = colorArray3;
        
    }
    
    //        gradientLayer.locations = @[@0.3,@0.6,@0.8,@1];
    gradientLayer.startPoint = CGPointMake(0.0,0.0);
    gradientLayer.endPoint = CGPointMake(0.0,1);
    
    //形成闭合区域
    [path addLineToPoint:CGPointMake([[points lastObject] CGPointValue].x, CGRectGetHeight(myFrame) - BottomMargin - BottomLabelHeight)];
    [path addLineToPoint:CGPointMake([[points firstObject] CGPointValue].x, CGRectGetHeight(myFrame) - BottomMargin - BottomLabelHeight)];
    
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = path.CGPath;
    gradientLayer.mask = arc;
    [self.subviews[0].layer addSublayer:gradientLayer];
}
/**
 *  画折线图
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType getValue:(ChooseValue)chooseValue{
    
    //
    self.chooseLayers = [[NSMutableArray alloc] initWithCapacity:0];
    _chooseValue = chooseValue;
    self.x_names = x_names;
    self.targetValues = targetValues;
    
    //1.画坐标轴
    [self drawXYLine:x_names];
    
    for (NSArray *arr in targetValues) {
        
        NSInteger index = [targetValues indexOfObject:arr];
        
        //2.获取目标值点坐标
        NSMutableArray *points = [self points:arr];
        //3.坐标连线
        UIBezierPath *path = [self pathWithPoints:points LineType:lineType];
        //4.坐标点上显示文字
        //[self drawLabelWithPoints:points array:arr];
        //5.画线
        [self drawLineWithPath:path index:index];
        //6.画阴影部分
        [self drawShadowLayerWithIndex:index path:path points:points];
        
        UIButton *btn = (UIButton *)[self.subviews[0] viewWithTag:x_names.count];
        [self btnClick:btn];
    }
    
    
}
- (void)cleanChooseLayers;
{
    if (self.chooseLayers.count > 0) {
        for (CAShapeLayer *layer in self.chooseLayers) {
            [layer removeFromSuperlayer];
        }
    }
}

@end
