//
//  HomeCollectionViewCell.h
//  King
//
//  Created by 陈志刚 on 15/12/4.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

+ (UINib *)nib;
- (void)refreshUIWithImageName:(NSString *)imageName title:(NSString *)title;

@end
