//
//  JXPageContentView.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPageViewProtocol.h"

@interface JXPageContentView : UIView<JXTitleViewDelegate>
@property(nonatomic, copy)NSArray <UIViewController *>*childVcs;
@property(nonatomic, weak)UIViewController *parentVc;

@property(nonatomic, weak) id<JXPageContentViewDelegate>delegate;

/** 是否需要滚动 默认为 YES*/
@property (nonatomic, assign) BOOL isScrollEnabled;

@property (nonatomic, assign) BOOL adjustsScrollViewInsetsNO API_AVAILABLE(ios(11.0),tvos(11.0));

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc;



@end
