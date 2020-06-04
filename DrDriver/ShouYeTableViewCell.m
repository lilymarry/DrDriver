//
//  ShouYeTableViewCell.m
//  DrUser
//
//  Created by mac on 2017/6/16.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ShouYeTableViewCell.h"

@implementation ShouYeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.cornerRadius=4;
    self.layer.masksToBounds=YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
