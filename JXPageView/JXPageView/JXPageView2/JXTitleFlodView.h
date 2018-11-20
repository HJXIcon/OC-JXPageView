//
//  JXTitleFlodView.h
//  TaPinCaiXiaoAPP
//
//  Created by admin on 2018/11/9.
//  Copyright © 2018年 iCash. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXTitleFlodView : UIView
@property (nonatomic, copy) NSArray<NSString *> *titles;
@property (nonatomic, assign) CGFloat titlesSpacing;
@property (nonatomic, assign) CGFloat titlesLineSpacing;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) void(^SelectBlock)(NSInteger selectIndex);
@property (nonatomic, copy) void(^DidClickOutSideBlokck)(void);

@end

NS_ASSUME_NONNULL_END
