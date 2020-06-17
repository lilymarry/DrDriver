//
//  UpdateAlertView.m
//  DrUser
//
//  Created by fy on 2018/5/22.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "UpdateAlertView.h"

@implementation UpdateAlertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatView];
    }
    return self;
}

-(void)creatView{
    self.alertView = [[UIView alloc] init];
    [self addSubview:self.alertView];
    self.alertView.backgroundColor = [UIColor whiteColor];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_offset(275);
        make.height.mas_offset(322);
    }];
    
    UIView *updateImageBackgroundView = [[UIView alloc] init];
    updateImageBackgroundView.backgroundColor = [UIColor whiteColor];
    updateImageBackgroundView.layer.cornerRadius = 37;
    updateImageBackgroundView.layer.masksToBounds = YES;
    [self addSubview:updateImageBackgroundView];
    [updateImageBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.centerY.equalTo(self.alertView.mas_top);
        make.width.and.height.mas_offset(75);
    }];
    
    self.updateImage = [[UIImageView alloc] init];
    self.updateImage.image = [UIImage imageNamed:@"update"];
    [self addSubview:self.updateImage];
    [self.updateImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.centerY.equalTo(self.alertView.mas_top);
        make.width.and.height.mas_offset(60);
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"版本更新啦";
    self.titleLabel.font = [UIFont systemFontOfSize:22];
    self.titleLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.updateImage.mas_bottom).offset(25);
    }];
    
    self.versionNumberLabel = [[UILabel alloc] init];
    self.versionNumberLabel.textColor = [UIColor colorWithRed:36.0/255.0 green:136.0/255.0 blue:239.0/255.0 alpha:1.0];
    self.versionNumberLabel.text = @"V 1.3.5";
    self.versionNumberLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.versionNumberLabel];
    [self.versionNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textColor = [UIColor colorWithDisplayP3Red:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    [self addSubview:self.descriptionLabel];
    [self.descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.versionNumberLabel.mas_bottom).offset(25);
        make.width.mas_offset(200);
        make.height.mas_offset(100);
    }];
    
    self.confirmBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.confirmBtn setTitle:@"确  定" forState:(UIControlStateNormal)];
    [self.confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.confirmBtn.layer.cornerRadius = 5;
    self.confirmBtn.layer.masksToBounds = YES;
    self.confirmBtn.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    [self addSubview:self.confirmBtn];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.alertView.mas_bottom).offset(-25);
    }];
    
}

-(void)confirmAction{
//    NSLog(@"立即更新");
    exit(1);
}

//-(void)cancelAction{
//    NSLog(@"稍后更新");
//    [self removeFromSuperview];
//}

@end
