//
//  JXTitleFlodView.m
//  TaPinCaiXiaoAPP
//
//  Created by admin on 2018/11/9.
//  Copyright © 2018年 iCash. All rights reserved.
//

#import "JXTitleFlodView.h"

@interface JXTitleFlodView ()
@property (nonatomic, strong) NSMutableArray<UILabel *> *titleLabels;
@property (nonatomic, strong) UIView *contentView;

@end
@implementation JXTitleFlodView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titlesSpacing = self.titlesLineSpacing = 10;
        self.selectIndex = 0;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSArray<NSString *> *)titles{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
    }
    return self;
}

#pragma mark - *** lazy loading
- (NSMutableArray<UILabel *> *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self _setupUI];
}


- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self.titleLabels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (selectIndex == idx) {
            obj.textColor = self.selectColor;
        }else{
            obj.textColor = self.normalColor;
        }
    }];
}

- (void)_setupUI{
    self.backgroundColor = [UIColor colorWithColorString:@"#000000" andAlphaValue:0.6];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesAction)];
    [self addGestureRecognizer:tapGes];
    
    [self.titleLabels removeAllObjects];
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    
    // 0.添加所有的label
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [[UILabel alloc]init];
        label.tag = idx;
        label.userInteractionEnabled = YES;
        label.text = self.titles[idx];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = self.titleFont;
        if (self.selectIndex == idx) {
            label.textColor = self.selectColor;
        }else{
            label.textColor = self.normalColor;
        }
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClickAction:)];
        [label addGestureRecognizer:tap];
        [self.contentView addSubview:label];
        [self.titleLabels addObject:label];
    }];
    
    // 1.计算每个label的宽度
    CGFloat labelH = [self.titles.firstObject boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.height;
    labelH += 10;// 加一定的高度
    CGFloat labelX = self.titlesSpacing;
    CGFloat labelY = self.titlesLineSpacing;
    CGFloat labelW;
    
    for (NSInteger i = 0; i < self.titleLabels.count; i ++) {
        labelW = [self.titles[i] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.width;
        // 2.判断是否换行
        if (labelX + labelW > CGRectGetWidth(self.bounds)) {
            labelX = self.titlesSpacing;
            labelY += labelH + self.titlesLineSpacing;
        }
        self.titleLabels[i].frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        labelX += self.titlesSpacing + labelW;
        
    }
    
    // 3.设置整体高度
    CGRect frame = self.contentView.frame;
    frame.size.height = CGRectGetMaxY(self.titleLabels.lastObject.frame)+self.titlesLineSpacing;
    self.contentView.frame = frame;
    
}


#pragma mark - *** Actions
- (void)titleLabelClickAction:(UITapGestureRecognizer *)tap{
    UIView *view = tap.view;
    if (![view isKindOfClass:[UILabel class]]) {
        return;
    }
    
    UILabel *targetLabel = (UILabel *)tap.view;
    // 0.判断是不是之前点击的label
    if (targetLabel.tag == self.selectIndex) {
        return;
    }
    
    // 1.让之前的label不选中，现在的选中
    UILabel *sourceLabel = self.titleLabels[self.selectIndex];
    targetLabel.textColor = self.selectColor;
    sourceLabel.textColor = self.normalColor;
    self.selectIndex = targetLabel.tag;
    
    if (self.SelectBlock) {
        self.SelectBlock(self.selectIndex);
    }
}


- (void)tapGesAction{
    if (self.DidClickOutSideBlokck) {
        self.DidClickOutSideBlokck();
    }
}

@end
