//
//  RegisterProgressView.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterProgressView : UIView

@property (nonatomic,strong) UIButton * midleButton;
@property (nonatomic,strong) UIButton * midleBottomButton;
@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,strong) UIButton * leftBottomButton;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,strong) UIButton * rightBottomButton;
@property (nonatomic,strong) UIView * lineOneView;
@property (nonatomic,strong) UIView * lineTwoView;
@property (nonatomic,strong) UIView * lineThreeView;
@property (nonatomic,strong) UIView * lineFourView;

/**
 *  type 1：个人信息 2：车辆信息 3：证件上传
 */
-(void)setProgress:(int)type;

@end
