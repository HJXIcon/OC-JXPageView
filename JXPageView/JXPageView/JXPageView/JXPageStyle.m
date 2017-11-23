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
        self.multilineEnable = NO;
        self.titleGradientEffectEnable = YES;
        
        self.isShowSeparatorLine = NO;
        self.separatorLineColor = [UIColor whiteColor];
        
        self.contentViewIsScrollEnabled = YES;
        
        
    }
    return self;
}

- (CGSize)separatorLineSize{
    if (_separatorLineSize.height == 0 || _separatorLineSize.width == 0) {
        return CGSizeMake(1, self.titleHeight);
    }
    return _separatorLineSize;
}


@end
