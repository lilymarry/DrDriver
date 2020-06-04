//
//  ITTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/1/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITTableViewCell.h"

@implementation ITTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {        
        self.topLineLB = [[UILabel alloc] init];
        self.topLineLB.backgroundColor = TABLEVIEW_BACKCOLOR;
        [self addSubview:self.topLineLB];
        
        
        self.titleLB = [[UILabel alloc] init];
        self.titleLB.text = @"-------";
        self.titleLB.font = [UIFont systemFontOfSize:15];
        self.titleLB.textColor = [UIColor lightGrayColor];
        [self addSubview:self.titleLB];
        
        
//        self.igView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
//        [self addSubview:self.igView];
       
    }
    return self;
}
-(void)layoutSubviews{
    [self.topLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.centerX.equalTo(self);
        make.height.mas_offset(1);
        make.width.mas_offset(DeviceWidth);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topLineLB.mas_bottom).offset(10);
        make.center.equalTo(self);
    }];
    
//    [self.igView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self);
//        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
//        make.height.and.width.mas_offset(20);
//    }];
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
