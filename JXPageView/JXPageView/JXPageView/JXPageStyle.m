//
//  JXPageStyle.m
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXPageStyle.h"
#import "UIColor+pageExtension.h"

@implementation JXPageStyle

- (instancetype)init{
    
    if (self = [super init]) {
        self.titleHeight = 44;
        self.normalColor = [UIColor colorWithR:255 g:255 b:255 a:1];
        self.selectColor = [UIColor colorWithR:176 g:22 b:22 a:1];
        self.titleFont = [UIFont systemFontOfSize:14];
        self.isScrollEnable = NO;
        self.titleMargin = 20;
        self.isShowBottomLine = YES;
        self.bottomLineHeight = 2;
        self.bottomLineColor = [UIColor blueColor];
        self.isNeedScale = YES;
        self.maxScaleRang = 1.2;
        
    }
    return self;
}
@end
