//
//  ScanTripTableViewCell.h
//  DrUser
//
//  Created by fy on 2018/4/28.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScanCarModel;

@interface ScanTripTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *orderIDLB;//订单号
@property(nonatomic,strong)UILabel *timeLB;//时间
@property(nonatomic,strong)UILabel *expensesLB;//费用
@property(nonatomic,strong)UILabel *dianLB;//点
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)ScanCarModel *scanCar;
@end
