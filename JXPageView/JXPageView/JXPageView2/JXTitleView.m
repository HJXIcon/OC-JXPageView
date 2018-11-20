//
//  JXTitleView.m
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXTitleView.h"
#import "UIColor+pageExtension.h"
#import "JXPageContentView.h"

NSString *const JXDidSelectFlodIndexNotiName = @"JXDidSelectFlodIndexNotiName";
NSString *const JXDidClickFlodNotiName = @"JXDidClickFlodNotiName";

@interface JXTitleView ()<JXPageContentViewDelegate>{
    NSInteger currentIndex;
    
}
@property(nonatomic, strong) NSArray <NSNumber *> * nomalRGB;
@property(nonatomic, strong) NSArray <NSNumber *> * selectRGB;
@property(nonatomic, strong) NSArray <NSNumber *> * deltaRGB;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, strong) NSMutableArray <UILabel *>*titleLabels;
@property(nonatomic, strong) UIButton *foldBtn;


@end
@implementation JXTitleView
#pragma mark - lazy load
- (NSMutableArray<UILabel *> *)titleLabels{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        CGRect frame = self.bounds;
        if (self.style.titleStyle == JXPageTitleStyleCanFlod) {
            frame.size.width -= self.style.flodEdgeMargin*2 + self.style.flodImageSize.width;
        }
        _scrollView = [[UIScrollView alloc]initWithFrame:frame];
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIButton *)foldBtn{
    if (_foldBtn == nil) {
        _foldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _foldBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)- self.style.flodImageSize.width-self.style.flodEdgeMargin*2, 0, self.style.flodImageSize.width+self.style.flodEdgeMargin*2, CGRectGetHeight(self.bounds));
        UIImageView *foldImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.style.foldImageName]];
        foldImageView.frame = CGRectMake(CGRectGetWidth(_foldBtn.frame)- self.style.flodImageSize.width-self.style.flodEdgeMargin, (CGRectGetHeight(_foldBtn.frame)-self.style.flodImageSize.height)*0.5, self.style.flodImageSize.width, self.style.flodImageSize.height);
        [_foldBtn addSubview:foldImageView];
        [_foldBtn addTarget:self action:@selector(flodAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldBtn;
}

- (UIView *)bottomLine{
    if (_bottomLine == nil) {
        _bottomLine = [[UIView alloc]init];
        _bottomLine.backgroundColor = self.style.bottomLineColor;
    }
    return _bottomLine;
}

#pragma mark - getter
- (NSArray<NSNumber *> *)nomalRGB{
    return [self.style.normalColor getNomalRGB];
}

- (NSArray<NSNumber *> *)selectRGB{
    return [self.style.selectColor getNomalRGB];
}

- (NSArray<NSNumber *> *)deltaRGB{
    NSNumber *num1 = @(self.selectRGB[0].floatValue - self.nomalRGB[0].floatValue);
    NSNumber *num2 = @(self.selectRGB[1].floatValue - self.nomalRGB[1].floatValue);
    NSNumber *num3 = @(self.selectRGB[2].floatValue - self.nomalRGB[2].floatValue);
    
    return @[num1,num2,num3];
    
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(JXPageStyle *)style{
    
    self.titles = titles;
    self.style = style;
    return [self initWithFrame:frame];
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    [self setupUI];
}



#pragma mark - UI
- (void)setupUI{
    currentIndex = 0;
    
    // 0.判断是否能折叠
    if (self.style.titleStyle == JXPageTitleStyleCanFlod) {
      [self addSubview:self.foldBtn];
    }
    
    // 1.添加ScrollView
    [self addSubview:self.scrollView];
    
    // 2.添加Lable
    if (self.style.titleStyle == JXPageTitleStyleDefualt) {
        [self setupDefualtTitlesLabel];
    }else{
        [self setupFastenOrFloadTitlesLabel];
    }
    
    // 3.初始化底部line
    if (self.style.isShowBottomLine) {
        [self setupBottomLine];
    }
    
}

- (void)setupBottomLine{
    [self.scrollView addSubview:self.bottomLine];
    CGFloat firstLableW = self.style.isNeedScale ? self.titleLabels.firstObject.frame.size.width/self.style.maxScaleRang : self.titleLabels.firstObject.frame.size.width;
    CGFloat lineW;
    if (self.style.titleStyle == JXPageTitleStyleDefualt) {
        lineW = [self.titleLabels.firstObject.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.style.titleFont} context:nil].size.width;
    }else{
        lineW = firstLableW * self.style.bottomLineWidthScale;
        
    }
    CGFloat lineY = self.style.titleHeight - self.style.bottomLineHeight;
    CGFloat lineX = (firstLableW - lineW)*0.5;
    if (self.style.titleStyle == JXPageTitleStyleDefualt) {
        lineX += self.style.titleMargin*0.5*0.5;
    }
    self.bottomLine.frame = CGRectMake(lineX, lineY, lineW, self.style.bottomLineHeight);
}

- (void)setupDefualtTitlesLabel{
    
    for (int i = 0; i < self.titles.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.text = self.titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = i == 0 ? self.style.selectColor : self.style.normalColor;
        label.font = self.style.titleFont;
        if (self.style.multilineEnable) label.numberOfLines = 0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        
        [self.scrollView addSubview:label];
        
        [self.titleLabels addObject:label];
    }
    
    // 2.设置Label的frame
    CGFloat labelH = self.style.titleHeight;
    CGFloat labelW = self.scrollView.frame.size.width / self.titles.count;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titleLabels.count; i ++) {
        
        CGSize size = CGSizeMake(MAXFLOAT, 0);
        
        labelW = [self.titleLabels[i].text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.style.titleFont} context:nil].size.width;
        labelX = i == 0 ? self.style.titleMargin * 0.5 : CGRectGetMaxX(self.titleLabels[i - 1].frame) + self.style.titleMargin;
        self.titleLabels[i].frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 是否有分割线
        if (self.style.isShowSeparatorLine && i > 0) {
            
            UILabel *leftLabel = self.titleLabels[i - 1];
            UILabel *rightLabel = self.titleLabels[i];
            
            /// 线的中心
            CGFloat lineCenterX = CGRectGetMinX(rightLabel.frame) - (CGRectGetMinX(rightLabel.frame) - CGRectGetMaxX(leftLabel.frame)) * 0.5;
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = self.style.separatorLineColor;
            line.frame = CGRectMake(0, (labelH - self.style.separatorLineSize.height) * 0.5, self.style.separatorLineSize.width, self.style.separatorLineSize.height);
            
            CGPoint lineCenter = line.center;
            lineCenter.x = lineCenterX;
            line.center = lineCenter;
            
            [self.scrollView addSubview:line];
            labelX += self.style.separatorLineSize.width;
            
        }
        
    }

    // 4.设置contentSize
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.titleLabels.lastObject.frame) + self.style.titleMargin * 0.5, 0);
    
    // 5.设置缩放
    if (self.style.isNeedScale) {
        self.titleLabels.firstObject.transform = CGAffineTransformMakeScale(self.style.maxScaleRang, self.style.maxScaleRang);
    }
    
    
}

