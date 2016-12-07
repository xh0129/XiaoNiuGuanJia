//
//  DrawView.h
//  QLProduct
//
//  Created by Qiulong-CQ on 16/11/23.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawConfig.h"


typedef void(^ChooseValue)(int a,int b,int c);

@interface DrawView : UIView

@property (nonatomic,strong) NSArray *x_names;
@property (nonatomic,strong) NSArray *targetValues;
@property (nonatomic,strong) NSMutableArray *chooseLayers;

//初始化画布
-(instancetype)initWithFrame:(CGRect)frame;


/**
 *  画折线图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 *  @param lineType     直线类型
 */
-(void)drawLineChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues LineType:(LineType) lineType getValue:(ChooseValue)chooseValue;;


/**
 *  画柱状图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 */
-(void)drawBarChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;


/**
 *  画饼状图
 *  @param x_names      x轴值的所有值名称
 *  @param targetValues 所有目标值
 */
-(void)drawPieChartViewWithX_Value_Names:(NSMutableArray *)x_names TargetValues:(NSMutableArray *)targetValues;

- (void)cleanChooseLayers;


@end
