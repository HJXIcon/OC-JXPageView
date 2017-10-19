//
//  JXPageViewProtocol.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/4.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

@class JXPageContentView,JXTitleView;

@protocol JXPageContentViewDelegate <NSObject>

- (void)pageContentView:(JXPageContentView *)pageContentView didEndScroll:(int)inIndex;

- (void)pageContentView:(JXPageContentView *)pageContentView sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex progress:(CGFloat)progress;

@end


@protocol JXTitleViewDelegate <NSObject>

- (void)titleView:(JXTitleView *)titleView targetIndex:(NSInteger)targetIndex;

@end





