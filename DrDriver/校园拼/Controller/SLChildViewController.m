//
//  SLChildViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/16.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLChildViewController.h"
#import "SLStudent.h"
#include "WeekModel.h"
@interface SLChildViewController ()
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headerView;

@property (strong, nonatomic, readwrite) UILabel *timeLabel;
@property (strong, nonatomic, readwrite) UILabel *statuLabel;
@property (strong, nonatomic, readwrite) UILabel *typeLabel;

//学生信息
@property (strong, nonatomic, readwrite) UILabel *child_name_Label;
@property (strong, nonatomic, readwrite) UILabel *child_sex_Label;
@property (strong, nonatomic, readwrite) UILabel *school_Label;
@property (strong, nonatomic, readwrite) UILabel *school_detail_Label;
@property (strong, nonatomic, readwrite) UILabel *home_Label;
@property (strong, nonatomic, readwrite) UILabel *home_detial_Label;

//接送时间
@property (strong, nonatomic, readwrite) UILabel *in_Mon_Label;
@property (strong, nonatomic, readwrite) UILabel *in_Tues_Label;
@property (strong, nonatomic, readwrite) UILabel *in_Wednes_Label;
@property (strong, nonatomic, readwrite) UILabel *in_Thurs_Label;
@property (strong, nonatomic, readwrite) UILabel *in_Fri_Label;

@property (strong, nonatomic, readwrite) UILabel *out_Mon_Label;
@property (strong, nonatomic, readwrite) UILabel *out_Tues_Label;
@property (strong, nonatomic, readwrite) UILabel *out_Wednes_Label;
@property (strong, nonatomic, readwrite) UILabel *out_Thurs_Label;
@property (strong, nonatomic, readwrite) UILabel *out_Fri_Label;

//孩子照片
@property (strong, nonatomic, readwrite) UIImageView *chilImageView;
@property (strong, nonatomic, readwrite) SLStudent *studentDetial;

@end

@implementation SLChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"合约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpTableView];
    [self setUpNav];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self creatHttp];
}

