//
//  SLTripDetailTableViewCell.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "GoToWorkTableViewCell.h"
#import "SLStudent.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "CYAlertView.h"



@interface GoToWorkTableViewCell()
@property (nonatomic, strong, readwrite) UILabel *name_Label;//孩子姓名
@property (nonatomic, strong, readwrite) UILabel *home_Label;//家位置
@property (nonatomic, strong, readwrite) UILabel *home_detial_Label;//家详细位置
@property (nonatomic, strong, readwrite) UILabel *school_Label;//学校位置
@property (nonatomic, strong, readwrite) UILabel *school_detial_Label;//学校详细位置
@property (nonatomic, strong, readwrite) UILabel *time_Label;//时间
@property (nonatomic, strong, readwrite) UILabel *statu_Label;//状态
@property (nonatomic, copy, readwrite) NSString *parent_phone;//状态

@property (nonatomic, strong, readwrite) UILabel *passLate_label;//状态
@property (nonatomic, strong, readwrite)UIButton *navBtn;//导航图片
@property (nonatomic, strong, readwrite)UITapGestureRecognizer *passLabelTap;//点击乘客迟到手势
@property (nonatomic, strong, readwrite) CYAlertView * singleAlertView;//按钮弹出视图
@property (nonatomic, assign, readwrite)int timeInt;//乘客迟到剩余时间

@end

@implementation GoToWorkTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
   
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TABLEVIEW_BACKCOLOR;
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.top.mas_equalTo(self.mas_top);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-10);
        }];
        UIImageView *childImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"child"]];
        [bgView addSubview:childImageView];
        [childImageView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.and.height.mas_equalTo(20);
             make.left.mas_equalTo(bgView.mas_left).mas_offset(15);
             make.top.mas_equalTo(bgView.mas_top).mas_equalTo(15);
                 }];
        UILabel *child_name_label = [[UILabel alloc] init];
        child_name_label.textColor = [UIColor darkGrayColor];
        child_name_label.font = [UIFont systemFontOfSize:15];
        child_name_label.text = @"---";
        [bgView addSubview:child_name_label];
        [child_name_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(childImageView.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(childImageView.mas_centerY);
        }];
        self.name_Label = child_name_label;
