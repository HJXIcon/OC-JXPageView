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
    style.titleGradientEffectEnable = NO;
    style.normalColor = [UIColor blackColor];
    style.selectColor = [self colorWithHexString:@"0xffbf00"];
    style.titeViewBackgroundColor = [UIColor redColor];
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        
        [childVcs addObject:vc];
    }
    
    CGRect pageViewFrame = CGRectMake(0, E_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - E_StatusBarAndNavigationBarHeight);
    
    /// 创建方式一
//    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    
    
    /// 创建方式二
    JXPageView *pageView = [[JXPageView alloc]init];
    pageView.titles = titles;
    pageView.style = style;
    pageView.frame = pageViewFrame;
    pageView.childVcs = childVcs;
    pageView.parentVc = self;
    self.pageView = pageView;
    
    [self.view addSubview:pageView];
    
}
- (IBAction)push:(id)sender {
    
//    [self.pageView setPageViewCurrentIndex:arc4random_uniform(5)];
        [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
    
}




- (UIColor *)colorWithHexString:(NSString *)string{
    
    
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
