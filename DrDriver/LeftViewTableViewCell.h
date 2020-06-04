//
//  LeftViewTableViewCell.h
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *theButton;
@property (strong, nonatomic) IBOutlet UILabel *myLable;
@property (strong, nonatomic) IBOutlet UILabel *otherLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *moneyWidth;

@end