//        //更多的bTN
//        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
////        btn.frame = CGRectMake(DeviceWidth - 62, 8, 50, 24);
//        btn.backgroundColor = [UIColor whiteColor];
//        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//        btn.titleLabel.font = [UIFont systemFontOfSize:15];
////        [btn addTarget:self action:@selector(noreBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [bgView addSubview:btn];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//           make.left.mas_equalTo(child_name_label.mas_right).mas_offset(20);
//           make.centerY.mas_equalTo(child_name_label.mas_centerY);
//            make.width.mas_equalTo(80);
//            make.height.mas_equalTo(30);
//        }];
//        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        self.btn = btn;
        UIButton *telButton = [[UIButton alloc] init];
        [telButton setTitle:@"联系乘客" forState:UIControlStateNormal];
        [telButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
        [telButton setTitleColor:CATECOLOR_SELECTED forState:UIControlStateNormal];
        [telButton addTarget:self action:@selector(didClickTelButton) forControlEvents:UIControlEventTouchUpInside];
        telButton.titleLabel.font = [UIFont systemFontOfSize:15];
        telButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -13, -5, 0);
        [bgView addSubview:telButton];
        [telButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerY.mas_equalTo(child_name_label.mas_centerY);
          make.right.mas_equalTo(bgView.mas_right).mas_offset(-15);
          make.width.mas_equalTo(80);
          make.height.mas_equalTo(30);
        }];
        self.telButton = telButton;
        UIView *lineView1 = [[UIView alloc] init];
        lineView1.backgroundColor = TABLEVIEW_BACKCOLOR;
        [bgView addSubview:lineView1];
        [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
              make.left.mas_equalTo(childImageView.mas_left);
              make.right.mas_equalTo(telButton.mas_right);
              make.top.mas_equalTo(telButton.mas_bottom).mas_offset(10);
              make.height.mas_equalTo(1);
          }];
        UIButton *navBtn = [[UIButton alloc] init];
        [navBtn setImage:[UIImage imageNamed:@"导航q"] forState:UIControlStateNormal];
        [navBtn addTarget:self action:@selector(mapViewDidTap) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:navBtn];
        [navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.and.height.mas_equalTo(45);
         make.right.mas_equalTo(lineView1.mas_right);
         make.top.mas_equalTo(lineView1.mas_bottom).mas_offset(30);
        }];
        self.navBtn = navBtn;
        UIImageView *homeImg = [[UIImageView alloc] init];
        homeImg.image = [UIImage imageNamed:@"坐标-起始q"];
        homeImg.contentMode = UIViewContentModeScaleAspectFit;
        [bgView addSubview:homeImg];
        [homeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(20);
            make.left.mas_equalTo(bgView.mas_left).mas_offset(15);
            make.top.mas_equalTo(lineView1.mas_bottom).mas_offset(10);
        }];
        UILabel *homeLable = [[UILabel alloc] init];
        homeLable.text = @"--";
        homeLable.font = [UIFont systemFontOfSize:15];
        homeLable.textColor = [UIColor darkGrayColor];
        [bgView addSubview:homeLable];
        [homeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(homeImg.mas_centerY);
            make.left.mas_equalTo(homeImg.mas_right).mas_offset(10);
            make.right.mas_equalTo(bgView.mas_right).mas_offset(-10);
        }];
        self.home_Label = homeLable;
        UILabel *homeDetialLable = [[UILabel alloc] init];
        homeDetialLable.text = @"--------------";
        homeDetialLable.font = [UIFont systemFontOfSize:12];
        homeDetialLable.textColor = [UIColor grayColor];
        [bgView addSubview:homeDetialLable];
        [homeDetialLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(homeLable.mas_bottom).mas_offset(3);
            make.left.mas_equalTo(homeLable.mas_left);
            make.right.mas_equalTo(navBtn.mas_left);
        }];
        self.home_detial_Label = homeDetialLable;
        UIImageView *schoolImg = [[UIImageView alloc] init];
        schoolImg.image = [UIImage imageNamed:@"坐标-终点q"];
        [bgView addSubview:schoolImg];
        [schoolImg mas_makeConstraints:^(MASConstraintMaker *make) {
               make.width.and.height.mas_equalTo(20);
               make.left.mas_equalTo(bgView.mas_left).mas_offset(15);
               make.top.mas_equalTo(homeDetialLable.mas_bottom).mas_offset(5);
           }];
        UILabel *schoolLable = [[UILabel alloc] init];
        schoolLable.text = @"---";
        schoolLable.font = [UIFont systemFontOfSize:15];
        schoolLable.textColor = [UIColor darkGrayColor];
        [bgView addSubview:schoolLable];
        [schoolLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(homeDetialLable.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(schoolImg.mas_right).mas_offset(10);
            make.right.mas_equalTo(bgView.mas_right).mas_offset(-15);
        }];
        self.school_Label = schoolLable;
        UILabel *schoolDetialLable = [[UILabel alloc] init];
        schoolDetialLable.text = @"---------";
        schoolDetialLable.font = [UIFont systemFontOfSize:12];
        schoolDetialLable.textColor = [UIColor grayColor];
        [bgView addSubview:schoolDetialLable];
        [schoolDetialLable mas_makeConstraints:^(MASConstraintMaker *make) {
              make.top.mas_equalTo(schoolLable.mas_bottom).mas_offset(3);
              make.left.mas_equalTo(homeLable.mas_left);
              make.right.mas_equalTo(homeLable.mas_right);
          }];
        self.school_detial_Label = schoolDetialLable;
        UIImageView *inscoolImg = [[UIImageView alloc] init];
        inscoolImg.image = [UIImage imageNamed:@"time"];
        [bgView addSubview:inscoolImg];
        [inscoolImg mas_makeConstraints:^(MASConstraintMaker *make) {
             make.width.and.height.mas_equalTo(20);
             make.left.mas_equalTo(bgView.mas_left).mas_offset(15);
             make.top.mas_equalTo(schoolDetialLable.mas_bottom).mas_offset(15);
          }];
        UILabel *in_school_Lable = [[UILabel alloc] init];
        in_school_Lable.text = @"上班时间";
        in_school_Lable.font = [UIFont systemFontOfSize:15];
        in_school_Lable.textColor = [UIColor darkGrayColor];
        [bgView addSubview:in_school_Lable];
        [in_school_Lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(inscoolImg.mas_centerY);
            make.left.mas_equalTo(inscoolImg.mas_right).mas_offset(10);
        }];
        UILabel *timeLable = [[UILabel alloc] init];
        timeLable.text = @"---";
        timeLable.font = [UIFont systemFontOfSize:15];
        timeLable.textColor = [UIColor darkGrayColor];
        [bgView addSubview:timeLable];
        [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.mas_equalTo(inscoolImg.mas_centerY);
              make.right.mas_equalTo(lineView1.mas_right);
        }];
        self.time_Label = timeLable;
        UIImageView *statuImg = [[UIImageView alloc] init];
        statuImg.image = [UIImage imageNamed:@"zhuangtai"];
        [bgView addSubview:statuImg];
        [statuImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(20);
            make.left.mas_equalTo(bgView.mas_left).mas_offset(15);
            make.top.mas_equalTo(inscoolImg.mas_bottom).mas_offset(15);
         }];
       UILabel *statuLable = [[UILabel alloc] init];
       statuLable.text = @"当前状态";
       statuLable.font = [UIFont systemFontOfSize:15];
       statuLable.textColor = [UIColor darkGrayColor];
        [bgView addSubview:statuLable];
        [statuLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(statuImg.mas_centerY);
            make.left.mas_equalTo(statuImg.mas_right).mas_offset(10);
      }];
       UILabel *statu_Lable = [[UILabel alloc] init];
       statu_Lable.text = @"---";
       statu_Lable.font = [UIFont systemFontOfSize:15];
       statu_Lable.textColor = CATECOLOR_SELECTED;
        [bgView addSubview:statu_Lable];
        [statu_Lable mas_makeConstraints:^(MASConstraintMaker *make) {
              make.centerY.mas_equalTo(statuImg.mas_centerY);
              make.right.mas_equalTo(lineView1.mas_right);
        }];
        self.statu_Label = statu_Lable;
      UIButton *statuButton = [[UIButton alloc] init];
      [statuButton setTitle:@"--------" forState:UIControlStateNormal];
      [statuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      [statuButton setBackgroundColor:CATECOLOR_SELECTED];
        statuButton.titleLabel.font = [UIFont systemFontOfSize:15];
      [statuButton addTarget:self action:@selector(didClickStatusButton) forControlEvents:UIControlEventTouchUpInside];
        statuButton.layer.cornerRadius = 10;
        statuButton.layer.masksToBounds = YES;
      [bgView addSubview:statuButton];
        self.statu_button = statuButton;
        [statuButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statuImg.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(lineView1.mas_left);
            make.right.mas_equalTo(lineView1.mas_right);
            make.height.mas_equalTo(44);
        }];
        
       self.passLate_label = [[UILabel alloc] init];
       self.passLate_label.text = @"加载中...";
       self.passLate_label.textAlignment = NSTextAlignmentCenter;
       self.passLate_label.textColor = [UIColor whiteColor];
       [self.passLate_label setBackgroundColor:[UIColor orangeColor]];
       self.passLate_label.font = [UIFont systemFontOfSize:15];
       self.passLate_label.layer.cornerRadius = 10;
       self.passLate_label.layer.masksToBounds = YES;
    
    }
    
    return self;
}

