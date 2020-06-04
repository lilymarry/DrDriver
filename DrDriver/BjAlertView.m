//
//  BjAlertView.m
//  DrDriver
//
//  Created by fy on 2018/9/5.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "BjAlertView.h"

@implementation BjAlertView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(instancetype)initWithFrame:(CGRect)frame addressString:(NSString *)addressStr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatViewAddressString:addressStr];
    }
    return self;
}

-(void)creatViewAddressString:(NSString *)addressStr{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.bgView];
    
    self.bjView = [[UIView alloc] init];
    self.bjView.backgroundColor = [UIColor whiteColor];
    self.bjView.layer.cornerRadius = 10;
    self.bjView.layer.masksToBounds = YES;
    [self addSubview:self.bjView];
    [self.bjView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(275);
        make.height.mas_offset(400);
        make.center.equalTo(self);
    }];
    
    self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bjbjbj"]];
    self.bgImageView.layer.cornerRadius = 10;
    self.bgImageView.layer.masksToBounds = YES;
    self.bgImageView.userInteractionEnabled = YES;
    [self.bjView addSubview:self.bgImageView];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bjView);
        make.width.and.height.equalTo(self.bjView);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.text = @"立即报警?";
    self.titleLB.textColor = [UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0];
    self.titleLB.font = [UIFont systemFontOfSize:30];
    [self.bgImageView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(110);
        make.centerX.equalTo(self.bgImageView);
    }];
    
    self.addressLB = [[UILabel alloc] init];
    self.addressLB.numberOfLines = 0;
    [CYTSI setStringWith:[NSString stringWithFormat:@"%@ (当前位置仅供参考)",addressStr] someStr:@"(当前位置仅供参考)" lable:self.addressLB theFont:[UIFont systemFontOfSize:14] theColor:[UIColor lightGrayColor]];
    self.addressLB.textAlignment = NSTextAlignmentCenter;
    [self.bgImageView addSubview:self.addressLB];
    [self.addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(20);
        make.right.equalTo(self.bgImageView).offset(-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(20);
    }];
    
    self.hintLB = [[UILabel alloc] init];
    self.hintLB.textColor = [UIColor colorWithRed:255/255.0 green:120/255.0 blue:120/255.0 alpha:1.0];
    self.hintLB.text = @"提示：谎报警情将被处以五日以上十日以下拘留";
    self.hintLB.textAlignment = NSTextAlignmentCenter;
    self.hintLB.numberOfLines = 0;
    self.hintLB.font = [UIFont systemFontOfSize:14];
    [self.bgImageView addSubview:self.hintLB];
    [self.hintLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImageView).offset(20);
        make.right.equalTo(self.bgImageView).offset(-20);
        make.top.equalTo(self.addressLB.mas_bottom).offset(30);
    }];
    
    self.bjBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.bgImageView addSubview:self.bjBtn];
    self.bjBtn.layer.cornerRadius = 5;
    self.bjBtn.layer.masksToBounds = YES;
    [self.bjBtn setTitle:@"立即报警" forState:(UIControlStateNormal)];
    [self.bjBtn setBackgroundColor:[UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0]];
    [self.bjBtn addTarget:self action:@selector(bjAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.bjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.bgImageView).offset(-20);
        make.right.equalTo(self.bgImageView.mas_centerX).offset(-10);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.bgImageView addSubview:self.cancelBtn];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0]];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.bgImageView).offset(-20);
        make.left.equalTo(self.bgImageView.mas_centerX).offset(10);
    }];
    
}
-(void)bjAction{
    self.bjActionBlock();
}
-(void)cancelAction{
    self.cancel();
}
@end
