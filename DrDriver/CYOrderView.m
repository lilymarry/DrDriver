//
//  CYOrderView.m
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYOrderView.h"


@implementation CYOrderView{
   
}


-(instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {

        [self creatMainView:frame];//创建主要视图

    }

    return self;
}

//创建主要视图
-(void)creatMainView:(CGRect)frame
{
    self.bgImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_bgview"]];
    self.bgImageView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
    [self addSubview:self.bgImageView];
    
    
    UIView * topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
    topView.backgroundColor=[CYTSI colorWithHexString:@"#383635"];
    [self addSubview:topView];
    
    self.titleLable =[[UILabel alloc]init];
    self.titleLable.text=@"实时";
    self.titleLable.font=[UIFont systemFontOfSize:16];
    self.titleLable.textColor=[UIColor whiteColor];
    self.titleLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.titleLable];
    [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY);
        make.left.equalTo(@0);
        make.height.equalTo(@40);
    }];
    
    UIButton * closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setImage:[UIImage imageNamed:@"orderview_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right);
        make.top.equalTo(@0);
        make.width.and.height.equalTo(@40);
    }];
    
    self.startDistanceLable=[[UILabel alloc]init];
    self.startDistanceLable.frame=CGRectMake(0, 40, frame.size.width/2, 40);
    self.startDistanceLable.text=@"接驾2.3公里";
    self.startDistanceLable.backgroundColor=[UIColor whiteColor];
    self.startDistanceLable.font=[UIFont systemFontOfSize:12];
    self.startDistanceLable.textColor=[CYTSI colorWithHexString:@"#666666"];;
    self.startDistanceLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.startDistanceLable];
    
    self.allDistanceLable=[[UILabel alloc]init];
    self.allDistanceLable.frame=CGRectMake(frame.size.width/2, 40, frame.size.width/2, 40);
    self.allDistanceLable.text=@"全程7.8公里";
    self.allDistanceLable.backgroundColor=[UIColor whiteColor];
    self.allDistanceLable.font=[UIFont systemFontOfSize:12];
    self.allDistanceLable.textColor=[CYTSI colorWithHexString:@"#666666"];;
    self.allDistanceLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.allDistanceLable];
    
    self.addressView=[[CYAddressView alloc]init];
    self.addressView.backgroundColor=[CYTSI colorWithHexString:@"#f8f8f8"];
    [self addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startDistanceLable.mas_bottom);
        make.left.equalTo(@0);
        make.width.equalTo(topView.mas_width);
        make.height.equalTo(@147);
    }];
    
    self.yuYueLable=[[UILabel alloc]init];
    self.yuYueLable.frame=CGRectMake(40, 45, frame.size.width - 50, 40);
    self.yuYueLable.textAlignment = NSTextAlignmentLeft;
    self.yuYueLable.text=@"全程7.8公里";
    self.yuYueLable.font=[UIFont systemFontOfSize:18];
    [self addSubview:self.yuYueLable];
    
    self.airPortLable=[[UILabel alloc]init];
    self.airPortLable.frame=CGRectMake(40, 45, frame.size.width -50, 30);
    self.airPortLable.textAlignment = NSTextAlignmentLeft;
    self.airPortLable.text=@"全程7.8公里";
    self.airPortLable.font=[UIFont systemFontOfSize:18];
    [self addSubview:self.airPortLable];
    
    self.airPortDateLable=[[UILabel alloc]init];
    self.airPortDateLable.frame=CGRectMake(40, 70, frame.size.width -50, 30);
    self.airPortDateLable.textAlignment = NSTextAlignmentLeft;
    self.airPortDateLable.text=@"全程7.8公里";
    self.airPortDateLable.textColor = [UIColor lightGrayColor];
    self.airPortDateLable.font=[UIFont systemFontOfSize:14];
    [self addSubview:self.airPortDateLable];
    
    self.yuYueAndAirPortImg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"clock"]];
    self.yuYueAndAirPortImg.frame = CGRectMake(15, 55, 20, 20);
    [self addSubview:self.yuYueAndAirPortImg];
    
    _bottomLb =[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.origin.y - 40, frame.size.width, 40)];
    _bottomLb.text = @"";
    _bottomLb.textColor = [UIColor lightGrayColor];
    _bottomLb.numberOfLines = 0;
