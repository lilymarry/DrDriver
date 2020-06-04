//
//  CancelTripTableViewCell.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CancelTripTableViewCell.h"

@implementation CancelTripTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.selectButton setImage:[UIImage imageNamed:@"cancel_trip_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"cancel_trip_pre"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
