//
//  PerfectThreeTableViewCell.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PerfectThreeTableViewCell.h"

@implementation PerfectThreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius=5;
    self.bgView.layer.masksToBounds=YES;
//    self.bgView.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;
//    self.bgView.layer.borderWidth=0.5;
    
    self.photoButton.adjustsImageWhenHighlighted=NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