//    bootomView.backgroundColor=[CYTSI colorWithHexString:@"#383635"];
    [self addSubview:_bottomLb];
    [_bottomLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView.mas_bottom);
        make.left.equalTo(@15);
        make.width.equalTo(@250);
    }];
    
   
}

-(void)setStartStr:(NSString *)startStr
{
    _startStr=startStr;
    
    self.addressView.startStr=_startStr;
}

-(void)setEndStr:(NSString *)endStr
{
    _endStr=endStr;
    
    self.addressView.endStr=_endStr;
}

- (void)setIsShake:(BOOL)isShake
{
    _isShake = isShake;
    if (isShake)
    {
        self.startDistanceLable.frame = CGRectMake(0, 40, self.frame.size.width, 81);
        self.allDistanceLable.hidden = YES;
    }
}

//关闭视图按钮点击事件
-(void)closeButtonClicked
{
    self.closeView();
}

-(void)setStateFlag:(NSString *)stateFlag{
    _stateFlag = stateFlag;
    if ([_stateFlag isEqualToString:@"0"]) {//及时单
//        titleLable.text = @"实时";
        self.startDistanceLable.hidden = NO;
        self.allDistanceLable.hidden = NO;
        self.yuYueLable.hidden= YES;
        self.airPortLable.hidden = YES;
        self.yuYueAndAirPortImg.hidden = YES;
        self.yuYueAndAirPortImg.image = [UIImage imageNamed:@"clock"];
        self.airPortDateLable.hidden = YES;
        self.startDistanceLable.frame=CGRectMake(0, 40, self.frame.size.width/2, 40);
        [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startDistanceLable.mas_bottom);
            make.left.equalTo(@0);
            make.width.mas_offset(self.frame.size.width);
            make.height.equalTo(@147);
        }];
        
    }else if ([_stateFlag isEqualToString:@"1"]){//预约单
//        self.titleLable.text = @"预约单";
        self.startDistanceLable.hidden = YES;
        self.allDistanceLable.hidden = YES;
        self.yuYueLable.hidden= NO;
        self.airPortLable.hidden = YES;
        self.yuYueAndAirPortImg.hidden = NO;
        self.airPortDateLable.hidden = YES;
        self.yuYueAndAirPortImg.image = [UIImage imageNamed:@"clock"];
        self.startDistanceLable.frame=CGRectMake(0, 40, self.frame.size.width/2, 40);
        [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startDistanceLable.mas_bottom);
            make.left.equalTo(@0);
            make.width.mas_offset(self.frame.size.width);
            make.height.equalTo(@147);
        }];
        
    }else if ([_stateFlag isEqualToString:@"2"]){//接机单
//        self.titleLable.text = @"接机单";
        self.startDistanceLable.hidden = YES;
        self.allDistanceLable.hidden = YES;
        self.yuYueLable.hidden= YES;
        self.airPortLable.hidden = NO;
        self.yuYueAndAirPortImg.hidden = NO;
        self.airPortDateLable.hidden = NO;
        self.yuYueAndAirPortImg.image = [UIImage imageNamed:@"plane"];
        self.startDistanceLable.frame=CGRectMake(0, 40, self.frame.size.width/2, 40);
        [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startDistanceLable.mas_bottom);
            make.left.equalTo(@0);
            make.width.mas_offset(self.frame.size.width);
            make.height.equalTo(@147);
        }];
       
    }else if ([_stateFlag isEqualToString:@"3"]){
        self.startDistanceLable.hidden = NO;
        self.allDistanceLable.hidden = NO;
        self.yuYueLable.hidden= YES;
        self.airPortLable.hidden = YES;
        self.yuYueAndAirPortImg.hidden = YES;
        self.yuYueAndAirPortImg.image = [UIImage imageNamed:@"clock"];
        self.airPortDateLable.hidden = YES;
        self.startDistanceLable.frame=CGRectMake(0, 40, self.frame.size.width/2, 40);
        [self.addressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.startDistanceLable.mas_bottom);
            make.left.equalTo(@0);
            make.width.mas_offset(self.frame.size.width);
            make.height.equalTo(@187);
        }];
    }
}

@end
