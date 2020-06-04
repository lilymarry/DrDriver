//
//  ITDriverOrderViewController.h
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YUFoldingTableView.h"
#import "CYButtonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ITDriverOrderViewController : UIViewController

@property (nonatomic, strong)YUFoldingTableView *foldingTableView;
@property (nonatomic, copy) NSString * currentPage;//当前分页数
@property(nonatomic,strong)NSMutableArray *today_list;
@property(nonatomic,strong)NSMutableArray *tomorrow_list;
@property(nonatomic,strong)NSMutableArray *after_tomorrow_list;
@property(nonatomic,strong)CYButtonView * midleButtonView;//中间听单视图
@property(assign, nonatomic)BOOL isCanListen;//是否可以听单

@property(nonatomic,strong)void (^pushCreationOrder)();
@property(nonatomic,strong)void (^pushDetailVC)(NSString *travelID,NSString *date,NSString *time);
@property(nonatomic,strong)void (^refreshD)();
@property(nonatomic,strong)void (^refreshU)();

-(void)refreshDown;

@end

NS_ASSUME_NONNULL_END
