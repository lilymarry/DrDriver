//
//  ChooseBankCardTableViewCell.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseBankCardTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *chooseButton;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UILabel *bankNameLable;
@property (strong, nonatomic) IBOutlet UILabel *bankNumberLable;

@end
