//
//  ScanTripDetailViewController.h
//  DrUser
//
//  Created by fy on 2018/4/26.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStarView.h"
#import "OrderDetailModel.h"

@interface ScanTripDetailViewController : UIViewController

@property(nonatomic,strong)UIImageView *backGroundImageView;
@property(nonatomic,strong)UILabel *orderIDLB;//订单号
@property(nonatomic,strong)UILabel *timeLB;//时间
@property(nonatomic,strong)UILabel *expensesLB;//费用
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *userNameLB;
@property(nonatomic,strong)CYStarView *starView;//评价星
@property(nonatomic,strong)UIButton *pingJiaBtn;
@property(nonatomic,strong)UILabel *modeLB;//支付方式

@property(nonatomic,strong)NSString * order_id;

@property(nonatomic,strong)UILabel *titleLB;



@end
