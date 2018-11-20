//
//  JXPageStyle.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JXPageTitleStyle) {
    JXPageTitleStyleDefualt,// 默认是支持滚动,右边没有数量
    JXPageTitleStyleFasten, // 固定数量显示，并且不能滚动
    JXPageTitleStyleCanFlod // 不能滚动，超过固定数量，其他可以折叠
};

@interface JXPageStyle : NSObject

@property (nonatomic, assign) JXPageTitleStyle titleStyle;
/// 固定个数，除了JXPageTitleStyleDefualt生效， 默认是4个
@property (nonatomic, assign) NSInteger fastenCount;


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
/** 是否显示底部条*/
@property (nonatomic, assign)BOOL isShowBottomLine;
/** 标题间距:JXPageTitleStyleDefualt 生效*/
@property (nonatomic, assign)CGFloat titleMargin;
/** 底部滑动条颜色*/
@property (nonatomic, strong)UIColor *bottomLineColor;
/** 底部滑动条高度*/
@property (nonatomic, assign)CGFloat bottomLineHeight;
/**！
 底部滑动条宽度比例:默认0.8
 注意：
 JXPageTitleStyleDefualt的bottomLine不生效，
 JXPageTitleStyleDefualt的宽度是对应的标题的宽度
 */
@property (nonatomic, assign)CGFloat bottomLineWidthScale;
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



/// >>>>>> 折叠样式:JXPageTitleStyleCanFload
/// 折叠图片
@property (nonatomic, strong) NSString *foldImageName;
/// 折叠图片大小
@property (nonatomic, assign) CGSize flodImageSize;
/// 折叠左右边距
@property (nonatomic, assign) CGFloat flodEdgeMargin;



/// >>>>>> ContentView
#pragma mark - *** ContentView
/** ContentView 是否可以滚动 */
@property (nonatomic, assign) BOOL contentViewIsScrollEnabled; // default YES


@end