- (void)setupFastenOrFloadTitlesLabel{
    
    NSInteger labelCount = self.style.fastenCount;
    for (int i = 0; i < labelCount; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.text = self.titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = i == 0 ? self.style.selectColor : self.style.normalColor;
        label.font = self.style.titleFont;
        if (self.style.multilineEnable) label.numberOfLines = 0;
//        label.backgroundColor = [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        
        [self.scrollView addSubview:label];
        
        [self.titleLabels addObject:label];
    }
    
    // 2.设置Label的frame
    CGFloat labelH = self.style.titleHeight;
    CGFloat labelW = self.scrollView.frame.size.width / labelCount;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titleLabels.count; i ++) {
    
        labelX = i * labelW;
        self.titleLabels[i].frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        // 是否有分割线
        if (self.style.isShowSeparatorLine && i > 0) {
            
            UILabel *leftLabel = self.titleLabels[i - 1];
            UILabel *rightLabel = self.titleLabels[i];
            
            /// 线的中心
            CGFloat lineCenterX = CGRectGetMinX(rightLabel.frame) - (CGRectGetMinX(rightLabel.frame) - CGRectGetMaxX(leftLabel.frame)) * 0.5;
            
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = self.style.separatorLineColor;
            line.frame = CGRectMake(0, (labelH - self.style.separatorLineSize.height) * 0.5, self.style.separatorLineSize.width, self.style.separatorLineSize.height);
            
            CGPoint lineCenter = line.center;
            lineCenter.x = lineCenterX;
            line.center = lineCenter;
            
            [self.scrollView addSubview:line];
            labelX += self.style.separatorLineSize.width;
            
        }
        
    }
    
    // 3.设置缩放
    if (self.style.isNeedScale) {
        self.titleLabels.firstObject.transform = CGAffineTransformMakeScale(self.style.maxScaleRang, self.style.maxScaleRang);
    }
    
    
}


