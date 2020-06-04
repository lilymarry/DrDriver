//
//  FaceAlertView.m
//  DrDriver
//
//  Created by fy on 2018/9/27.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "FaceAlertView.h"

@implementation FaceAlertView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        [self creatView];
    }
    return self;
}

-(void)creatView{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.bgView];
    
    self.faceView = [[UIView alloc] init];
    self.faceView.backgroundColor = [UIColor whiteColor];
    self.faceView.layer.cornerRadius = 10;
    [self.bgView addSubview:self.faceView];
    [self.faceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        make.width.mas_offset(275);
        make.height.mas_offset(285);
    }];
    
    self.faceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scanfacelan"]];
    [self.faceView addSubview:self.faceImageView];
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.faceView);
        make.top.equalTo(@25);
        make.width.mas_offset(90);
        make.height.mas_offset(80);
    }];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.textColor = [CYTSI colorWithHexString:@"#2488ef"];
    self.titleLB.font = [UIFont systemFontOfSize:30];
    self.titleLB.text = @"人脸识别认证";
    [self.faceView addSubview:self.titleLB];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.faceView);
        make.top.equalTo(self.faceImageView.mas_bottom).offset(15);
    }];
    
    self.detailLB = [[UILabel alloc] init];
    self.detailLB.textColor = [CYTSI colorWithHexString:@"#999999"];
    self.detailLB.font = [UIFont systemFontOfSize:14];
    self.detailLB.textAlignment = NSTextAlignmentCenter;
    self.detailLB.text = @"应相关部门要求，为保障您的出行安全，需要在接单前进行人脸识别，谢谢您的配合！";
    self.detailLB.numberOfLines = 0;
    [self.faceView addSubview:self.detailLB];
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(self.titleLB.mas_bottom).offset(15);
    }];
    
    self.scanFaceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.faceView addSubview:self.scanFaceBtn];
    self.scanFaceBtn.layer.cornerRadius = 5;
    self.scanFaceBtn.layer.masksToBounds = YES;
    [self.scanFaceBtn setTitle:@"立即认证" forState:(UIControlStateNormal)];
    [self.scanFaceBtn setBackgroundColor:[UIColor colorWithRed:36/255.0 green:136/255.0 blue:239/255.0 alpha:1.0]];
    [self.scanFaceBtn addTarget:self action:@selector(scanFaceAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.scanFaceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.faceView).offset(-10);
        make.right.equalTo(self.faceView.mas_centerX).offset(-10);
    }];
    
    self.cancelBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.faceView addSubview:self.cancelBtn];
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    [self.cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [self.cancelBtn setBackgroundColor:[UIColor colorWithRed:245/255.0 green:166/255.0 blue:35/255.0 alpha:1.0]];
    [self.cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(114);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.faceView).offset(-10);
        make.left.equalTo(self.faceView.mas_centerX).offset(10);
    }];
}
-(void)scanFaceAction{
    self.scanFaceBlock(self.dataDic,self.state,self.orderID,self.btnState);
}
-(void)cancelAction{
    [self hidenFaceAlertView];
}

-(void)showFaceAlertView:(NSDictionary *)dataDic state:(NSString *)stateStr orderid:(NSString *)orderID btnSate:(NSInteger)btnSate{
    self.dataDic = dataDic;
    self.state = stateStr;
    self.orderID = orderID;
    self.btnState = btnSate;
    self.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
}
-(void)hidenFaceAlertView{
    self.frame = CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
