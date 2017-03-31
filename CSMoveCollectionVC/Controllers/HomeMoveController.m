//
//  HomeMoveController.m
//  TableCollectionView
//
//  Created by iOS_Chris on 16/7/4.
//  Copyright © 2016年 kyExpress. All rights reserved.
//

#import "HomeMoveController.h"
#import "ModuleCollectionView.h"
#import "ModuleModel.h"
#import "HomeCollectionViewCell.h"
#import "WaterfallColectionLayout.h"


#define kSCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)//应用尺寸

#define keyHomeModeularCell @"modeularCellHome"
#define availCount 7
#define keyOrderArray @"keyOrderArray"

@interface HomeMoveController()<UICollectionViewDelegate,UICollectionViewDataSource,RTDragCellcollectionViewDataSource,RTDragCellcollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) ModuleCollectionView *collectionView ;
@property (nonatomic, copy) NSMutableArray *modulesArray;
@property (nonatomic, copy) NSMutableArray *orderedModuleArray;
@property(nonatomic,strong)UICollectionViewLayout* layout;
@end


static NSString *collectionCellID = @"collectionCellID_home";

@implementation HomeMoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"CollectionView选择性移动";
    
    [self addCollectionView];
    
    // 初始化数据方法
    [self setHomeModule];
    
}



//根据是否外请、内部员工，判断首页显示什么
- (void)setHomeModule{
    
    // 查询缓存
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults] ;
    
    NSLog(@"modulesArray - %@,%@",[self.modulesArray class],self.modulesArray);
    
    [userDefault removeObjectForKey:keyHomeModeularCell];
    
    NSMutableArray *storeArray = [userDefault objectForKey:keyHomeModeularCell];
    
    self.modulesArray = nil;
    
    if(storeArray)
    {
        //取数据
        int availNum = 0;
        for (NSData *data in storeArray) {
            ModuleModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data] ;
            [self.modulesArray addObject:model];
            if (model.title) {
                availNum ++;
            }
        }
        self.collectionView.availNum =availNum;
        NSLog(@"首页小模块--取出缓存-avail:%d,%@",self.collectionView.availNum,self.modulesArray);
        
        [self.collectionView reloadData];
    }
    else
    {
        //存数据
        NSMutableArray *dataArray = [NSMutableArray array];
        
        ModuleModel *blankModel = [[ModuleModel alloc]initWithTitle:@"" iconName:@"" moduleNum:newModuleBlank modulewith:104.0f moduleheight:104.0f];
        //创建模块，内部、外请
        
        
        ModuleModel *model0 = [[ModuleModel alloc]initWithTitle:@"通讯录" iconName:@"txl" moduleNum:newModuleContact modulewith:104.0f moduleheight:150.0f];
        ModuleModel *model1 = [[ModuleModel alloc]initWithTitle:@"考勤打卡" iconName:@"carcode2" moduleNum:newModuleCarCard modulewith:104.0f moduleheight:150.0f];
        ModuleModel *model2 = [[ModuleModel alloc]initWithTitle:@"加班记录" iconName:@"hbcx" moduleNum:newModuleFlightQuery modulewith:104.0f moduleheight:150.0f];
        ModuleModel *model3 = [[ModuleModel alloc]initWithTitle:@"绩效考核" iconName:@"tsjb" moduleNum:newModuleComplaints modulewith:104.0f moduleheight:104.0f];
        ModuleModel *model4 = [[ModuleModel alloc]initWithTitle:@"荣誉墙" iconName:@"khjs2" moduleNum:newModuleDriverIntroduce modulewith:104.0f moduleheight:150.0f];
        ModuleModel *model5 = [[ModuleModel alloc]initWithTitle:@"技能升级" iconName:@"zcpd2" moduleNum:newModuleAssets modulewith:104.0f moduleheight:104.0f];
        ModuleModel *model6 = [[ModuleModel alloc]initWithTitle:@"资产交接" iconName:@"zcjj" moduleNum:newModuleAssetTransfe modulewith:104.0f moduleheight:150.0f];
        
        
        [self.modulesArray addObjectsFromArray:@[model0,model1,model2,model3,model4,model5,model6]];
        self.collectionView.availNum = self.modulesArray.count;
        
        
        //数据归档
//        NSData *data0 = [NSKeyedArchiver archivedDataWithRootObject:model0];
//        NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:model1];
//        NSData *data2 = [NSKeyedArchiver archivedDataWithRootObject:model2];
//        NSData *data3 = [NSKeyedArchiver archivedDataWithRootObject:model3];
//        NSData *data4 = [NSKeyedArchiver archivedDataWithRootObject:model4];
//        NSData *data5 = [NSKeyedArchiver archivedDataWithRootObject:model5];
//        NSData *data6 = [NSKeyedArchiver archivedDataWithRootObject:model6];
//        
//        
//        [dataArray addObjectsFromArray:@[data0,data1,data2,data3,data4,data5,data6]];

        //添加空白模块
//        if (dataArray.count < 12) {
//            NSInteger blankCount = 12 - dataArray.count;
//            for (int i = 0; i<blankCount; i++) {
//                
//                NSData *dataBlank = [NSKeyedArchiver archivedDataWithRootObject:blankModel];
//                [dataArray addObject:dataBlank];
//                [self.modulesArray addObject:blankModel];
//            }
//        }
        
        NSLog(@"首页小模块--存储模块信息-avail:%d,数据：%@",self.collectionView.availNum,self.modulesArray);
        //保存
        [userDefault setObject:dataArray forKey:keyHomeModeularCell];
        
        [userDefault synchronize];
        
        [self.collectionView reloadData];
    }
}