- (void)setStudent:(SLStudent *)student{
    _student = student;
//    NSLog(@"student ===== %@",_student);
    if ([_student.order_state intValue] > 0 && [_student.order_state intValue] < 5) {
        self.navBtn.hidden = NO;
    }else{
        self.navBtn.hidden = YES;
    }
    
    //先移除手势在添加
    [self.passLate_label removeFromSuperview];
    self.statu_button.hidden = NO;
    self.name_Label.text = _student.m_name;
    self.home_Label.text = _student.start_name;
    self.home_detial_Label.text = _student.start_address;
    self.school_Label.text = _student.end_name;
    self.school_detial_Label.text = _student.end_address;
//order_state订单状态，0：司机未发车，1司机未到达，2未上车，3已上车，4行程中，5司机已送达，6家长确认送达，7司机取消，8乘客取消 9陪伴中
    if ([_student.order_state isEqualToString:@"0"]) {
        [self.statu_button setTitle:@"去接乘客" forState:UIControlStateNormal];
    }else if ([_student.order_state isEqualToString:@"1"]){
        [self.statu_button setTitle:@"到达上车点" forState:UIControlStateNormal];
    }else if ([_student.order_state isEqualToString:@"2"]){
        [self.statu_button setTitle:@"乘客上车" forState:UIControlStateNormal];
    }else if ([_student.order_state isEqualToString:@"3"]){
        [self.statu_button setTitle:@"开始行程" forState:UIControlStateNormal];
    }else if ([_student.order_state isEqualToString:@"4"]){
        [self.statu_button setTitle:@"安全送达" forState:UIControlStateNormal];
    }else if ([_student.order_state isEqualToString:@"5"]){
        self.statu_button.hidden = YES;
    }else if ([_student.order_state isEqualToString:@"7"] || [_student.order_state isEqualToString:@"8"] || [_student.order_state isEqualToString:@"6"]){//7司机取消 8乘客取消
        self.statu_button.hidden = YES;
    }
    self.statu_Label.text = _student.order_state_name;
    
    self.time_Label.text = _student.work_time;
    self.parent_phone = _student.passenger_phone;
}


