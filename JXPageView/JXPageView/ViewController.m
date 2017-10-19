//
//  ViewController.m
//  JXPageView
//
//  Created by yituiyun on 2017/10/19.
//  Copyright © 2017年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "JXPageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    
    NSArray *titles = @[@"适合",@"十二班",@"的华",@"推荐爱推荐爱",@"人丹33",@"适合",@"十二班",@"的华"];
    JXPageStyle *style = [[JXPageStyle alloc]init];
    
    style.isScrollEnable = NO;
    style.isShowBottomLine = YES;
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        
        [childVcs addObject:vc];
    }
    
    CGRect pageViewFrame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    
    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    
    [self.view addSubview:pageView];
    
}
- (IBAction)push:(id)sender {
    
    [self.navigationController pushViewController:[[ViewController alloc]init] animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
