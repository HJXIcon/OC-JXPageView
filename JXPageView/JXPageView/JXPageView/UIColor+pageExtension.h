//
//  UIColor+pageExtension.h
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (pageExtension)

+ (UIColor *)randomColor;

+ (instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;

+ (UIColor *)ColorWithHexString:(NSString *)hexString;

/**
 从颜色重获取RGB
 
 @return CGFloat数据数组
 */
- (NSArray <NSNumber *> *)getNomalRGB;
@end