//请求数据
- (void)creatHttp
{
    __weak typeof(self) weakSelf = self;
    NSString *urlStr= @"";
    NSDictionary *dict = @{};
       if ([self.whichType isEqualToString:@"0"]) {
           urlStr = DRIVER_SCHOOLBUS_CHILD_DETAIL;

       }else{
           urlStr = DRIVER_WORK_PASSENGER_DETAIL;
       }
    [AFRequestManager postRequestWithUrl:urlStr params:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], @"contract_id": self.contract_id, @"detail_id": self.student.detail_id } tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"DRIVER_SCHOOLBUS_CONTRACT_DETAIL --- %@", responseObject[@"data"]);

        weakSelf.studentDetial = [SLStudent mj_objectWithKeyValues:responseObject[@"data"]];
        dispatch_async(dispatch_get_main_queue(), ^{//主线程刷新ui
                           weakSelf.timeLabel.text = weakSelf.timeStr;
                       if ([weakSelf.statu isEqualToString:@"2"]) {
                               weakSelf.statuLabel.textColor = CATECOLOR_SELECTED;
                           }else{
                               weakSelf.statuLabel.textColor = [UIColor grayColor];
                           }
                           weakSelf.statuLabel.text = weakSelf.statuStr;
        
                           if ([weakSelf.studentDetial.child_sex isEqualToString:@"1"]) {//男
                               weakSelf.child_sex_Label.text = @"男";
                           } else {
                               weakSelf.child_sex_Label.text = @"女";
                           }
            if ([weakSelf.student.m_name isEqualToString:@""] || weakSelf.student.m_name == nil) {
                          weakSelf.child_name_Label.text = weakSelf.student.child_name;
                          weakSelf.school_Label.text = weakSelf.studentDetial.school_name;
                          weakSelf.school_detail_Label.text = weakSelf.studentDetial.school_address;
                          weakSelf.home_Label.text = weakSelf.studentDetial.home_name;
                          weakSelf.home_detial_Label.text = weakSelf.studentDetial.home_address;
                          weakSelf.chilImageView.hidden = NO;
                     }else{
                          weakSelf.child_name_Label.text = weakSelf.student.m_name;
                          weakSelf.school_Label.text = weakSelf.studentDetial.company_name;
                          weakSelf.school_detail_Label.text = weakSelf.studentDetial.company_address;
                          weakSelf.home_Label.text = weakSelf.studentDetial.home_name;
                          weakSelf.home_detial_Label.text = weakSelf.studentDetial.home_address;
                         weakSelf.chilImageView.hidden = YES;
                     }
                          
                           NSArray <WeekModel *> *weekArray = weakSelf.studentDetial.week_time;
                           for (int i = 0; i < weekArray.count; i++) {
                               switch (i) {
                                   case 0: {
                                       weakSelf.in_Mon_Label.text = weekArray[i].start_time;
                                       weakSelf.out_Mon_Label.text = weekArray[i].end_time;
                                   }
                                   break;
                                   case 1: {
                                       weakSelf.in_Tues_Label.text = weekArray[i].start_time;
                                       weakSelf.out_Tues_Label.text = weekArray[i].end_time;
                                   }
                                   break;
                                   case 2: {
                                       weakSelf.in_Wednes_Label.text = weekArray[i].start_time;
                                       weakSelf.out_Wednes_Label.text = weekArray[i].end_time;
                                   }
                                   break;
                                   case 3: {
                                       weakSelf.in_Thurs_Label.text = weekArray[i].start_time;
                                       weakSelf.out_Thurs_Label.text = weekArray[i].end_time;
                                   }
                                   break;
                                   case 4: {
                                       weakSelf.in_Fri_Label.text = weekArray[i].start_time;
                                       weakSelf.out_Fri_Label.text = weekArray[i].end_time;
                                   }
                                   break;
                                   default:
                                       break;
                               }
                           }
            weakSelf.typeLabel.text = [NSString stringWithFormat:@"用车方式：%@",weakSelf.typeStr];
            [weakSelf.chilImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.studentDetial.child_pic] placeholderImage:[UIImage imageNamed:@"defaut"]];
            [weakSelf.tableView reloadData];
                       });
    } failure:^(NSError *error) {
//        CYLog(@"error ===== %@", error)
    }];
}

