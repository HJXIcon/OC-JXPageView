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
/// >>>>>> Title
#pragma mark - *** Title
/** 标题View的背景颜色*/
@property (nonatomic, strong) UIColor *titeViewBackgroundColor;
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
/** 底部滑动条颜色*/
@property (nonatomic, strong)UIColor *bottomLineColor;
/** 底部滑动条高度*/
@property (nonatomic, assign)CGFloat bottomLineHeight;
/** 是否缩放*/
@property (nonatomic, assign)BOOL isNeedScale;
/** 最大缩放程度*/
@property (nonatomic, assign)CGFloat maxScaleRang;
/** 标题是否支持多行 */
@property (nonatomic, assign) BOOL multilineEnable; // default NO
/** 是否让标题按钮文字有渐变效果，默认为 YES */
@property (nonatomic, assign) BOOL titleGradientEffectEnable;


/// >>>>>> SeparatorLine
#pragma mark - *** SeparatorLine
/** 标题直接是否有分割线 */
@property (nonatomic, assign) BOOL isShowSeparatorLine; // default NO
/** 分割线颜色 */
@property (nonatomic, strong) UIColor *separatorLineColor;
/** 分割线size */
@property (nonatomic, assign) CGSize separatorLineSize;


/// >>>>>> ContentView
#pragma mark - *** ContentView
/** ContentView 是否可以滚动 */
@property (nonatomic, assign) BOOL contentViewIsScrollEnabled; // default YES

/// iOS 11之后 类似automaticallyAdjustsScrollViewInsets == NO 需要设置为YES
@property (nonatomic, assign) BOOL adjustsScrollViewInsetsNO API_AVAILABLE(ios(11.0),tvos(11.0));

@end
