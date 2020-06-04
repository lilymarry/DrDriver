//
//  GeoFenceMapTopView.m
//  DrUser
//
//  Created by fy on 2019/3/8.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "GeoFenceMapTopView.h"

@implementation GeoFenceMapTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatView];
    }
    return self;
}
-(void)creatView{
    UILabel *backGroundLB = [[UILabel alloc] init];
    backGroundLB.backgroundColor = RGBA(240, 240, 240, 1.0);
    backGroundLB.layer.cornerRadius = 15;
    backGroundLB.layer.masksToBounds = YES;
    backGroundLB.userInteractionEnabled = YES;
    [self addSubview:backGroundLB];
    [backGroundLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.mas_offset(30);
        make.width.mas_offset(self.frame.size.width - 90);
    }];
    
    self.searchTF = [[UITextField alloc] init];
    self.searchTF.backgroundColor = RGBA(240, 240, 240, 1.0);
    self.searchTF.placeholder = @"搜索或点击上车位置";
    self.searchTF.layer.cornerRadius = 15;
    [backGroundLB addSubview:self.searchTF];
    [self.searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundLB).offset(10);
        make.centerY.equalTo(backGroundLB);
        make.height.mas_offset(30);
        make.width.mas_offset(self.frame.size.width - 110);
    }];
    
    self.btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.btn setTitle:@"取消" forState:(UIControlStateNormal)];
    self.btn.backgroundColor = [UIColor whiteColor];
    [self.btn addTarget:self action:@selector(cancelInteraction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [self addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backGroundLB.mas_right);
        make.centerY.equalTo(backGroundLB);
        make.height.mas_offset(40);
        make.width.mas_offset(80);
    }];

}
-(void)cancelInteraction{
    self.cancelBlock();
}

@end
