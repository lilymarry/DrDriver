//
//  PbulishLineView.m
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/14.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "PbulishLineView.h"



@implementation PbulishLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        UIView *bgiew = [[UIView alloc] init];
        bgiew.backgroundColor = [UIColor whiteColor];
        bgiew.layer.cornerRadius = 10;
        bgiew.layer.masksToBounds = YES;
        [self addSubview:bgiew];
        [bgiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(30);
            make.right.equalTo(self.mas_right).offset(-30);
            make.height.mas_equalTo(230);
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY).mas_offset(-10);
        }];
        
        UILabel *bgLabel = [[UILabel alloc] init];
        bgLabel.text = @"发布方式";
        bgLabel.textColor = [UIColor whiteColor];
        bgLabel.font = [UIFont systemFontOfSize:15];
        bgLabel.textAlignment = NSTextAlignmentCenter;
        bgLabel.backgroundColor = CATECOLOR_SELECTED;
        bgLabel.layer.cornerRadius = 20;
        bgLabel.layer.masksToBounds = YES;
        [self addSubview:bgLabel];
     
        [bgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(bgiew.mas_left).offset(60);
          make.right.equalTo(bgiew.mas_right).offset(-60);
          make.height.mas_equalTo(40);
          make.centerY.equalTo(bgiew.mas_top);
        }];
        
        UIButton *cancelBtn = [[UIButton alloc] init];
        [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"" forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(24);
            make.bottom.mas_equalTo(bgiew.mas_top).mas_offset(-24);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
        }];
        
        UIView *lineOneView = [[UIView alloc] init];
        lineOneView.backgroundColor = CATECOLOR_SELECTED;
        lineOneView.layer.cornerRadius = 10;
        lineOneView.layer.masksToBounds = YES;
        [bgiew addSubview:lineOneView];
        lineOneView.userInteractionEnabled = YES;
        UITapGestureRecognizer *lineOneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickLineOneView)];
        [lineOneView addGestureRecognizer:lineOneTap];
        [lineOneView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(bgiew.mas_left).offset(20);
         make.right.equalTo(bgiew.mas_right).offset(-20);
         make.height.mas_equalTo(60);
         make.top.equalTo(bgiew.mas_top).mas_offset(50);
        }];
        UILabel *lineOneLb = [[UILabel alloc] init];
        lineOneLb.text = @"固定线路";
        lineOneLb.font = [UIFont systemFontOfSize:15];
        lineOneLb.textColor = [UIColor whiteColor];
        [lineOneView addSubview:lineOneLb];
        [lineOneLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineOneView.mas_left).offset(15);
            make.top.equalTo(lineOneView.mas_top).mas_offset(10);
        }];
        
        UILabel *lineOneDetailLb = [[UILabel alloc] init];
        lineOneDetailLb.text = @"从系统设定的热门线路中选择";
        lineOneDetailLb.font = [UIFont systemFontOfSize:12];
        lineOneDetailLb.textColor = [UIColor whiteColor];
        [lineOneView addSubview:lineOneDetailLb];
        [lineOneDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineOneLb.mas_left);
            make.top.equalTo(lineOneLb.mas_bottom).mas_offset(5);
        }];
        
        UIImageView * lineOneImg = [[UIImageView alloc] init];
        lineOneImg.image = [UIImage imageNamed:@"back_right"];
        [lineOneView addSubview:lineOneImg];
        [lineOneImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(24);
            make.centerY.mas_equalTo(lineOneView.mas_centerY);
            make.right.mas_equalTo(lineOneView.mas_right).mas_offset(-15);
        }];
        
        UIView *lineTwoView = [[UIView alloc] init];
           lineTwoView.backgroundColor = CATECOLOR_SELECTED;
           lineTwoView.layer.cornerRadius = 10;
           lineTwoView.layer.masksToBounds = YES;
           [bgiew addSubview:lineTwoView];
           lineTwoView.userInteractionEnabled = YES;
           UITapGestureRecognizer *lineTwoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCLickLineTwoView)];
           [lineTwoView addGestureRecognizer:lineTwoTap];
           [lineTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lineOneView.mas_left);
            make.right.equalTo(lineOneView.mas_right);
            make.height.mas_equalTo(60);
            make.top.equalTo(lineOneView.mas_bottom).mas_offset(30);
           }];
           UILabel *lineTwoLb = [[UILabel alloc] init];
           lineTwoLb.text = @"自定义线路";
           lineTwoLb.font = [UIFont systemFontOfSize:15];
           lineTwoLb.textColor = [UIColor whiteColor];
           [lineTwoView addSubview:lineTwoLb];
           [lineTwoLb mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(lineTwoView.mas_left).offset(15);
               make.top.equalTo(lineTwoView.mas_top).mas_offset(10);
           }];
           
           UILabel *lineTwoDetailLb = [[UILabel alloc] init];
           lineTwoDetailLb.text = @"可以任意设置行程起点和终点";
           lineTwoDetailLb.font = [UIFont systemFontOfSize:12];
           lineTwoDetailLb.textColor = [UIColor whiteColor];
           [lineTwoView addSubview:lineTwoDetailLb];
           [lineTwoDetailLb mas_makeConstraints:^(MASConstraintMaker *make) {
               make.left.equalTo(lineTwoLb.mas_left);
               make.top.equalTo(lineTwoLb.mas_bottom).mas_offset(5);
           }];
            UIImageView * lineTwoImg = [[UIImageView alloc] init];
            lineTwoImg.image = [UIImage imageNamed:@"back_right"];
            [lineTwoView addSubview:lineTwoImg];
            [lineTwoImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(24);
                make.centerY.mas_equalTo(lineTwoView.mas_centerY);
                make.right.mas_equalTo(lineTwoView.mas_right).mas_offset(-15);
            }];
    }
    
    return self;
}


- (void)didClickCancelBtn{
  [self hiddenView];
}

- (void)didCLickLineOneView{
    self.lineOneBlock();
    [self hiddenView];
}

- (void)didCLickLineTwoView{
    self.lineTwoBlick();
    [self hiddenView];
}

-(void)showView{
   UIWindow * window=[UIApplication sharedApplication].delegate.window;
   [window addSubview:self];
}

- (void)hiddenView{
    
    [self removeFromSuperview];
    
}

@end
