//
//  JXPageView.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPageContentView.h"
#import "JXPageStyle.h"
#import "UIColor+pageExtension.h"
#import "JXTitleView.h"

@interface JXPageView : UIView

///////// ------------------- 必须有值 ---------------------------------
@property(nonatomic, copy) NSArray <NSString *>*titles;
@property(nonatomic, copy) NSArray <UIViewController *>*childVcs;
// 注意使用weak，否则造成循环引用
@property(nonatomic, weak) UIViewController *parentVc;
///////// ------------------- 必须有值 ---------------------------------

@property(nonatomic, strong) JXPageStyle *style;

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray <NSString *>*)titles
                        style:(JXPageStyle *)style
                     childVcs:(NSArray <UIViewController *>*)childVcs
                     parentVc:(UIViewController *)parentVc;

/**
 给外界提供的方法
 
 @param currentIndex 选中下标
 */
- (void)setPageViewCurrentIndex:(int)currentIndex;
@end
