//
//  LeftViewTableViewCell.m
//  DrUser
//
//  Created by mac on 2017/6/17.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "LeftViewTableViewCell.h"

@implementation LeftViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.theButton.enabled=NO;
    self.otherLable.hidden=YES;
    self.theButton.adjustsImageWhenDisabled=NO;
    self.theButton.adjustsImageWhenHighlighted=NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
