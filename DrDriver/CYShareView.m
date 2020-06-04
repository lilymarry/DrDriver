//
//  CYShareView.m
//  DrDriver
//
//  Created by mac on 2017/7/21.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYShareView.h"

@implementation CYShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray
{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self creatAlertViewImageArray:imageArray titleArray:titleArray];//创建弹出视图
        
    }
    
    return self;
}

//创建弹出视图
-(void)creatAlertViewImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray
{
    _shareView=[[UIView alloc]init];
    _shareView.frame=CGRectMake(0, DeviceHeight, DeviceWidth, 150);
    _shareView.backgroundColor=[UIColor whiteColor];
//    _shareView.layer.cornerRadius=5;
//    _shareView.layer.masksToBounds=YES;
    [self addSubview:_shareView];
    
    UIButton * cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    cancleButton.frame=CGRectMake(0, 100, DeviceWidth, 50);
    cancleButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [cancleButton addTarget:self action:@selector(hideShareView) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:cancleButton];
    
    CGFloat width=DeviceWidth/3;
    
    for (int i=0; i<3; i++) {
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(width*i, 0, width, 50)];
        bgView.backgroundColor=[UIColor whiteColor];
        [_shareView addSubview:bgView];
        
        UIImageView * imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:imageArray[i]]];
        [bgView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bgView);
            make.width.and.height.equalTo(@50);
            make.top.equalTo(@10);
        }];
        
        UILabel * lable=[[UILabel alloc]init];
        lable.textColor=[CYTSI colorWithHexString:@"#666666"];
        lable.font=[UIFont systemFontOfSize:13];
        lable.text=titleArray[i];
        lable.textAlignment=NSTextAlignmentCenter;
        [bgView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(imageView);
            make.width.equalTo(@50);
            make.height.equalTo(@20);
            make.top.equalTo(imageView.mas_bottom).with.offset(10);
        }];
        
        UIButton * shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
        shareButton.tag=10+i;
        shareButton.frame=CGRectMake(width*i, 0, width, 50);
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:shareButton];
        
    }
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 100.5, DeviceWidth, 0.5)];
    lineView.backgroundColor=[UIColor lightGrayColor];
    [_shareView addSubview:lineView];
    
}

//分享按钮点击事件
-(void)shareButtonClicked:(UIButton *)btn
{
    self.shareClicked(btn.tag-10);
}

//显示弹出视图
-(void)showShareView
{
    self.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    [UIView animateWithDuration:0.3 animations:^{
        
        self.shareView.frame=CGRectMake(0, DeviceHeight-150, DeviceWidth, DeviceHeight);
        
    }];
}

//隐藏弹出视图
-(void)hideShareView
{
    self.frame=CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight);
    self.shareView.frame=CGRectMake(0, DeviceHeight, DeviceWidth, DeviceHeight);
}


@end
