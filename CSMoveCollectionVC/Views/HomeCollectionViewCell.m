//
//  HomeCollectionViewCell.m
//  King
//
//  Created by 陈志刚 on 15/12/4.
//  Copyright © 2015年 c521xiong. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()



@end

@implementation HomeCollectionViewCell

+ (UINib *)nib{
    return [UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil];
}

- (void)awakeFromNib {
    
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
   
    return self;
    
}

- (void)refreshUIWithImageName:(NSString *)imageName title:(NSString *)title{
    
//    [self.imageView setImage:IMAGE(imageName)];
    self.backgroundColor = [UIColor whiteColor];
    [self.label1 setText:title];
    self.label1.textColor = [UIColor blackColor];
    self.label1.font = [UIFont systemFontOfSize:14];
}



@end