#pragma mark - noreBtnClick

- (void)noreBtnClick{
    if ([self.delagte respondsToSelector:@selector(moreBtnClick:)]&&self.delagte) {
        [self.delagte moreBtnClick:self.student.order_id];
    }
}

- (void)didClickTelButton{
    if (self.delagte && [self.delagte respondsToSelector:@selector(tableViewCell:clickTellPhoneButton:)]) {
        [self.delagte tableViewCell:self clickTellPhoneButton:self.parent_phone];
    }
}

//点击按钮刷新状态
- (void)didClickStatusButton{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isWork"] isEqualToString:@"n"]) {
        [CYTSI otherShowTostWithString:@"请回到首页点击开始上班"];
        return;
    }
    
    if ([self.statu_button.titleLabel.text isEqualToString:@"去接乘客"] || [self.statu_button.titleLabel.text isEqualToString:@"开始行程"]) {
        if (self.delagte && [self.delagte respondsToSelector:@selector(otherStateClickMapNavButton:)]) {
            [self.delagte otherStateClickMapNavButton:@{@"start_lat":self.student.start_lat,@"start_lng":self.student.start_lng,@"end_lat":self.student.end_lat,@"end_lng":self.student.end_lng,@"state":self.student.order_state}];
        };
    }
    
    
    if ([self.statu_button.titleLabel.text isEqualToString:@"乘客上车"]) {
        
         if (self.delagte && [self.delagte respondsToSelector:@selector(passengerTakeDrive:)]) {
             
             [self.delagte passengerTakeDrive:self.student];
             
         }
         return;
     }
    
    if ([self.statu_button.titleLabel.text isEqualToString:@"已完成"]) {
        return;
    }
    if ([self.statu_button.titleLabel.text isEqualToString:@"安全送达"]) {
        //调取摄像机
        if (self.delagte && [self.delagte respondsToSelector:@selector(tableViewCell:clickPhotoButton:)]) {
            [self.delagte tableViewCell:self clickPhotoButton:self.student];
        }
        return;
    }
    
    if (self.delagte && [self.delagte respondsToSelector:@selector(tableViewCell:clickStateButton:)]) {
        [self.delagte tableViewCell:self clickStateButton:self.student];
    }
    
    
}

- (void)mapViewDidTap{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isWork"] isEqualToString:@"n"]) {
        [CYTSI otherShowTostWithString:@"请回到首页点击开始上班"];
        return;
    }
    
    if (self.delagte && [self.delagte respondsToSelector:@selector(clickMapNavButton:)]) {
        [self.delagte clickMapNavButton:@{@"start_lat":self.student.start_lat,@"start_lng":self.student.start_lng,@"end_lat":self.student.end_lat,@"end_lng":self.student.end_lng,@"state":self.student.order_state}];
    }
}


@end

