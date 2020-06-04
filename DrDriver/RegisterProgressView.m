//
//  RegisterProgressView.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "RegisterProgressView.h"

#define space DeviceWidth*0.256

@implementation RegisterProgressView

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
        
        [self creatMainView];//创建主要视图
        
    }
    
    return self;
}

//创建主要视图
-(void)creatMainView
{
    self.midleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.midleButton setTitle:@"2" forState:UIControlStateNormal];
    self.midleButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.midleButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.midleButton setTitleColor:[CYTSI colorWithHexString:@"#386ac6"] forState:UIControlStateSelected];
    [self.midleButton setBackgroundImage:[UIImage imageNamed:@"progress_normal"] forState:UIControlStateNormal];
    [self.midleButton setBackgroundImage:[UIImage imageNamed:@"progress_selected"] forState:UIControlStateSelected];
//    self.midleButton.enabled=NO;
    [self addSubview:self.midleButton];
    [self.midleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@12);
        make.width.and.height.equalTo(@25);
    }];
    
    self.midleBottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.midleBottomButton setTitle:@"车辆信息" forState:UIControlStateNormal];
    self.midleBottomButton.titleLabel.font=[UIFont systemFontOfSize:11];
    [self.midleBottomButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.midleBottomButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateSelected];
//    self.midleBottomButton.enabled=NO;
    [self addSubview:self.midleBottomButton];
    [self.midleBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.midleButton.mas_bottom).with.offset(3);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    
    self.leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setTitle:@"1" forState:UIControlStateNormal];
    self.leftButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.leftButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[CYTSI colorWithHexString:@"#386ac6"] forState:UIControlStateSelected];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"progress_normal"] forState:UIControlStateNormal];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"progress_selected"] forState:UIControlStateSelected];
//    self.leftButton.enabled=NO;
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.midleButton.mas_left).with.offset(-space);
        make.top.equalTo(@12);
        make.width.and.height.equalTo(@25);
    }];
    
    self.leftBottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftBottomButton setTitle:@"个人信息" forState:UIControlStateNormal];
    self.leftBottomButton.titleLabel.font=[UIFont systemFontOfSize:11];
    [self.leftBottomButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.leftBottomButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateSelected];
//    self.leftBottomButton.enabled=NO;
    [self addSubview:self.leftBottomButton];
    [self.leftBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftButton.mas_centerX);
        make.top.equalTo(self.leftButton.mas_bottom).with.offset(3);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    
    self.rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitle:@"3" forState:UIControlStateNormal];
    self.rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.rightButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[CYTSI colorWithHexString:@"#386ac6"] forState:UIControlStateSelected];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"progress_normal"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"progress_selected"] forState:UIControlStateSelected];
//    self.rightButton.enabled=NO;
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midleButton.mas_right).with.offset(space);
        make.top.equalTo(@12);
        make.width.and.height.equalTo(@25);
    }];
    
    self.rightBottomButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBottomButton setTitle:@"证件上传" forState:UIControlStateNormal];
    self.rightBottomButton.titleLabel.font=[UIFont systemFontOfSize:11];
    [self.rightBottomButton setTitleColor:[CYTSI colorWithHexString:@"#aaaaaa"] forState:UIControlStateNormal];
    [self.rightBottomButton setTitleColor:[CYTSI colorWithHexString:@"#333333"] forState:UIControlStateSelected];
//    self.rightBottomButton.enabled=NO;
    [self addSubview:self.rightBottomButton];
    [self.rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightButton.mas_centerX);
        make.top.equalTo(self.rightButton.mas_bottom).with.offset(3);
        make.width.equalTo(@50);
        make.height.equalTo(@16);
    }];
    
    self.lineOneView=[[UIView alloc]init];
    self.lineOneView.backgroundColor=[CYTSI colorWithHexString:@"#aaaaaa"];
    [self addSubview:self.lineOneView];
    [self.lineOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton.mas_centerY);
        make.height.equalTo(@2);
        make.left.equalTo(self.leftButton.mas_right);
        make.width.mas_equalTo(space/2);
    }];
    
    self.lineTwoView=[[UIView alloc]init];
    self.lineTwoView.backgroundColor=[CYTSI colorWithHexString:@"#aaaaaa"];
    [self addSubview:self.lineTwoView];
    [self.lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftButton.mas_centerY);
        make.height.equalTo(@2);
        make.left.equalTo(self.lineOneView.mas_right);
        make.width.mas_equalTo(space/2);
    }];
    
    self.lineThreeView=[[UIView alloc]init];
    self.lineThreeView.backgroundColor=[CYTSI colorWithHexString:@"#aaaaaa"];
    [self addSubview:self.lineThreeView];
    [self.lineThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midleButton.mas_centerY);
        make.height.equalTo(@2);
        make.left.equalTo(self.midleButton.mas_right);
        make.width.mas_equalTo(space/2);
    }];
    
    self.lineFourView=[[UIView alloc]init];
    self.lineFourView.backgroundColor=[CYTSI colorWithHexString:@"#aaaaaa"];
    [self addSubview:self.lineFourView];
    [self.lineFourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.midleButton.mas_centerY);
        make.height.equalTo(@2);
        make.left.equalTo(self.lineThreeView.mas_right);
        make.width.mas_equalTo(space/2);
    }];
    
    UIView * bigView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, self.frame.size.height)];
    [self addSubview:bigView];
    
}

/**
 *  type 1：个人信息 2：车辆信息 3：证件上传
 */
-(void)setProgress:(int)type
{
    switch (type) {
        case 1:
        {
            self.leftButton.selected=YES;
            self.leftBottomButton.selected=YES;
            self.lineOneView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
        }
            break;
        case 2:
        {
            self.leftButton.selected=YES;
            self.leftBottomButton.selected=YES;
            self.lineOneView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
            
            self.midleButton.selected=YES;
            self.midleBottomButton.selected=YES;
            self.lineTwoView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
            self.lineThreeView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
        }
            break;
        case 3:
        {
            self.leftButton.selected=YES;
            self.leftBottomButton.selected=YES;
            self.lineOneView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
            
            self.midleButton.selected=YES;
            self.midleBottomButton.selected=YES;
            self.lineTwoView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
            self.lineThreeView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
            
            self.rightButton.selected=YES;
            self.rightBottomButton.selected=YES;
            self.lineFourView.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
        }
            break;
        default:
            break;
    }
}

@end