- (void)didClickTelButton {

    if (self.studentDetial.passenger_phone == nil ||[self.studentDetial.passenger_phone isEqualToString:@""]) {
            if (self.studentDetial.parent_phone) {
                [CYTSI callPhoneStr:self.studentDetial.parent_phone withVC:self];
            }
    }else{
        if (self.studentDetial.passenger_phone) {
            [CYTSI callPhoneStr:self.studentDetial.passenger_phone withVC:self];
        }
    }
    
 
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self.view addSubview:self.tableView];
    //tableViw的首部
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 650)];
    self.headerView.backgroundColor = TABLEVIEW_BACKCOLOR;
    //    日期的view
    UIView *timeView = [[UIView alloc] init];
    timeView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left);
        make.right.mas_equalTo(self.headerView.mas_right);
        make.top.mas_equalTo(self.headerView.mas_top);
        make.height.mas_equalTo(95);
    }];
    UIView *timeLineView = [[UIView alloc] init];
    timeLineView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [timeView addSubview:timeLineView];
    [timeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeView.mas_left).mas_offset(15);
        make.right.mas_equalTo(timeView.mas_right).mas_offset(-15);
        make.centerY.mas_equalTo(timeView.mas_centerY);
        make.height.mas_equalTo(1);
    }];
    UIImageView *canlnderImg = [[UIImageView alloc] init];
    canlnderImg.image = [UIImage imageNamed:@"riqi"];
    [timeView addSubview:canlnderImg];
    [canlnderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(25);
        make.left.mas_equalTo(timeView.mas_left).mas_offset(15);
        make.top.mas_equalTo(timeView.mas_top).mas_offset(10);
    }];
    UILabel *timeNameLable = [[UILabel alloc] init];
    timeNameLable.text = @"起止日期";
    timeNameLable.font = [UIFont systemFontOfSize:15];
    timeNameLable.textColor = [UIColor darkGrayColor];
    [timeView addSubview:timeNameLable];
    [timeNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(canlnderImg.mas_centerY);
        make.left.mas_equalTo(canlnderImg.mas_right).mas_offset(10);
    }];
    UILabel *timeLable = [[UILabel alloc] init];
    timeLable.text = @"------";
    timeLable.font = [UIFont systemFontOfSize:15];
    timeLable.textColor = [UIColor darkGrayColor];
    [timeView addSubview:timeLable];
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(canlnderImg.mas_left);
        make.top.mas_equalTo(timeLineView.mas_bottom).mas_offset(10);
    }];
    self.timeLabel = timeLable;
    UILabel *statuLabel = [[UILabel alloc] init];
    statuLabel.text = @"---";
    statuLabel.font = [UIFont systemFontOfSize:15];
    statuLabel.textColor = CATECOLOR_SELECTED;
    [timeView addSubview:statuLabel];
    [statuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(timeLineView.mas_right);
        make.top.mas_equalTo(timeLineView.mas_bottom).mas_offset(10);
    }];
    self.statuLabel = statuLabel;
    //孩子信息
    UIView *chilView = [[UIView alloc] init];
    chilView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:chilView];
    [chilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headerView.mas_left);
        make.right.mas_equalTo(self.headerView.mas_right);
        make.top.mas_equalTo(timeView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(460);
    }];
    UIImageView *childImg = [[UIImageView alloc] init];
    childImg.image = [UIImage imageNamed:@"child"];
    [chilView addSubview:childImg];
    [childImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.top.mas_equalTo(chilView.mas_top).mas_offset(10);
    }];
    UILabel *infoLable = [[UILabel alloc] init];
    if ([self.whichType isEqualToString:@"0"]) {
       infoLable.text = @"学生信息";
    }else{
       infoLable.text = @"乘车人信息";
    }
    
    infoLable.font = [UIFont systemFontOfSize:15];
    infoLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:infoLable];
    [infoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(childImg.mas_centerY);
        make.left.mas_equalTo(childImg.mas_right).mas_offset(10);
    }];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = TABLEVIEW_BACKCOLOR;
    [chilView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(childImg.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(1);
    }];
    UILabel *nameLable = [[UILabel alloc] init];
    nameLable.text = @"姓名";
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.textColor = [UIColor lightGrayColor];
    [chilView addSubview:nameLable];
    [nameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(lineView.mas_left);
    }];
    UILabel *nameInfoLable = [[UILabel alloc] init];
    nameInfoLable.text = @"--";
    nameInfoLable.font = [UIFont systemFontOfSize:15];
    nameInfoLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:nameInfoLable];
    [nameInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLable.mas_centerY);
        make.left.mas_equalTo(nameLable.mas_right).mas_offset(15);
    }];
    self.child_name_Label = nameInfoLable;
    UILabel *sexLable = [[UILabel alloc] init];
    sexLable.text = @"性别";
    sexLable.font = [UIFont systemFontOfSize:15];
    sexLable.textColor = [UIColor lightGrayColor];
    [chilView addSubview:sexLable];
    [sexLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLable.mas_bottom).mas_equalTo(10);
        make.left.mas_equalTo(lineView.mas_left);
    }];
    UILabel *sexInfoLable = [[UILabel alloc] init];
    sexInfoLable.text = @"--";
    sexInfoLable.font = [UIFont systemFontOfSize:15];
    sexInfoLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:sexInfoLable];
    [sexInfoLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sexLable.mas_centerY);
        make.left.mas_equalTo(sexLable.mas_right).mas_offset(15);
    }];
    self.child_sex_Label = sexInfoLable;
    UIButton *telButton = [[UIButton alloc] init];
    if ([self.whichType isEqualToString:@"0"]) {
       [telButton setTitle:@"联系家长" forState:UIControlStateNormal];
    }else{
       [telButton setTitle:@"联系乘客" forState:UIControlStateNormal];
    }
    
    [telButton setImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
    [telButton setTitleColor:CATECOLOR_SELECTED forState:UIControlStateNormal];
    [telButton addTarget:self action:@selector(didClickTelButton) forControlEvents:UIControlEventTouchUpInside];
    telButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    CGSize titleSize = [telButton.titleLabel.text sizeWithAttributes:@{@"NSFontAttributeName" : telButton.titleLabel.font}];
    telButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -13, -5, 0);

