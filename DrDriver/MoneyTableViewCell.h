//
//  MoneyTableViewCell.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet UILabel *typeLable;
@property (strong, nonatomic) IBOutlet UILabel *moneyLable;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@end