#pragma mark - Public Method
/**
 给外界提供的方法
 
 @param targetIndex 选中下标
 */
- (void)setPageTitleViewCurrentIndex:(NSInteger)targetIndex{
    
    if (!(self.style.titleStyle == JXPageTitleStyleDefualt)){
       
        /// 1.通知代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:targetIndex:)]) {
            [self.delegate titleView:self targetIndex:targetIndex];
        }
        
        /// 2.bottomLine
        // 3->4 取消3的选中颜色，改变4为选中颜色（fload）
        if (currentIndex <= self.style.fastenCount-1 && targetIndex >= self.style.fastenCount) {
            
            // 让之前的label不选中，现在的选中
            UILabel *sourceLabel = self.titleLabels[currentIndex];
            sourceLabel.textColor = self.style.normalColor;
            
            // 缩放
            if (self.style.isNeedScale) {
                sourceLabel.transform = CGAffineTransformIdentity;
            }
            
            // 调整底部滑动条(width和x)
            if (self.style.isShowBottomLine) {
                CGRect frame = self.bottomLine.frame;
                frame.origin.x = CGRectGetMaxX(self.scrollView.frame);
                self.bottomLine.frame = frame;
            }
            
            // 改变当前
            currentIndex = targetIndex;
            
            return;
        }
        
        // 4->3 取消4的选中颜色，改变3为选中颜色（fload）
        if (currentIndex >= self.style.fastenCount && targetIndex <= self.style.fastenCount-1) {
            UILabel *targetLabel = self.titleLabels[targetIndex];
            targetLabel.textColor = self.style.selectColor;
            
            // 缩放
            if (self.style.isNeedScale) {
                targetLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang,self.style.maxScaleRang);
            }
            
            // 调整底部滑动条(width和x)
            if (self.style.isShowBottomLine) {
                CGFloat detaWidth = CGRectGetWidth(targetLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
                CGRect frame = self.bottomLine.frame;
                frame.origin.x = targetLabel.frame.origin.x + detaWidth*0.5;
                self.bottomLine.frame = frame;
            }
            
            return;
        }
        return;
    }
    
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    //0.判断是不是之前点击的label
    if (targetLabel.tag == currentIndex) {
        return;
    }
    
    // 1.调整targetLabel
    [self adjustLabel:targetLabel];
}


#pragma mark - Actions