//    [telButton setImageEdgeInsets:UIEdgeInsetsMake(-5, 5, -5, 0)];
    [chilView addSubview:telButton];
    [telButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sexLable.mas_left);
        make.top.mas_equalTo(sexLable.mas_bottom).mas_offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];

    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = TABLEVIEW_BACKCOLOR;
    [chilView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chilView.mas_left);
        make.right.mas_equalTo(chilView.mas_right);
        make.top.mas_equalTo(telButton.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    UIImageView *childAvatarImg = [[UIImageView alloc] init];
    childAvatarImg.image = [UIImage imageNamed:@"defaut"];

    [chilView addSubview:childAvatarImg];
    [childAvatarImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).mas_offset(5);
        make.height.mas_equalTo(94);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-30);
        make.width.mas_equalTo(73);
    }];
    self.chilImageView = childAvatarImg;
    UIImageView *localImg = [[UIImageView alloc] init];
    localImg.image = [UIImage imageNamed:@"dizhi"];
    [chilView addSubview:localImg];
    [localImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.top.mas_equalTo(lineView1.mas_bottom).mas_offset(10);
    }];
    UILabel *localLable = [[UILabel alloc] init];
    localLable.text = @"接送地址";
    localLable.font = [UIFont systemFontOfSize:15];
    localLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:localLable];
    [localLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(localImg.mas_centerY);
        make.left.mas_equalTo(localImg.mas_right).mas_offset(10);
    }];
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = TABLEVIEW_BACKCOLOR;
    [chilView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(localImg.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    UIImageView *homeImg = [[UIImageView alloc] init];
    homeImg.image = [UIImage imageNamed:@"home"];
    [chilView addSubview:homeImg];
    [homeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.top.mas_equalTo(lineView2.mas_bottom).mas_offset(10);
    }];
    UILabel *homeLable = [[UILabel alloc] init];
    homeLable.text = @"--";
    homeLable.font = [UIFont systemFontOfSize:15];
    homeLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:homeLable];
    [homeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(homeImg.mas_centerY);
        make.left.mas_equalTo(homeImg.mas_right).mas_offset(10);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-10);
    }];
    self.home_Label = homeLable;
    UILabel *homeDetialLable = [[UILabel alloc] init];
    homeDetialLable.text = @"--------------";
    homeDetialLable.font = [UIFont systemFontOfSize:12];
    homeDetialLable.textColor = [UIColor grayColor];
    [chilView addSubview:homeDetialLable];
    [homeDetialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeLable.mas_bottom).mas_offset(3);
        make.left.mas_equalTo(homeLable.mas_left);
        make.right.mas_equalTo(homeLable.mas_right);
    }];
    self.home_detial_Label = homeDetialLable;
    UIImageView *schoolImg = [[UIImageView alloc] init];
    schoolImg.image = [UIImage imageNamed:@"school"];
    [chilView addSubview:schoolImg];
    [schoolImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.top.mas_equalTo(homeDetialLable.mas_bottom).mas_offset(5);
    }];
    UILabel *schoolLable = [[UILabel alloc] init];
    schoolLable.text = @"---";
    schoolLable.font = [UIFont systemFontOfSize:15];
    schoolLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:schoolLable];
    [schoolLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(homeDetialLable.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(schoolImg.mas_right).mas_offset(10);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-10);
    }];
    self.school_Label = schoolLable;
    UILabel *schoolDetialLable = [[UILabel alloc] init];
    schoolDetialLable.text = @"---------";
    schoolDetialLable.font = [UIFont systemFontOfSize:12];
    schoolDetialLable.textColor = [UIColor grayColor];
    [chilView addSubview:schoolDetialLable];
    [schoolDetialLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(schoolLable.mas_bottom).mas_offset(3);
        make.left.mas_equalTo(homeLable.mas_left);
        make.right.mas_equalTo(homeLable.mas_right);
    }];
    self.school_detail_Label = schoolDetialLable;
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = TABLEVIEW_BACKCOLOR;
    [chilView addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chilView.mas_left);
        make.right.mas_equalTo(chilView.mas_right);
        make.top.mas_equalTo(schoolDetialLable.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    UIImageView *jiesongImg = [[UIImageView alloc] init];
    jiesongImg.image = [UIImage imageNamed:@"time"];
    [chilView addSubview:jiesongImg];
    [jiesongImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(20);
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.top.mas_equalTo(lineView3.mas_bottom).mas_offset(10);
    }];
    UILabel *jiesongLable = [[UILabel alloc] init];
    jiesongLable.text = @"接送时间";
    jiesongLable.font = [UIFont systemFontOfSize:15];
    jiesongLable.textColor = [UIColor darkGrayColor];
    [chilView addSubview:jiesongLable];
    [jiesongLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(jiesongImg.mas_centerY);
        make.left.mas_equalTo(jiesongImg.mas_right).mas_offset(10);
    }];
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = TABLEVIEW_BACKCOLOR;
    [chilView addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(chilView.mas_left).mas_offset(15);
        make.right.mas_equalTo(chilView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(jiesongImg.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(1);
    }];
    CGFloat width = (DeviceWidth - 30) / 6;
    //星期设置
    UIImageView *yuanImg = [[UIImageView alloc] init];
    yuanImg.image = [UIImage imageNamed:@"yuan"];
    yuanImg.contentMode = UIViewContentModeScaleAspectFit;

    [chilView addSubview:yuanImg];
    [yuanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView4.mas_left).mas_offset(5);
        make.top.mas_equalTo(lineView4.mas_bottom).mas_offset(15);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(8);
    }];

    UILabel *day1 = [[UILabel alloc] init];
    day1.text = @"周一";
    day1.textColor = [UIColor grayColor];
    day1.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:day1];
    [day1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(yuanImg.mas_right);
        make.centerY.mas_equalTo(yuanImg.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    UILabel *day2 = [[UILabel alloc] init];
    day2.text = @"周二";
    day2.textColor = [UIColor grayColor];
    day2.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:day2];
    [day2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day1.mas_right);
        make.centerY.mas_equalTo(yuanImg.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    UILabel *day3 = [[UILabel alloc] init];
    day3.text = @"周三";
    day3.textColor = [UIColor grayColor];
    day3.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:day3];
    [day3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day2.mas_right);
        make.centerY.mas_equalTo(yuanImg.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    UILabel *day4 = [[UILabel alloc] init];
    day4.text = @"周四";
    day4.textColor = [UIColor grayColor];
    day4.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:day4];
    [day4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day3.mas_right);
        make.centerY.mas_equalTo(yuanImg.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    UILabel *day5 = [[UILabel alloc] init];
    day5.text = @"周五";
    day5.textColor = [UIColor grayColor];
    day5.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:day5];
    [day5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(day4.mas_right);
        make.centerY.mas_equalTo(yuanImg.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    UILabel *inSchool = [[UILabel alloc] init];
    inSchool.text = @"入校";
    inSchool.textColor = [UIColor darkGrayColor];
    inSchool.font = [UIFont systemFontOfSize:15];
    inSchool.textAlignment = NSTextAlignmentCenter;//对齐方式
    [chilView addSubview:inSchool];
    [inSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(yuanImg.mas_bottom).offset(15);
        make.centerX.mas_equalTo(yuanImg.mas_centerX);
        make.width.mas_equalTo(width);
    }];
    UILabel *inday1 = [[UILabel alloc] init];
    inday1.text = @"--";
    inday1.textColor = [UIColor grayColor];
    inday1.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:inday1];
    [inday1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inSchool.mas_right);
        make.centerY.mas_equalTo(inSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.in_Mon_Label = inday1;
    UILabel *inday2 = [[UILabel alloc] init];
    inday2.text = @"--";
    inday2.textColor = [UIColor grayColor];
    inday2.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:inday2];
    [inday2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inday1.mas_right);
        make.centerY.mas_equalTo(inSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.in_Tues_Label = inday2;
    UILabel *inday3 = [[UILabel alloc] init];
    inday3.text = @"--";
    inday3.textColor = [UIColor grayColor];
    inday3.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:inday3];
    [inday3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inday2.mas_right);
        make.centerY.mas_equalTo(inSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.in_Wednes_Label = inday3;
    UILabel *inday4 = [[UILabel alloc] init];
    inday4.text = @"--";
    inday4.textColor = [UIColor grayColor];
    inday4.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:inday4];
    [inday4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inday3.mas_right);
        make.centerY.mas_equalTo(inSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.in_Thurs_Label = inday4;
    UILabel *inday5 = [[UILabel alloc] init];
    inday5.text = @"--";
    inday5.textColor = [UIColor grayColor];
    inday5.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:inday5];
    [inday5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inday4.mas_right);
        make.centerY.mas_equalTo(inSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.in_Fri_Label = inday5;
    UILabel *outSchool = [[UILabel alloc] init];
    outSchool.text = @"离校";
    outSchool.textAlignment = NSTextAlignmentCenter;//对齐方式
    outSchool.textColor = [UIColor darkGrayColor];
    outSchool.font = [UIFont systemFontOfSize:15];
    [chilView addSubview:outSchool];
    [outSchool mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inSchool.mas_bottom).offset(10);
        make.centerX.mas_equalTo(yuanImg.mas_centerX);
        make.width.mas_equalTo(width);
    }];
    UILabel *outday1 = [[UILabel alloc] init];
    outday1.text = @"--";
    outday1.textColor = [UIColor grayColor];
    outday1.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:outday1];
    [outday1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(outSchool.mas_right);
        make.centerY.mas_equalTo(outSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.out_Mon_Label = outday1;
    UILabel *outday2 = [[UILabel alloc] init];
    outday2.text = @"--";
    outday2.textColor = [UIColor grayColor];
    outday2.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:outday2];
    [outday2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(outday1.mas_right);
        make.centerY.mas_equalTo(outSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.out_Tues_Label = outday2;
    UILabel *outday3 = [[UILabel alloc] init];
    outday3.text = @"--";
    outday3.textColor = [UIColor grayColor];
    outday3.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:outday3];
    [outday3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(outday2.mas_right);
        make.centerY.mas_equalTo(outSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.out_Wednes_Label = outday3;
    UILabel *outday4 = [[UILabel alloc] init];
    outday4.text = @"--";
    outday4.textColor = [UIColor grayColor];
    outday4.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:outday4];
    [outday4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(outday3.mas_right);
        make.centerY.mas_equalTo(outSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.out_Thurs_Label = outday4;
    UILabel *outday5 = [[UILabel alloc] init];
    outday5.text = @"--";
    outday5.textColor = [UIColor grayColor];
    outday5.font = [UIFont systemFontOfSize:12];
    [chilView addSubview:outday5];
    [outday5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(outday4.mas_right);
        make.centerY.mas_equalTo(outSchool.mas_centerY);
        make.width.mas_equalTo(width);
    }];
    self.out_Fri_Label = outday5;
    //车View
    UIView *carView = [[UIView alloc] init];
    carView.backgroundColor = [UIColor whiteColor];
    [self.headerView addSubview:carView];
    [carView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(chilView.mas_bottom).offset(10);
        make.left.mas_equalTo(chilView.mas_left);
        make.right.mas_equalTo(chilView.mas_right);
        make.height.mas_equalTo(44);
    }];

    UIImageView *carImg = [[UIImageView alloc] init];
    carImg.image = [UIImage imageNamed:@"car"];
    [carView addSubview:carImg];
    [carImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_equalTo(25);
        make.left.mas_equalTo(carView.mas_left).mas_offset(15);
        make.top.mas_equalTo(carView.mas_top).mas_offset(10);
    }];
    UILabel *carLable = [[UILabel alloc] init];
    carLable.text = @"用车方式：";
    carLable.font = [UIFont systemFontOfSize:15];
    carLable.textColor = [UIColor darkGrayColor];
    [carView addSubview:carLable];
    [carLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(carImg.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(carImg.mas_centerY);
    }];
    self.typeLabel = carLable;
    [self.tableView setTableHeaderView:self.headerView];
}

//设置导航栏
- (void)setUpNav
{
    UIButton *navBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame = CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//导航栏返回按钮
- (void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
