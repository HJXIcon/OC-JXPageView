//
//  JXPageContentView.m
//  JXShopDetailDemo
//
//  Created by mac on 17/8/3.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "JXPageContentView.h"
#import "JXTitleView.h"

@interface JXPageContentView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    CGFloat startOffsetX;
    BOOL isForbidDelegate; //禁止代理，默认是禁止
    
}

@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JXPageContentView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame childVcs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc{
    self.childVcs = childVcs;
    self.parentVc = parentVc;
    return [self initWithFrame:frame];
}


#pragma mark - lazy load
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.scrollsToTop = NO;
        
        
    }
    return _collectionView;
}


#pragma mark - 
- (void)setup{
    startOffsetX = 0;
    isForbidDelegate = NO;
    
}

- (void)setupUI{
    // 1.childVcs添加到parentVc
    for (UIViewController *vc  in self.childVcs) {
        [self.parentVc addChildViewController:vc];
        
    }
    
    // 2.添加collectionView
    [self addSubview:self.collectionView];
}

/// 停止滚动
- (void)scrollViewDidEndScroll{
    int index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentView:didEndScroll:)]) {
        [self.delegate pageContentView:self didEndScroll:index];
    }
}

///



#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.childVcs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    // 1.先删除之前的view
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    // 2.添加view
    UIViewController *vc = self.childVcs[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    [cell.contentView addSubview:vc.view];
    
    
    return cell;
}


#pragma mark - <UICollectionViewDelegate>
/// 减速过程
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScroll];
}


/// 没有减速过程
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self scrollViewDidEndScroll];
    }
}

/// 开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 设置
    isForbidDelegate = NO;
    startOffsetX = scrollView.contentOffset.x;
}


/// 拖动的时候调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    // 0.判断有没有滑动
    if (contentOffsetX == startOffsetX || isForbidDelegate) {
        return;
    }
    
    int sourceIndex = 0;
    int targetIndex = 0;
    CGFloat progress = 0;
    
     // 1.获取参数
    CGFloat collectionWidth = self.collectionView.bounds.size.width;
    if (contentOffsetX > startOffsetX) { // 左滑
        sourceIndex = contentOffsetX / collectionWidth;
        targetIndex = sourceIndex + 1;
        
        // 越界
        if (targetIndex >= self.childVcs.count) {
            targetIndex = (int)self.childVcs.count - 1;
        }
        
        progress = (contentOffsetX - startOffsetX) / collectionWidth;
        
        /// 刚好一个屏幕的时候(什么时候停止)
        if ((contentOffsetX - startOffsetX) == collectionWidth) {
            targetIndex = sourceIndex;
        }
        
        
    }else{ // 右滑
        
        targetIndex = contentOffsetX / collectionWidth;
        sourceIndex = targetIndex + 1;
        progress = (startOffsetX - contentOffsetX) / collectionWidth;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentView:sourceIndex:targetIndex:progress:)]) {
        [self.delegate pageContentView:self sourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
    }
    
    
}

/// collectionView停止滚动
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    int index = self.collectionView.contentOffset.x / self.collectionView.bounds.size.width;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageContentView:didEndScroll:)]) {
        
        [self.delegate pageContentView:self didEndScroll:index];
    }
}



#pragma mark - JXTitleViewDelegate
- (void)titleView:(JXTitleView *)titleView targetIndex:(NSInteger)targetIndex{
    // 0.禁止执行代理方法 (bug：点击title滚动contentView，滚动contentView又调整titleLabel的位置，重复了)
    isForbidDelegate = YES;
    
    // 1.创建indexPath
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:targetIndex inSection:0];
    
    // 2.滚动到正确的位置
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
}


@end
