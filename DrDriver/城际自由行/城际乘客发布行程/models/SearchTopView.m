//
//  SearchTopView.m
//  DrUser
//
//  Created by fy on 2018/8/3.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "SearchTopView.h"

@implementation SearchTopView
//-(void)setFrame:(CGRect)frame{
//
//    [super setFrame:frame];
////    self.center = CGPointMake(self.superview.center.x - 50, self.center.y);
//
//
//}
-(instancetype)initWithFrame:(CGRect)frame withName:(NSString *)placeHoldText
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.masksToBounds=YES;
        self.layer.borderColor=[UIColor whiteColor].CGColor;
        self.layer.borderWidth=1;
        [self creatViewWithName:placeHoldText];
    }
    return self;
}
-(void)creatViewWithName:(NSString *)placeHoldText{
    self.searchImage = [[UIImageView alloc] init];
    self.searchImage.image = [UIImage imageNamed:@"search"];
    [self addSubview:self.searchImage];
    [self.searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10.0/414.0 * DeviceWidth);
        make.width.and.height.mas_offset(20.0/414.0 * DeviceWidth);
    }];
    

    self.CommericalTenantTF = [[UITextField alloc] init];
    self.CommericalTenantTF.placeholder = @"请输入地址";
    [self addSubview:self.CommericalTenantTF];
    [self.CommericalTenantTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.searchImage.mas_right);
        make.right.equalTo(self);
        make.height.mas_offset(20);
    }];
}
-(void)scanAction{
    self.scanActionBlock();
}



@end
