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
@property(nonatomic, strong, readonly) UICollectionView *collectionView;
@property(nonatomic, weak) id<JXPageContentViewDelegate>delegate;

/** 是否需要滚动 默认为 YES*/
@property (nonatomic, assign) BOOL isScrollEnabled;

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc;


@end
