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


@interface JXTitleView : UIView<JXPageContentViewDelegate>

@property(nonatomic, copy) NSArray <NSString *>*titles;
@property(nonatomic, strong) JXPageStyle *style;
@property (nonatomic, assign) BOOL adjustsScrollViewInsetsNO API_AVAILABLE(ios(11.0),tvos(11.0));
/** delegate*/
@property (nonatomic, weak)id<JXTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(JXPageStyle *)style;

/**
 给外界提供的方法
 
 @param index 选中下标
 */
- (void)setPageTitleViewCurrentIndex:(int)index;
@end
