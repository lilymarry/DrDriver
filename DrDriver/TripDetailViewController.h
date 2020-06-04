//
//  TripDetailViewController.h
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStarView.h"

@interface TripDetailViewController : BaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLine;
@property (strong, nonatomic) IBOutlet UIView *selectView;
@property (strong, nonatomic) IBOutlet UILabel *idCardLB;


@property (strong, nonatomic) IBOutlet UIImageView *headImageView;//司机头像
@property (strong, nonatomic) IBOutlet UILabel *pingJiaLable;//是否已评价
@property (strong, nonatomic) IBOutlet CYStarView *starView;//星星视图
@property (strong, nonatomic) IBOutlet UIButton *pingJiaButton;//评价按钮
@property (strong, nonatomic) IBOutlet UIView *bottomBgView;//底部背景视图
@property (strong, nonatomic) IBOutlet UILabel *startLable;
@property (strong, nonatomic) IBOutlet UILabel *endLable;
@property (strong, nonatomic) IBOutlet UILabel *driverNumberLable;
@property (strong, nonatomic) IBOutlet UILabel *driverCompanyLable;

@property (strong, nonatomic) IBOutlet UIButton *phoneButton;

@property (weak, nonatomic) IBOutlet UILabel *remarkLB;//备注信息

@property (strong, nonatomic) NSString * orderID;//订单id
@property (assign, nonatomic) BOOL isSuccess;//是否是从付款成功界面过来的






@end
