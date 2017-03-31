//
//  ModuleCollectionView.m
//  TableCollectionView
//
//  Created by iOS_Chris on 16/7/4.
//  Copyright © 2016年 kyExpress. All rights reserved.
//

#import "ModuleCollectionView.h"
#import "ModuleModel.h"

typedef enum{
    RTSnapshotMeetsEdgeTop,
    RTSnapshotMeetsEdgeBottom,
}RTSnapshotMeetsEdge;

@interface ModuleCollectionView ()

/**记录手指所在的位置*/
@property (nonatomic, assign) CGPoint fingerLocation;
/**被选中的cell的新位置*/
@property (nonatomic, strong) NSIndexPath *relocatedIndexPath;
/**被选中的cell的原始位置*/
@property (nonatomic, strong) NSIndexPath *originalIndexPath;
/**对被选中的cell的截图*/
@property (nonatomic, weak) UIView *snapshot;
/**自动滚动的方向*/
@property (nonatomic, assign) RTSnapshotMeetsEdge autoScrollDirection;
/**cell被拖动到边缘后开启，collectionView自动向上或向下滚动*/
@property (nonatomic, strong) CADisplayLink *autoScrollTimer;

@end


@implementation ModuleCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout] ;
    if(self)
    {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:longPress];
    }
    return self ;
}

# pragma mark - Gesture methods

- (void)longPressGestureRecognized:(id)sender{
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState longPressState = longPress.state;
    //手指在collectionView中的位置
    _fingerLocation = [longPress locationInView:self];
    //手指按住位置对应的indexPath，可能为nil
    _relocatedIndexPath = [self indexPathForItemAtPoint:_fingerLocation];
    
    if (_relocatedIndexPath.row > self.availNum ) return;  //空白模块不可移动
    
    switch (longPressState) {
        case UIGestureRecognizerStateBegan:{
            
            //手势开始，对被选中cell截图，隐藏原cell
            _originalIndexPath = [self indexPathForItemAtPoint:_fingerLocation];
            if (_originalIndexPath) {
                [self cellSelectedAtIndexPath:_originalIndexPath];
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{//点击位置移动，判断手指按住位置是否进入其它indexPath范围，若进入则更新数据源并移动cell
            
            //截图跟随手指移动
            CGPoint center = _snapshot.center;
            center.y = _fingerLocation.y;
            center.x = _fingerLocation.x ;
            _snapshot.center = center;
            
            NSLog(@"_relocatedIndexPath:%d,availNum:%d",_relocatedIndexPath.row,self.availNum);
            if (_relocatedIndexPath.row < self.availNum ) {
                
                //                NSLog(@"_relocatedIndexPath:%d,availNum:%d",_relocatedIndexPath.row,self.availNum);
                
                //如果到了整个collectionView以外，就滚回原处
                if ([self checkIfSnapshotMeetsEdge]) {
                    [self startAutoScrollTimer];
                }else{
                    [self stopAutoScrollTimer];
                }
                
                //手指按住位置对应的indexPath，可能为nil
                
                if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
                    
                    [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
                    NSLog(@"拖拽过程中：移动位置到 -- %ld",(long)_relocatedIndexPath.row);
                    
                }
            }
            break;
        }
        default: {                             //长按手势结束或被取消，移除截图，显示cell
            [self stopAutoScrollTimer];
            [self didEndDraging];
            if ([self.adelegate respondsToSelector:@selector(cellDidEndMovingIncollectionView:)]) {
                [self.adelegate cellDidEndMovingIncollectionView:self];
            }
            break;
        }
    }
}


/**
 *  cell被长按手指选中，对其进行截图，原cell隐藏
 */
- (void)cellSelectedAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath] ;
    
    UIView *snapshot = [self customSnapshotFromView:cell];
    
    [self addSubview:snapshot];
    
    _snapshot = snapshot;
    cell.hidden = YES;
    CGPoint center = _snapshot.center;
    center.y = _fingerLocation.y;
    [UIView animateWithDuration:0.2 animations:^{
        _snapshot.transform = CGAffineTransformMakeScale(1.03, 1.03);
        _snapshot.alpha = 0.98;
        _snapshot.center = center;
    }];
}

#pragma mark - 返回一个给定view的截图.
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.center = inputView.center;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

#pragma mark -  检查截图是否到达整个collectionView的边缘，并作出响应

- (BOOL)checkIfSnapshotMeetsEdge{
    CGFloat minY = CGRectGetMinY(_snapshot.frame);
    CGFloat maxY = CGRectGetMaxY(_snapshot.frame);
    if (minY < self.contentOffset.y) {
        _autoScrollDirection = RTSnapshotMeetsEdgeTop;
        return YES;
    }
    if (maxY > self.bounds.size.height + self.contentOffset.y) {
        _autoScrollDirection = RTSnapshotMeetsEdgeBottom;
        return YES;
    }
    return NO;
}

