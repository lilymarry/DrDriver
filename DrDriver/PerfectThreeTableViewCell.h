//
//  PerfectThreeTableViewCell.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectThreeTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIButton *photoButton;
@property (strong, nonatomic) IBOutlet UILabel *oneLable;
@property (strong, nonatomic) IBOutlet UILabel *twoLable;
@property (strong, nonatomic) IBOutlet UILabel *threeLable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *oneLableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *twoLableHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *threeLableHeight;

@end
