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

@interface JXTitleView ()<JXPageContentViewDelegate>{
    NSInteger currentIndex;
    
}
@property(nonatomic, strong) NSArray <NSNumber *> * nomalRGB;
@property(nonatomic, strong) NSArray <NSNumber *> * selectRGB;
@property(nonatomic, strong) NSArray <NSNumber *> * deltaRGB;

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView *bottomLine;
@property(nonatomic, strong) NSMutableArray <UILabel *>*titleLabels;
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
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
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
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(JXPageStyle *)style{
    
    self.titles = titles;
    self.style = style;
    return [self initWithFrame:frame];
}

#pragma mark - UI
- (void)setupUI{
    currentIndex = 0;
    
    // 1.添加ScrollView
    [self addSubview:self.scrollView];
    
    // 2.添加Lable
    [self setupTitlesLabel];
    
    // 3.初始化底部line
    if (self.style.isShowBottomLine) {
        [self setupBottomLine];
    }
    
}

- (void)setupBottomLine{
    [self.scrollView addSubview:self.bottomLine];
    CGRect frame = self.titleLabels.firstObject.frame;
    frame.size.height = self.style.bottomLineHeight;
    frame.origin.y = self.style.titleHeight - self.style.bottomLineHeight;
    self.bottomLine.frame = frame;
}


- (void)setupTitlesLabel{
    
    for (int i = 0; i < self.titles.count; i ++) {
        UILabel *label = [[UILabel alloc]init];
        label.tag = i;
        label.userInteractionEnabled = YES;
        label.text = self.titles[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = i == 0 ? self.style.selectColor : self.style.normalColor;
        label.font = self.style.titleFont;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        
        [self.scrollView addSubview:label];
        
        [self.titleLabels addObject:label];
    }
    
    // 2.设置Label的frame
    CGFloat labelH = self.style.titleHeight;
    CGFloat labelW = self.bounds.size.width / self.titles.count;
    CGFloat labelX = 0;
    CGFloat labelY = 0;
    
    for (int i = 0; i < self.titleLabels.count; i ++) {
        
        if (self.style.isScrollEnable) { // 可以滚动
            
            CGSize size = CGSizeMake(MAXFLOAT, 0);
            
            labelW = [self.titleLabels[i].text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.style.titleFont} context:nil].size.width;
            labelX = i == 0 ? self.style.titleMargin * 0.5 : CGRectGetMaxX(self.titleLabels[i - 1].frame) + self.style.titleMargin;
            
        }else{
            labelX = labelW * i;
        }
        
        self.titleLabels[i].frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        
    }
    
    
    
    // 4.设置contentSize
    if (self.style.isScrollEnable) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.titleLabels.lastObject.frame) + self.style.titleMargin * 0.5, 0);
    }
    
    // 5.设置缩放
    if (self.style.isNeedScale) {
        self.titleLabels.firstObject.transform = CGAffineTransformMakeScale(self.style.maxScaleRang, self.style.maxScaleRang);
    }
    
    
}


#pragma mark - tapAction
- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    
    UIView *view = tap.view;
    if (![view isKindOfClass:[UILabel class]]) {
        return;
    }
    
    UILabel *targetLabel = (UILabel *)tap.view;
    
    //0.判断是不是之前点击的label
    if (targetLabel.tag == currentIndex) {
        return;
    }
    

    // 1.让之前的label不选中，现在的选中
    
    UILabel *sourceLabel = self.titleLabels[currentIndex];
    targetLabel.textColor = self.style.selectColor;
    sourceLabel.textColor = self.style.normalColor;
    currentIndex = targetLabel.tag;

    
    if (self.style.isScrollEnable) {
        // 2.调整点击label的位置
        [self adjustLabelPosition];
    }
    
    
    // 3.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:targetIndex:)]) {
        
        [self.delegate titleView:self targetIndex:currentIndex];
    }
    
    // 4.调整bottomLine的位置
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.bottomLine.frame;
            
            frame.origin.x = targetLabel.frame.origin.x;
            frame.size.width = targetLabel.frame.size.width;
            
            self.bottomLine.frame = frame;
        }];
    }
    
    // 5.调整文字缩放
    if (self.style.isNeedScale) {
        [UIView animateWithDuration:0.25 animations:^{
            
            sourceLabel.transform = CGAffineTransformIdentity;
            targetLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang, self.style.maxScaleRang);
        }];
    }
    
}

// 调整点击label的位置
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
    
    if (self.style.isScrollEnable) {
        ///调整点击label的位置
        [self adjustLabelPosition];
    }
    
    
}

- (void)pageContentView:(JXPageContentView *)pageContentView sourceIndex:(int)sourceIndex targetIndex:(int)targetIndex progress:(CGFloat)progress{
    
    // 1
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    // 2.颜色渐变
    sourceLabel.textColor = [UIColor colorWithR:self.selectRGB[0].floatValue - self.deltaRGB[0].floatValue * progress g:self.selectRGB[1].floatValue - self.deltaRGB[1].floatValue * progress b:self.selectRGB[2].floatValue - self.deltaRGB[2].floatValue * progress a:1];
    
    targetLabel.textColor = [UIColor colorWithR:self.nomalRGB[0].floatValue + self.deltaRGB[0].floatValue * progress g:self.nomalRGB[1].floatValue + self.deltaRGB[1].floatValue * progress b:self.nomalRGB[2].floatValue + self.deltaRGB[2].floatValue * progress a:1];
    NSLog(@"progress == %f",progress);
    
    
    // 3.调整底部滑动条(width和x)
    if (self.style.isShowBottomLine) {
        CGFloat detaWidth = targetLabel.frame.size.width - sourceLabel.frame.size.width;
        CGFloat detaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
        CGRect frame = self.bottomLine.frame;
        frame.size.width =  sourceLabel.frame.size.width + detaWidth * progress;
        frame.origin.x = sourceLabel.frame.origin.x + detaX * progress;
        self.bottomLine.frame = frame;
    }
    
    // 4.缩放变化
    if (self.style.isNeedScale) {
        CGFloat detaScale = self.style.maxScaleRang - 1.0;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.maxScaleRang - detaScale * progress, self.style.maxScaleRang - detaScale * progress);
        targetLabel.transform = CGAffineTransformMakeScale(1 + detaScale * progress, 1 + detaScale * progress);
    }
    
}





@end
