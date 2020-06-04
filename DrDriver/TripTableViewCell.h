//
//  TripTableViewCell.h
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet UILabel *startLable;
@property (strong, nonatomic) IBOutlet UILabel *endLable;
@property (strong, nonatomic) IBOutlet UILabel *stateLable;
@property (weak, nonatomic) IBOutlet UIImageView *planeImageView;
@property (weak, nonatomic) IBOutlet UILabel *appoint_type_LB;

@end
