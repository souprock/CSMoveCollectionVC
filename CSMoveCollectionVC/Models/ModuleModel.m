//
//  ModuleModel.m
//  kyExpress_Internal
//
//  Created by iOS_Chris on 16/6/23.
//  Copyright © 2016年 kyExpress. All rights reserved.
//

#import "ModuleModel.h"

@implementation ModuleModel
- (instancetype)initWithTitle:(NSString *)title iconName:(NSString *)iconName moduleNum:(NSString *)moduleNum modulewith:(short)width moduleheight:(short)height{
    self = [super init];
    self.title = title;
    self.iconName = iconName;
    self.moduleNum = moduleNum;
    self.width = width;
    self.height = height;
    return self;
}

-(void)setDidClickModuleBlock:(DidClickModuleBlock)didClickModuleBlock
{
    _didClickModuleBlock = didClickModuleBlock;
}



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"] ;
    [aCoder encodeObject:self.iconName forKey:@"iconName"];
    [aCoder encodeObject:self.moduleNum forKey:@"moduleNum"];
//    [aCoder encodeObject:self.didClickModuleBlock forKey:@"didClickModuleBlock"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init] ;
    if(self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"] ;
        self.iconName = [aDecoder decodeObjectForKey:@"iconName"] ;
        self.moduleNum = [aDecoder decodeObjectForKey:@"moduleNum"] ;
//        self.didClickModuleBlock = [aDecoder decodeObjectForKey:@"didClickModuleBlock"];
    }
    return self ;
}
@end
