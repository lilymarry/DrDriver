//
//  TakeAndSendAlertTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/3/13.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TakeAndSendAlertTableViewCell.h"

@implementation TakeAndSendAlertTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.numberLB = [[UILabel alloc] init];
        self.numberLB.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.numberLB];
    }
    return self;
}
-(void)layoutSubviews{
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
-(void)setData:(NSString *)title number:(float)number{
    NSString *str = @"";
    if (number == 0) {
        str = [NSString stringWithFormat:@"①请接手机尾号为%@的乘客",title];
    }else if (number == 1){
        str = [NSString stringWithFormat:@"②请接手机尾号为%@的乘客",title];
    }else if (number == 2){
        str = [NSString stringWithFormat:@"③请接手机尾号为%@的乘客",title];
    }else if (number == 3){
        str = [NSString stringWithFormat:@"④请接手机尾号为%@的乘客",title];
    }else if (number == 4){
        str = [NSString stringWithFormat:@"⑤请接手机尾号为%@的乘客",title];
    }else if (number == 5){
        str = [NSString stringWithFormat:@"⑥请接手机尾号为%@的乘客",title];
    }else if (number == 6){
        str = [NSString stringWithFormat:@"⑦请接手机尾号为%@的乘客",title];
    }else if (number == 7){
        str = [NSString stringWithFormat:@"⑧请接手机尾号为%@的乘客",title];
    }else{
        str = [NSString stringWithFormat:@"请接手机尾号为%@的乘客",title];
    }
    [CYTSI setDefrientColorWith:str someStr:title theLable:self.numberLB theColor:[CYTSI colorWithHexString:@"#f5a623"]];
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
