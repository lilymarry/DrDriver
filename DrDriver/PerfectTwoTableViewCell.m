//
//  PerfectTwoTableViewCell.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PerfectTwoTableViewCell.h"

@implementation PerfectTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.cornerRadius=5;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;
    self.bgView.layer.borderWidth=0.5;
    
    self.clickedButton.hidden=YES;
    
}

//设置cell类型
-(void)setCellType
{
    self.closeButton.hidden=NO;
    self.clickedButton.hidden=NO;
    [self.closeButton setImage:[UIImage imageNamed:@"money_after"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
