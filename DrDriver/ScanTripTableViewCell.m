//
//  ScanTripTableViewCell.m
//  DrUser
//
//  Created by fy on 2018/4/28.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "ScanTripTableViewCell.h"
#import "ScanCarModel.h"
@implementation ScanTripTableViewCell



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 3;
        self.bgView.layer.masksToBounds = YES;
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(10, 0, 10, 0));
        }];
        
        self.timeLB = [[UILabel alloc] init];
        self.timeLB.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:self.timeLB];
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgView).offset(25);
            make.top.equalTo(self.bgView.mas_top).offset(10);
        }];
        
        self.expensesLB = [[UILabel alloc] init];
        self.expensesLB.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:self.expensesLB];
        [self.expensesLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.timeLB);
            make.top.equalTo(self.timeLB.mas_bottom).offset(3);
        }];
        
        self.orderIDLB = [[UILabel alloc] init];
        self.orderIDLB.font = [UIFont systemFontOfSize:14];
        [self.bgView addSubview:self.orderIDLB];
        [self.orderIDLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.expensesLB);
            make.top.equalTo(self.expensesLB.mas_bottom).offset(3);
        }];
        
        
        self.dianLB = [[UILabel alloc] init];
        self.dianLB.text = @"···";
        [self.bgView addSubview:self.dianLB];
        [self.dianLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.bgView);
            make.right.equalTo(self.bgView.mas_right).offset(-20);
        }];
        
    }
    return self;
}

- (void)setScanCar:(ScanCarModel *)scanCar{
    _scanCar = scanCar;
    self.timeLB.text = [NSString stringWithFormat:@"时间:%@",_scanCar.ctime];
    self.expensesLB.text = [NSString stringWithFormat:@"金额:%@",_scanCar.driver_price];
    self.orderIDLB.text = [NSString stringWithFormat:@"订单号:%@",_scanCar.order_sn];;
    
}


@end