- (void)addCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init] ;
    flowLayout.itemSize = CGSizeMake((kSCREEN_WIDTH-25)/4.0, (kSCREEN_HEIGHT-125)/5.0) ;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.minimumInteritemSpacing = 2 ;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical ;
    
    self.collectionView = [[ModuleCollectionView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT) collectionViewLayout:self.layout];
    self.collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerNib:[HomeCollectionViewCell nib] forCellWithReuseIdentifier:collectionCellID];
    self.collectionView.delegate = self ;
    
    self.collectionView.dataSource = self;
    self.collectionView.adelegate = self;
    self.collectionView.adataSource = self;
    
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView] ;
}

//自定制快照样式
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
   
    return snapshot;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ModuleModel *mmodel = self.modulesArray[indexPath.row];
    return CGSizeMake(mmodel.width, mmodel.height);
}

-(UICollectionViewLayout *)layout{
    if(!_layout){
        _layout = [[WaterfallColectionLayout alloc]initWithItemsHeightBlock:^CGFloat(NSIndexPath *index) {
            ModuleModel *mmodel = self.modulesArray[index.item];
            return mmodel.height;
        }];
        
    }
    return _layout;
}
- (void)setModuleByOrder
{
    
}


#pragma mark  UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.modulesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    
    
    
    ModuleModel *mmodel = self.modulesArray[indexPath.row];
    
    [cell refreshUIWithImageName:mmodel.iconName title:mmodel.title];
    
    if ([mmodel.moduleNum isEqualToString:newModuleBlank]) {
        cell.selectedBackgroundView = [UIView new];
    }
    
    return cell;
    
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ModuleModel *model = self.modulesArray[indexPath.row];
    NSLog(@"点击了：%@",model.title);
}


#pragma mark - RTDragCellcollectionViewDataSource & Delegate 滑动代理
- (void)collectionView:(ModuleCollectionView *)collectionView newArrayDataForDataSource:(NSArray *)newArray{
    self.modulesArray = [NSMutableArray arrayWithArray:newArray] ;
    
    // 存储数据
    NSMutableArray *arrary = [NSMutableArray array];
    for (ModuleModel *model in self.modulesArray) {
        // 数据类型的转化
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model] ;
        [arrary addObject:data] ;
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults] ;
    
    [userDefault setObject:arrary forKey:keyHomeModeularCell];
    
    [userDefault synchronize];
    
}

-(void)cellDidEndMovingIncollectionView:(ModuleCollectionView *)collectionView
{
    [self.collectionView reloadData];
}

- (NSArray *)originalArrayDataForcollectionView:(ModuleCollectionView *)collectionView{
    return self.modulesArray;
}




-(NSMutableArray *)modulesArray
{
    if (!_modulesArray) {
        _modulesArray = [[NSMutableArray alloc]init];
    }
    return _modulesArray;
}




@end
