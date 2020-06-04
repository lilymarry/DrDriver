//
//  TopTypeView.m
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TopTypeView.h"

@implementation TopTypeView


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor colorWithRed:110/255.0 green:109/255.0 blue:124/255.0 alpha:1].CGColor;//阴影颜色
        self.layer.shadowOffset = CGSizeMake(0, 1);//偏移距离
        self.layer.shadowOpacity = 0.3;//不透明度
        self.layer.shadowRadius = 3;//半径
        [self creatView];
    }
    return self;
}
-(void)creatView{
    self.ITDriverBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.ITDriverBtn];
    [self.ITDriverBtn setTitle:@"用户预约" forState:(UIControlStateNormal)];
    [self.ITDriverBtn addTarget:self action:@selector(ITDriverAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.ITDriverBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.ITDriverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(self);
        make.width.mas_offset(DeviceWidth / 2);
    }];
    
    self.ITUserBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:self.ITUserBtn];
    [self.ITUserBtn addTarget:self action:@selector(ITUserAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.ITUserBtn setTintColor:[UIColor blackColor]];
    [self.ITUserBtn setTitle:@"我的行程" forState:(UIControlStateNormal)];
    [self.ITUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.bottom.equalTo(self);
        make.left.equalTo(self.ITDriverBtn.mas_right);
        make.width.mas_offset(DeviceWidth / 2);
    }];
}
-(void)ITDriverAction{
    [self.ITDriverBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.ITUserBtn setTintColor:[UIColor blackColor]];
    self.ITDriverActionBlock();
}
-(void)ITUserAction{
    [self.ITDriverBtn setTintColor:[UIColor blackColor]];
    [self.ITUserBtn setTintColor:[CYTSI colorWithHexString:@"#2488ef"]];
    self.ITUserActionBlock();
}

-(void)showITTopView{
    if (DeviceHeight>737) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 128, DeviceWidth, 50);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(0, 104, DeviceWidth, 50);
        }];
    }
}
-(void)hidenITTopView{
    if (DeviceHeight>737) {
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(DeviceWidth, 128, DeviceWidth, 50);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.frame = CGRectMake(DeviceWidth, 104, DeviceWidth, 50);
        }];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
