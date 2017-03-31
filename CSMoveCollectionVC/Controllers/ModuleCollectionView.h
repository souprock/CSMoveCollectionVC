//
//  ModuleCollectionView.h
//  TableCollectionView
//
//  Created by iOS_Chris on 16/7/4.
//  Copyright © 2016年 kyExpress. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ModuleCollectionView;
@protocol RTDragCellcollectionViewDataSource <UICollectionViewDataSource>

@required
/**将外部数据源数组传入，以便在移动cell数据发生改变时进行修改重排*/
- (NSArray *)originalArrayDataForcollectionView:(ModuleCollectionView *)collectionView;

@end

@protocol RTDragCellcollectionViewDelegate <UICollectionViewDelegate>

@required
/**将修改重排后的数组传入，以便外部更新数据源*/
- (void)collectionView:(ModuleCollectionView *)collectionView newArrayDataForDataSource:(NSArray *)newArray;
@optional
/**选中的cell准备好可以移动的时候*/
- (void)collectionView:(ModuleCollectionView *)collectionView cellReadyToMoveAtIndexPath:(NSIndexPath *)indexPath;
/**选中的cell正在移动，变换位置，手势尚未松开*/
- (void)cellIsMovingIncollectionView:(ModuleCollectionView *)collectionView;
/**选中的cell完成移动，手势已松开*/
- (void)cellDidEndMovingIncollectionView:(ModuleCollectionView *)collectionView;

@end


@interface ModuleCollectionView : UICollectionView

@property (nonatomic, assign) id<RTDragCellcollectionViewDataSource> adataSource;
@property (nonatomic, assign) id<RTDragCellcollectionViewDelegate> adelegate;
@property (nonatomic, assign) int availNum;
@end