- (void)flodAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:JXDidClickFlodNotiName object:nil];
}
- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    NSInteger targetIndex = tap.view.tag;
    
    if (!(self.style.titleStyle == JXPageTitleStyleDefualt)){
        
        
        // 3->4 取消3的选中颜色，改变4为选中颜色（fload）
        if (currentIndex <= self.style.fastenCount-1 && targetIndex >= self.style.fastenCount)
        {
            
            /// 1.通知代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:targetIndex:)]) {
                [self.delegate titleView:self targetIndex:targetIndex];
            }
            
            // 让之前的label不选中，现在的选中
            UILabel *sourceLabel = self.titleLabels[currentIndex];
            sourceLabel.textColor = self.style.normalColor;
            
            // 缩放
            if (self.style.isNeedScale) {
                sourceLabel.transform = CGAffineTransformIdentity;
            }
            
            // 调整底部滑动条(width和x)
            if (self.style.isShowBottomLine) {
                CGRect frame = self.bottomLine.frame;
                frame.origin.x = CGRectGetMaxX(self.scrollView.frame);
                self.bottomLine.frame = frame;
            }
            
            // 改变当前
            currentIndex = targetIndex;
            
            return;
        }
        // 4->3 取消4的选中颜色，改变3为选中颜色（fload）
        else if (currentIndex >= self.style.fastenCount && targetIndex <= self.style.fastenCount-1)
        {
            
            /// 1.通知代理
            if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:targetIndex:)]) {
                [self.delegate titleView:self targetIndex:targetIndex];
            }
            
            UILabel *targetLabel = self.titleLabels[targetIndex];
            targetLabel.textColor = self.style.selectColor;
            
            // 缩放
            if (self.style.isNeedScale) {
                targetLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang,self.style.maxScaleRang);
            }
            
            // 调整底部滑动条(width和x)
            if (self.style.isShowBottomLine) {
                CGFloat detaWidth = CGRectGetWidth(targetLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
                CGRect frame = self.bottomLine.frame;
                frame.origin.x = targetLabel.frame.origin.x + detaWidth*0.5;
                self.bottomLine.frame = frame;
            }
            
            // 改变当前
            currentIndex = targetIndex;
            return;
        }
        else{
            UIView *view = tap.view;
            if (![view isKindOfClass:[UILabel class]]) {
                return;
            }
            
            UILabel *targetLabel = (UILabel *)tap.view;
            // 0.判断是不是之前点击的label
            if (targetLabel.tag == currentIndex) {
                return;
            }
            
            // 1.调整targetLabel
            [self adjustLabel:targetLabel];
        }
        return;
    }
    
    UIView *view = tap.view;
    if (![view isKindOfClass:[UILabel class]]) {
        return;
    }
    
    UILabel *targetLabel = (UILabel *)tap.view;
    // 0.判断是不是之前点击的label
    if (targetLabel.tag == currentIndex) {
        return;
    }
    
    // 1.调整targetLabel
    [self adjustLabel:targetLabel];
    
}


/**
 调整目标Label
 */
- (void)adjustLabel:(UILabel *)targetLabel{
    
    // 1.让之前的label不选中，现在的选中
    UILabel *sourceLabel = self.titleLabels[currentIndex];
    targetLabel.textColor = self.style.selectColor;
    sourceLabel.textColor = self.style.normalColor;
    currentIndex = targetLabel.tag;
    
    
    /// 是否可以滚动
    UILabel *lastLabel = self.titleLabels.lastObject;
    if (self.style.titleStyle == JXPageTitleStyleDefualt && CGRectGetMaxX(lastLabel.frame) + self.style.titleMargin * 0.5 > CGRectGetWidth(self.frame)) {
        // 2.调整点击label的位置
        [self adjustLabelPosition];
    }
    
    
    // 3.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:targetIndex:)]) {
        
        [self.delegate titleView:self targetIndex:currentIndex];
    }
    
    // 4.调整文字缩放
    if (self.style.isNeedScale) {
        [UIView animateWithDuration:0.25 animations:^{
            
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang, self.style.maxScaleRang);
        }];
    }
    
    // 5.调整bottomLine的位置
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.bottomLine.frame;
            if (self.style.titleStyle == JXPageTitleStyleDefualt) {
                frame.origin.x = targetLabel.frame.origin.x;
                frame.size.width = targetLabel.frame.size.width;
            }else{
                CGFloat lineX = targetLabel.frame.origin.x + (targetLabel.frame.size.width-frame.size.width)*0.5;
                frame.origin.x = lineX;
            }
            self.bottomLine.frame = frame;
        }];
    }
}

/**
 调整点击label的位置
 */
- (void)adjustLabelPosition{
    UILabel *targetLabel = self.titleLabels[currentIndex];
    CGFloat offsetX = targetLabel.center.x - self.scrollView.bounds.size.width * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.bounds.size.width;
    
    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}


#pragma mark - JXPageContentViewDelegate
- (void)pageContentView:(JXPageContentView *)pageContentView didEndScroll:(int)inIndex{
    currentIndex = inIndex;
    
    /// 是否可以滚动
    UILabel *lastLabel = self.titleLabels.lastObject;
    if (self.style.titleStyle == JXPageTitleStyleDefualt && CGRectGetMaxX(lastLabel.frame) + self.style.titleMargin * 0.5 > CGRectGetWidth(self.frame)) {
        ///调整点击label的位置
        [self adjustLabelPosition];
    }
}

