//
//  TripOneTableViewCell.h
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripOneTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (strong, nonatomic) IBOutlet UILabel *startLable;
@property (strong, nonatomic) IBOutlet UILabel *endLable;
@property (strong, nonatomic) IBOutlet UILabel *stateLB;
@property (strong, nonatomic) IBOutlet UILabel *timeLb;
@property (strong, nonatomic) IBOutlet UILabel *typeLB;

@end
