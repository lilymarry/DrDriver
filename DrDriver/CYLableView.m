//
//  CYLableView.m
//  DrDriver
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CYLableView.h"

@implementation CYLableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init
{
    if (self=[super init]) {
        
        [self setUpSubviews];
        
    }
    
    return self;
}

//设置子视图
-(void)setUpSubviews
{
    self.topLable=[[UILabel alloc]init];
    self.topLable.font=[UIFont systemFontOfSize:11];
    self.topLable.textColor=[CYTSI colorWithHexString:@"#666666"];
    self.topLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.topLable];
    [self.topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@16);
    }];
    
    self.bottomLable=[[UILabel alloc]init];
    self.bottomLable.font=[UIFont systemFontOfSize:18];
    self.bottomLable.textColor=[CYTSI colorWithHexString:@"#386ac6"];
    self.bottomLable.textAlignment=NSTextAlignmentCenter;
    [self addSubview:self.bottomLable];
    [self.bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@25);
    }];
    
}

@end
