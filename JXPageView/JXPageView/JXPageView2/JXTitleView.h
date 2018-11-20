//
//  JXTitleView.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPageStyle.h"
#import "JXPageViewProtocol.h"

UIKIT_EXTERN NSString *const JXDidSelectFlodIndexNotiName;
UIKIT_EXTERN NSString *const JXDidClickFlodNotiName;
@interface JXTitleView : UIView<JXPageContentViewDelegate>

@property (nonatomic, copy) NSArray <NSString *>*titles;
@property (nonatomic, strong) JXPageStyle *style;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/** delegate*/
@property (nonatomic, weak)id<JXTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(JXPageStyle *)style;

/**
 给外界提供的方法
 
 @param targetIndex 选中下标
 */
- (void)setPageTitleViewCurrentIndex:(NSInteger)targetIndex;
@end
