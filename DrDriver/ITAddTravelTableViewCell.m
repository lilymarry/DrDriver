//
//  ITAddTravelTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/7/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITAddTravelTableViewCell.h"

@implementation ITAddTravelTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addTravel"]];
        [self addSubview:self.addImage];
        
        
        self.addLB = [[UILabel alloc] init];
        self.addLB.text = @"发布行程";
        self.addLB.textColor = [UIColor lightGrayColor];
        self.addLB.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.addLB];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).mas_offset(-10);
        make.width.and.height.mas_offset(40);
    }];
    
    [self.addLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.addImage.mas_bottom).mas_offset(3);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
