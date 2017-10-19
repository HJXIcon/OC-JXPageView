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
@property(nonatomic, strong)NSArray <UIViewController *>*childVcs;
@property(nonatomic, weak)UIViewController *parentVc;

@property(nonatomic, weak) id<JXPageContentViewDelegate>delegate;


- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc;


@end
