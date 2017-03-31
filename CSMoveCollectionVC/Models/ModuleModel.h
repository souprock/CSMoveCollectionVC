//
//  ModuleModel.h
//  kyExpress_Internal
//
//  Created by iOS_Chris on 16/6/23.
//  Copyright © 2016年 kyExpress. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - 新模块编号
#define newModuleAllowedAll   @"111"
#define newModuleBlank   @"000"
#define newModuleUnderConstruct   @"001"
#define newModuleSpecial   @"002"

#define newModuleExpress         @"1"
#define newModuleAddStage        @"2"
#define newModuleMakeOrder       @"3"
#define newModuleContact         @"4"
#define newModuleTimeQuery       @"5"
#define newModuleRecharge        @"6"
#define newModuleAssets          @"7"
#define newModuleFlightQuery     @"8"
#define newModuleDriverIntroduce @"9"
#define newModuleCarCard         @"10"
#define newModuleCarCheck        @"11"
#define newModuleCustomInfoQuery @"12"
#define newModuleComplaints      @"13"
#define newModuleAssetTransfe    @"14"
#define newModuleBaGun    @"15"
#define newModuleCEOHotLine    @""

typedef void(^DidClickModuleBlock)(void);

@interface ModuleModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *iconName;
@property (nonatomic,copy) NSString *moduleNum;
@property (nonatomic,assign) short width;
@property (nonatomic,assign) short height;

@property (nonatomic,assign) int order;
@property (nonatomic,copy) DidClickModuleBlock didClickModuleBlock;

- (instancetype)initWithTitle:(NSString * )title iconName:(NSString * )iconName moduleNum:(NSString * )moduleNum modulewith:(short)width moduleheight:(short)height;
-(void)setDidClickModuleBlock:(DidClickModuleBlock)didClickModuleBlock;


@end
