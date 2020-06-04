

//
//  shouYeHeaderView.m
//  DrDriver
//
//  Created by qqqqqqq on 2018/9/21.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "shouYeHeaderView.h"
#import "ShouYeModel.h"

@interface shouYeHeaderView()



@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;//头像

@property (weak, nonatomic) IBOutlet UILabel *nameLB;//名字
@end

@implementation shouYeHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.peakHoursBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.peakHoursBtn.layer.borderWidth = 0.5f;
    self.peakHoursBtn.layer.cornerRadius = 8;
    self.peakHoursBtn.layer.masksToBounds = YES;
    
    self.todayHoursBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.todayHoursBtn.layer.borderWidth = 0.5f;
    self.todayHoursBtn.layer.cornerRadius = 8;
    self.todayHoursBtn.layer.masksToBounds = YES;
    
    self.todayMoneyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.todayMoneyBtn.layer.borderWidth = 0.5f;
    self.todayMoneyBtn.layer.cornerRadius = 8;
    self.todayMoneyBtn.layer.masksToBounds = YES;
    
    self.avatarImage.layer.cornerRadius = 40;
    self.avatarImage.layer.masksToBounds = YES;
    
  
    
}

- (IBAction)peakHoursAction:(UIButton *)sender {
    self.peakHoursBlock(@"peak");
}

- (IBAction)todayHoursAction:(UIButton *)sender {
    self.todayHoursBlock(@"today");
}

+ (instancetype)createView{
    return [[[NSBundle mainBundle] loadNibNamed:@"shouYeHeaderView" owner:self options:nil] lastObject];
}


- (void)setShouye:(ShouYeModel *)shouye{
    _shouye = shouye;
    [self.peakHoursBtn setTitle:_shouye.peak_time forState:UIControlStateNormal];
    [self.todayHoursBtn setTitle:_shouye.online_time forState:UIControlStateNormal];
    [self.todayMoneyBtn setTitle:_shouye.driver_fee forState:UIControlStateNormal];
    [self.avatarImage sd_setImageWithURL:[NSURL URLWithString:_shouye.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
    self.nameLB.text = _shouye.driver_name;
    
}
@end