- (void)pageContentView:(JXPageContentView *)pageContentView sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress{
    
    /// 固定个数
    if (!(self.style.titleStyle == JXPageTitleStyleDefualt)) {
        [self _fastenSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
        return;
    }
    
    ///////// ------------------- 默认 ---------------------------------
    
    // 1
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    // 2.颜色渐变
    if (self.style.titleGradientEffectEnable) { // 需要颜色渐变
        
        sourceLabel.textColor = [UIColor colorWithR:self.selectRGB[0].floatValue - self.deltaRGB[0].floatValue * progress g:self.selectRGB[1].floatValue - self.deltaRGB[1].floatValue * progress b:self.selectRGB[2].floatValue - self.deltaRGB[2].floatValue * progress a:1];
        
        targetLabel.textColor = [UIColor colorWithR:self.nomalRGB[0].floatValue + self.deltaRGB[0].floatValue * progress g:self.nomalRGB[1].floatValue + self.deltaRGB[1].floatValue * progress b:self.nomalRGB[2].floatValue + self.deltaRGB[2].floatValue * progress a:1];
    }
    else{ // 不需要颜色渐变
        
        if (progress > 0.5) {
            sourceLabel.textColor = self.style.normalColor;
            targetLabel.textColor = self.style.selectColor;
        }else{
            sourceLabel.textColor = self.style.selectColor;
            targetLabel.textColor = self.style.normalColor;
        }
    }
    
    

    
    // 3.缩放变化
    if (self.style.isNeedScale) {
        CGFloat detaScale = self.style.maxScaleRang - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang - detaScale * progress, self.style.maxScaleRang - detaScale * progress);
        targetLabel.transform = CGAffineTransformMakeScale(1 + detaScale * progress, 1 + detaScale * progress);
    }
    
    // 4.调整底部滑动条(width和x)
    if (self.style.isShowBottomLine) {
        if (self.style.titleStyle == JXPageTitleStyleDefualt) {
            CGFloat detaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
            CGFloat detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
            CGRect frame = self.bottomLine.frame;
            frame.size.width =  sourceLabel.frame.size.width + detaWidth * progress;
            frame.origin.x = sourceLabel.frame.origin.x + detaX * progress;
            self.bottomLine.frame = frame;
        
        }else{
            CGFloat detaWidth = CGRectGetWidth(targetLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
            CGFloat detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = sourceLabel.frame.origin.x + detaX * progress + detaWidth *0.5;
            self.bottomLine.frame = frame;
        }
    }
    
}

- (void)_fastenSourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex progress:(CGFloat)progress{
    
    /// 左滑刚好一个屏幕
    if (targetIndex == sourceIndex) {
        return;
    }
    
    // 3->4 取消3的选中颜色，改变4为选中颜色（fload）
    if (sourceIndex == self.style.fastenCount-1 && targetIndex == self.style.fastenCount)
    {
        
        // sourceLabel
        UILabel *sourceLabel = self.titleLabels[sourceIndex];
        sourceLabel.textColor = [UIColor colorWithR:self.selectRGB[0].floatValue - self.deltaRGB[0].floatValue * progress g:self.selectRGB[1].floatValue - self.deltaRGB[1].floatValue * progress b:self.selectRGB[2].floatValue - self.deltaRGB[2].floatValue * progress a:1];
        
        // 缩放
        if (self.style.isNeedScale) {
            CGFloat detaScale = self.style.maxScaleRang - 1.0;
            sourceLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang - detaScale * progress, self.style.maxScaleRang - detaScale * progress);
        }
        
        // 调整底部滑动条(width和x)
        if (self.style.isShowBottomLine) {
            CGFloat detaWidth = CGRectGetWidth(sourceLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
            CGFloat detaX = CGRectGetMaxX(self.scrollView.frame) - sourceLabel.frame.origin.x;
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = CGRectGetMaxX(self.scrollView.frame) + detaX * progress + detaWidth *0.5;
            self.bottomLine.frame = frame;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:JXDidSelectFlodIndexNotiName object:@(targetIndex)];
        
        return;
    }
    
    // 4->3 取消4的选中颜色，改变3为选中颜色（fload）
    if (sourceIndex == self.style.fastenCount && targetIndex == self.style.fastenCount-1) {
        UILabel *targetLabel = self.titleLabels[targetIndex];
        targetLabel.textColor = [UIColor colorWithR:self.nomalRGB[0].floatValue + self.deltaRGB[0].floatValue * progress g:self.nomalRGB[1].floatValue + self.deltaRGB[1].floatValue * progress b:self.nomalRGB[2].floatValue + self.deltaRGB[2].floatValue * progress a:1];
        // 缩放
        if (self.style.isNeedScale) {
            CGFloat detaScale = self.style.maxScaleRang - 1.0;
            targetLabel.transform = CGAffineTransformMakeScale(1 + detaScale * progress, 1 + detaScale * progress);
        }
        
        // 调整底部滑动条(width和x)
        if (self.style.isShowBottomLine) {
            CGFloat detaWidth = CGRectGetWidth(targetLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
            CGFloat detaX = targetLabel.frame.origin.x - CGRectGetMaxX(self.scrollView.frame);// 负数
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = CGRectGetMaxX(self.scrollView.frame) + detaX*progress + detaWidth*0.5;
            self.bottomLine.frame = frame;
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:JXDidSelectFlodIndexNotiName object:@(targetIndex)];
        return;
    }
    
    
    if (sourceIndex >= self.style.fastenCount || targetIndex >= self.style.fastenCount) {
        [[NSNotificationCenter defaultCenter]postNotificationName:JXDidSelectFlodIndexNotiName object:@(targetIndex)];
        return;
    }
    
    
    // 1
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    // 2.颜色渐变
    if (self.style.titleGradientEffectEnable) { // 需要颜色渐变
        
        sourceLabel.textColor = [UIColor colorWithR:self.selectRGB[0].floatValue - self.deltaRGB[0].floatValue * progress g:self.selectRGB[1].floatValue - self.deltaRGB[1].floatValue * progress b:self.selectRGB[2].floatValue - self.deltaRGB[2].floatValue * progress a:1];
        
        targetLabel.textColor = [UIColor colorWithR:self.nomalRGB[0].floatValue + self.deltaRGB[0].floatValue * progress g:self.nomalRGB[1].floatValue + self.deltaRGB[1].floatValue * progress b:self.nomalRGB[2].floatValue + self.deltaRGB[2].floatValue * progress a:1];
    }
    else{ // 不需要颜色渐变
        
        if (progress > 0.5) {
            sourceLabel.textColor = self.style.normalColor;
            targetLabel.textColor = self.style.selectColor;
        }else{
            sourceLabel.textColor = self.style.selectColor;
            targetLabel.textColor = self.style.normalColor;
        }
    }
    
    
    
    
    // 3.缩放变化
    if (self.style.isNeedScale) {
        CGFloat detaScale = self.style.maxScaleRang - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang - detaScale * progress, self.style.maxScaleRang - detaScale * progress);
        targetLabel.transform = CGAffineTransformMakeScale(1 + detaScale * progress, 1 + detaScale * progress);
    }
    
    // 4.调整底部滑动条(width和x)
    if (self.style.isShowBottomLine) {
        if (self.style.titleStyle == JXPageTitleStyleDefualt) {
            CGFloat detaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
            CGFloat detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
            CGRect frame = self.bottomLine.frame;
            frame.size.width =  sourceLabel.frame.size.width + detaWidth * progress;
            frame.origin.x = sourceLabel.frame.origin.x + detaX * progress;
            self.bottomLine.frame = frame;
            
        }else{
            CGFloat detaWidth = CGRectGetWidth(targetLabel.frame) - CGRectGetWidth(self.bottomLine.frame);
            CGFloat detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
            CGRect frame = self.bottomLine.frame;
            frame.origin.x = sourceLabel.frame.origin.x + detaX * progress + detaWidth *0.5;
            self.bottomLine.frame = frame;
        }
    }
}



@end
