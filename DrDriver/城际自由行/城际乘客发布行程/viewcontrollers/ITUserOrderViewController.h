//
//  ITUserOrderViewController.h
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTravelListModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ITUserOrderViewController : UIViewController

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIView *ITstartAddressBtn;
@property(nonatomic,strong)UILabel *ITstartLB;
@property(nonatomic,strong)UIImageView *ITstartImage;
@property(nonatomic,strong)UIView *ITendAddressBtn;
@property(nonatomic,strong)UILabel *ITendLB;
@property(nonatomic,strong)UIImageView *ITendImage;
@property(nonatomic,strong)UIButton *ITTimeBtn;
@property(nonatomic,strong)UIButton *ITNumberBtn;

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;


@property(nonatomic,strong)SearchTravelListModel *searchModel;
@property (assign, nonatomic) BOOL isCanListen;//是否可以听单

-(void)creatHttp;
@property(nonatomic,strong)void (^userPushDetail)(NSString *order_id,BOOL isCanListen);
@property(nonatomic,copy)NSString *seat_num;//当前分页数

@end

NS_ASSUME_NONNULL_END
