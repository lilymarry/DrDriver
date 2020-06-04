//
//  CityAndTypeTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/3/12.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "CityAndTypeTableViewCell.h"

@implementation CityAndTypeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        self.typeTitleLB = [[UILabel alloc] init];
        self.typeTitleLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.typeTitleLB];
        
        self.typeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未选择q"]];
        [self addSubview:self.typeImageView];
        
        self.lineLB = [[UILabel alloc] init];
        [self addSubview:self.lineLB];
        self.lineLB.backgroundColor = [UIColor lightGrayColor];
        self.lineLB.alpha = 0.7;
    }
    return self;
}
-(void)layoutSubviews{
    [self.typeTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(10);
    }];
    
    [self.typeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.mas_offset(-10);
        make.height.and.width.mas_offset(15);
    }];
    
    [self.lineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(1);
        make.width.equalTo(self);
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
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
