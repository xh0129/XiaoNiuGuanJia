//
//  DrawViewController.m
//  QLProduct
//
//  Created by Qiulong-CQ on 16/11/23.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawView.h"

@interface DrawViewController ()<UIScrollViewDelegate>

{
}

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"统计曲线图";
    self.view.backgroundColor = [UIColor whiteColor];
    [self drawName];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width - ScrollViewRightMargin, 200)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width + RightMargin, 200)];
    [scrollView addSubview:drawView];
    [scrollView setContentSize:drawView.frame.size];
    [scrollView setContentOffset:CGPointMake(RightMargin, 0)];
    
    [drawView drawLineChartViewWithX_Value_Names:[NSMutableArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil] TargetValues:[NSMutableArray arrayWithObjects:@[@80,@50,@60,@20,@60,@80,@40,@80],
                         @[@40,@60,@70,@30,@10,@70,@50,@40],
                         @[@30,@80,@60,@35,@80,@40,@30,@30],nil] LineType:LineType_Curve getValue:^(int a, int b, int c) {
        UILabel *label = [self.view viewWithTag:111];
        label.text = [NSString stringWithFormat:@"里程:%dkm",a];
        
        UILabel *label2 = [self.view viewWithTag:222];
        label2.text = [NSString stringWithFormat:@"均速:%dkm/h",b];
        
        UILabel *label3 = [self.view viewWithTag:333];
        label3.text = [NSString stringWithFormat:@"耗电:%d%%",c];
        
       
    }];

    
    
    
    // Do any additional setup after loading the view.
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
{
    NSLog(@"%f==%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (scrollView.contentOffset.x < 0) {
        //加载更多
        
        dispatch_queue_t concurrentQueue =dispatch_get_main_queue();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), concurrentQueue, ^(void){
            for (UIView *vi in scrollView.subviews) {
                CGRect frame = vi.frame;
                [UIView animateWithDuration:1 animations:^{
                    vi.frame = CGRectMake(frame.origin.x + frame.size.width - RightMargin, 0, frame.size.width, frame.size.height);
                }];
            }
            //        [lastDrawView cleanChooseLayers];
            
            DrawView *drawView = [[DrawView alloc] initWithFrame:CGRectMake(0 - scrollView.frame.size.width, 0, scrollView.frame.size.width + RightMargin, 200)];
            [scrollView addSubview:drawView];
            [scrollView setContentSize:CGSizeMake(RightMargin + (drawView.frame.size.width - RightMargin) * scrollView.subviews.count, 200)];
            //        [scrollView setContentOffset:CGPointMake(RightMargin + drawView.frame.size.width - RightMargin * (scrollView.subviews.count - 1), 0) animated:YES];
            
            [UIView animateWithDuration:1 animations:^{
                drawView.frame = CGRectMake(0, 0, drawView.frame.size.width, drawView.frame.size.height);
            }];
            
            [drawView drawLineChartViewWithX_Value_Names:[NSMutableArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil] TargetValues:[NSMutableArray arrayWithObjects:@[@80,@50,@60,@20,@60,@80,@40,@80],
                                 @[@40,@60,@70,@30,@10,@70,@50,@40],
                                 @[@30,@80,@60,@35,@80,@40,@30,@30],nil] LineType:LineType_Curve getValue:^(int a, int b, int c) {
                UILabel *label = [self.view viewWithTag:111];
                label.text = [NSString stringWithFormat:@"里程:%dkm",a];
                
                UILabel *label2 = [self.view viewWithTag:222];
                label2.text = [NSString stringWithFormat:@"均速:%dkm/h",b];
                
                UILabel *label3 = [self.view viewWithTag:333];
                label3.text = [NSString stringWithFormat:@"耗电:%d%%",c];
                
            }];
        });
        
    }
}
- (void)drawName{
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 300, 100, 30)];
    label1.tag = 111;
    label1.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label1];
    label1.textAlignment = 2;
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 12, 6, 6) cornerRadius:3];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = color1;
    layer.fillColor = color1;
    layer.path = path1.CGPath;
    [label1.layer addSublayer:layer];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, 300, 100, 30)];
    label2.tag = 222;
    label2.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label2];
    label2.textAlignment = 2;
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 12, 6, 6) cornerRadius:3];
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.strokeColor = color2;
    layer2.fillColor = color2;
    layer2.path = path2.CGPath;
    [label2.layer addSublayer:layer2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 50, 300, 100, 30)];
    label3.tag = 333;
    label3.font = [UIFont systemFontOfSize:10];
    [self.view addSubview:label3];
    label3.textAlignment = 2;
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 12, 6, 6) cornerRadius:3];
    CAShapeLayer *layer3 = [CAShapeLayer layer];
    layer3.strokeColor = color3;
    layer3.fillColor = color3;
    layer3.path = path3.CGPath;
    [label3.layer addSublayer:layer3];
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
