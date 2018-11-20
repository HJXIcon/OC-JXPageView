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
        
        _fastenCount = 4;
        _bottomLineWidthScale = 0.8;
        
        self.titeViewBackgroundColor = [UIColor whiteColor];
        self.titleHeight = 44;
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleMargin = 20;
        self.isShowBottomLine = YES;
        self.bottomLineHeight = 2;
        self.bottomLineColor = [UIColor blueColor];
        self.isNeedScale = YES;
        self.maxScaleRang = 1.2;
        self.titleGradientEffectEnable = YES;
        
        self.contentViewIsScrollEnabled = YES;
        
    }
    return self;
}



@end