#pragma mark - timer methods
/**
 *  创建定时器并运行
 */
- (void)startAutoScrollTimer{
    if (!_autoScrollTimer) {
        _autoScrollTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAutoScroll)];
        [_autoScrollTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}
/**
 *  停止定时器并销毁
 */
- (void)stopAutoScrollTimer{
    if (_autoScrollTimer) {
        [_autoScrollTimer invalidate];
        _autoScrollTimer = nil;
    }
}

#pragma mark - 开始自动滚动

- (void)startAutoScroll{
    CGFloat pixelSpeed = 4;
    if (_autoScrollDirection == RTSnapshotMeetsEdgeTop) {//向下滚动
        if (self.contentOffset.y > 0) {//向下滚动最大范围限制
            [self setContentOffset:CGPointMake(0, self.contentOffset.y - pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y - pixelSpeed);
        }
    }else{                                               //向上滚动
        if (self.contentOffset.y + self.bounds.size.height < self.contentSize.height) {//向下滚动最大范围限制
            [self setContentOffset:CGPointMake(0, self.contentOffset.y + pixelSpeed)];
            _snapshot.center = CGPointMake(_snapshot.center.x, _snapshot.center.y + pixelSpeed);
        }
    }
    
    /*  当把截图拖动到边缘，开始自动滚动，如果这时手指完全不动，则不会触发‘UIGestureRecognizerStateChanged’，对应的代码就不会执行，导致虽然截图在collectionView中的位置变了，但并没有移动那个隐藏的cell，用下面代码可解决此问题，cell会随着截图的移动而移动
     */
    
    _relocatedIndexPath = [self indexPathForItemAtPoint:_snapshot.center] ;
    if (_relocatedIndexPath && ![_relocatedIndexPath isEqual:_originalIndexPath]) {
        [self cellRelocatedToNewIndexPath:_relocatedIndexPath];
    }
}

#pragma mark - 移动时更新位置数据
/**
 *  截图被移动到新的indexPath范围，这时先更新数据源，重排数组，再将cell移至新位置
 *  @param indexPath 新的indexPath
 */
- (void)cellRelocatedToNewIndexPath:(NSIndexPath *)indexPath{
    //更新数据源并返回给外部
    [self updateDataSource];
    //交换移动cell位置
    
    [self moveItemAtIndexPath:_originalIndexPath toIndexPath:indexPath];
    //更新cell的原始indexPath为当前indexPath
    _originalIndexPath = indexPath;
    
}

# pragma mark - Private methods
/**修改数据源，通知外部更新数据源*/
- (void)updateDataSource{
    
    //通过DataSource代理获得原始数据源数组
    NSMutableArray *tempArray = [NSMutableArray array];
    if ([self.adataSource respondsToSelector:@selector(originalArrayDataForcollectionView:)]) {
        [tempArray addObjectsFromArray:[self.adataSource originalArrayDataForcollectionView:self]];
    }
    
    //移动数据
    [self moveObjectInMutableArray:tempArray fromIndex:_originalIndexPath.row toIndex:_relocatedIndexPath.row];
    
    //    将新数组传出外部以更改数据源
    if ([self.adelegate respondsToSelector:@selector(collectionView:newArrayDataForDataSource:)]) {
        [self.adelegate collectionView:self newArrayDataForDataSource:tempArray];
    }
}

/**
 *  将可变数组中的一个对象移动到该数组中的另外一个位置
 *  @param array     要变动的数组
 *  @param fromIndex 从这个index
 *  @param toIndex   移至这个index
 */
- (void)moveObjectInMutableArray:(NSMutableArray *)array fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex{
    
    NSInteger tempIndex = 0;
    NSMutableString *tempTitle = nil;
    
    if (fromIndex < toIndex) {
        for (NSInteger i = fromIndex; i < toIndex; i ++) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i + 1];
        }
    }else{
        for (NSInteger i = fromIndex; i > toIndex; i --) {
            [array exchangeObjectAtIndex:i withObjectAtIndex:i - 1];
        }
    }
}


/**
 *  拖拽结束，显示cell，并移除截图
 */
- (void)didEndDraging{
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:_originalIndexPath] ;
    cell.hidden = NO;
    cell.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        _snapshot.center = cell.center;
        _snapshot.alpha = 0;
        _snapshot.transform = CGAffineTransformIdentity;
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [_snapshot removeFromSuperview];
        _snapshot = nil;
        _originalIndexPath = nil;
        _relocatedIndexPath = nil;
    }];
}
@end
