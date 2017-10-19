//
//  UIColor+pageExtension.m
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "UIColor+pageExtension.h"
#import <UIKit/UIKit.h>

@implementation UIColor (pageExtension)

+ (UIColor *)randomColor{
    
    return [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
}


+ (instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a{
    
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
}


+ (UIColor *)ColorWithHexString:(NSString *)hexString{
    // 1.判断字符串长度是否大于6
    
    if (hexString.length <= 6) {
        return nil;
    }
    
    // 2.将字符转成大写
    NSString *hexTempString = hexString.uppercaseString;
    
    // 3.判断字符是否是X0/##FF0053
    if ([hexTempString hasPrefix:@"0X"] || [hexTempString hasPrefix:@"##"]) {
        
        hexTempString = [hexTempString substringFromIndex:2];
    }
    
    // 4。判断字符是否是以#开头
    if ([hexTempString hasPrefix:@"#"]) {
        hexTempString = [hexTempString substringFromIndex:1];
    }
    
    // 5.获取RGB分别对应的16进制
    // r:FF g:00 b:22
    NSRange range = NSMakeRange(0, 2);
    NSString *rHex = [hexTempString substringWithRange:range];
    
    range.location = 2;
    NSString *gHex = [hexTempString substringWithRange:range];
    
    range.location = 4;
    NSString *bHex = [hexTempString substringWithRange:range];
    
    UInt32 r = 0;
    UInt32 g = 0;
    UInt32 b = 0;
    
    NSScanner *scanner1 = [[NSScanner alloc]initWithString:rHex];
    [scanner1 scanHexInt:&r];
    
    NSScanner *scanner2 = [[NSScanner alloc]initWithString:gHex];
    [scanner2 scanHexInt:&g];
    
    NSScanner *scanner3 = [[NSScanner alloc]initWithString:bHex];
    [scanner3 scanHexInt:&b];
    
    
    return [self colorWithR:r g:g b:b a:1];
}


#pragma mark - 从颜色重获取RGB

/**
 从颜色重获取RGB

 @return CGFloat数据数组
 */
- (NSArray <NSNumber *> *)getNomalRGB{
 
    CGFloat R, G, B;
    NSUInteger num = CGColorGetNumberOfComponents(self.CGColor);
    
    if (num <= 0) {
        
         @throw [NSException exceptionWithName:@"JXError" reason:@"请确定带颜色是通过RGB创建的" userInfo:nil];
    }
    
    
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    R = components[0] * 255;
    G = components[1] * 255;
    B = components[2] * 255;
    
    
    return @[@(R),@(G),@(B)];
    
}

@end
