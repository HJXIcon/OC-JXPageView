//
//  ViewController.m
//  JXPageView
//
//  Created by yituiyun on 2017/10/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "JXPageView.h"

/// 底部宏，吃一见长一智吧，别写数字了
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX ([UIScreen mainScreen].bounds.size.width>=375.0f && [UIScreen mainScreen].bounds.size.height>=812.0f && IS_IPHONE)

// 导航栏默认高度
#define  E_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

@interface ViewController ()

@property (nonatomic, weak) JXPageView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    NSArray *titles = @[@"适合",@"十二班",@"的华",@"推荐爱推荐爱\n酒店",@"人丹33",@"适合",@"十二班",@"的华"];
    JXPageStyle *style = [[JXPageStyle alloc]init];
    
    style.titleFont = [UIFont systemFontOfSize:18];
    style.isScrollEnable = YES;
    style.isShowBottomLine = YES;
    style.multilineEnable = YES;
    style.titleHeight = 60;
    style.titleMargin = 30;
    style.isShowSeparatorLine = YES;
    style.separatorLineSize = CGSizeMake(1, 44);
    style.separatorLineColor = [UIColor blueColor];
//    style.contentViewIsScrollEnabled = NO;
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        
        [childVcs addObject:vc];
    }
    
    CGRect pageViewFrame = CGRectMake(0, E_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - E_StatusBarAndNavigationBarHeight);
    
    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    
    self.pageView = pageView;
    
    [self.view addSubview:pageView];
    
}
- (IBAction)push:(id)sender {
    
//    [self.pageView setPageViewCurrentIndex:arc4random_uniform(5)];
        [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
