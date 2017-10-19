//
//  JXPageStyle.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JXPageStyle : NSObject


/** 标题View的高度*/
@property (nonatomic, assign)CGFloat titleHeight;
/** 文本普通颜色*/
@property (nonatomic, strong)UIColor *normalColor;
/** 文本选中颜色*/
@property (nonatomic, strong)UIColor *selectColor;
/** font*/
@property (nonatomic, strong)UIFont *titleFont;
/** 标题是否可以滚动*/
@property (nonatomic, assign)BOOL isScrollEnable;
/** 是否显示底部条*/
@property (nonatomic, assign)BOOL isShowBottomLine;
/** 标题间距*/
@property (nonatomic, assign)CGFloat titleMargin;

/** 滑动条颜色*/
@property (nonatomic, strong)UIColor *bottomLineColor;
/** 滑动条高度*/
@property (nonatomic, assign)CGFloat bottomLineHeight;
/** 是否缩放*/
@property (nonatomic, assign)BOOL isNeedScale;
/** 最大缩放程度*/
@property (nonatomic, assign)CGFloat maxScaleRang;

@end
