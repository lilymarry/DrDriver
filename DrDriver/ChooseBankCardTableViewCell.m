//
//  ChooseBankCardTableViewCell.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChooseBankCardTableViewCell.h"

@implementation ChooseBankCardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.chooseButton setImage:[UIImage imageNamed:@"choose_bank_normal"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"choose_bank_pre"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
