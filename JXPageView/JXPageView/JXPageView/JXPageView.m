//
//  JXPageView.m
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXPageView.h"
#ifdef DEBUG
#define JXLog(format,...)  NSLog((@"[函数名:%s]\n" "[行号:%d]\n" format),__FUNCTION__,__LINE__,##__VA_ARGS__)
#else
#define JXLog(...)
#endif

@interface JXPageView ()

@property (nonatomic, weak) JXTitleView *titleView;
@end
@implementation JXPageView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                        style:(JXPageStyle *)style
                     childVcs:(NSArray <UIViewController *>*)childVcs
                     parentVc:(UIViewController *)parentVc{
    
    self.titles = titles;
    self.style = style;
    self.childVcs = childVcs;
    self.parentVc = parentVc;
    
    return [self initWithFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        NSAssert(self.childVcs.count>0, @"JXPageView's childVcs must be not nil");
        NSAssert(self.titles.count>0, @"JXPageView's titles must be not nil");
        NSAssert(self.parentVc, @"JXPageView's parentVc must be not nil");
        [self setupUI];
    }
}


- (void)setupUI{
    // 1.创建titleView
    CGRect titleFrame = CGRectMake(0, 0, self.bounds.size.width, self.style.titleHeight);
    
    JXTitleView *titleView = [[JXTitleView alloc]initWithFrame:titleFrame titles:self.titles style:self.style];
    self.titleView = titleView;
    if (@available(iOS 11.0, *)) {
        titleView.adjustsScrollViewInsetsNO = self.style.adjustsScrollViewInsetsNO;
    }
    titleView.backgroundColor = self.style.titeViewBackgroundColor;
    [self addSubview:titleView];
    
    // 2.创建contentView
    CGRect contentViewFram = CGRectMake(0, CGRectGetMaxY(titleView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(titleView.frame));
    JXPageContentView *contentView = [[JXPageContentView alloc]initWithFrame:contentViewFram childVcs:self.childVcs parentVc:self.parentVc];
    contentView.isScrollEnabled = self.style.contentViewIsScrollEnabled;
    if (@available(iOS 11.0, *)) {
        contentView.adjustsScrollViewInsetsNO = self.style.adjustsScrollViewInsetsNO;
    }
    [self addSubview:contentView];
    
    // 3.让titleView跟contentView沟通
    titleView.delegate = contentView;
    contentView.delegate = titleView;
    
    
    
}

#pragma mark - Public Method
/**
 给外界提供的方法
 
 @param currentIndex 选中下标
 */
- (void)setPageViewCurrentIndex:(int)currentIndex{
    [self.titleView setPageTitleViewCurrentIndex:currentIndex];
}

- (void)dealloc{
    JXLog(@"JXPageView -- dealloc");
}
@end
