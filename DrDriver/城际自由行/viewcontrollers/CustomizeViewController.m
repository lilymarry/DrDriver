
//
//  CustomizeViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/14.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "CustomizeViewController.h"
#import "ITAddressViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapSearchKit/AMapSearchKit.h>
#import "IndependentTravelView.h"
#import "LeeTagView.h"

#import "ViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "ITAddressViewController.h"

@interface CustomizeViewController ()<UIScrollViewDelegate,UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource,AMapSearchDelegate,LeeTagViewDelegate,AMapLocationManagerDelegate>
{
    NSMutableArray *dateArr;
    NSMutableArray *hourArr;
    NSMutableArray *minuteArr;
    NSMutableArray *todayHourArr;
    NSMutableArray *todayMinuteArr;
    NSString *dateStr;
    NSString *hourStr;
    NSString *minuteStr;
    UILabel *placeHolderLable;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *startCityLB;
@property(nonatomic,strong)UILabel *endCityLB;
@property(nonatomic,strong)UIImageView *arrowImageView;

@property(nonatomic,strong)UIImageView *startImageLB;
@property(nonatomic,strong)UILabel *startAdLB;
@property(nonatomic,strong)UILabel *startAddressLB;

@property(nonatomic,strong)UIImageView *endImageLB;
@property(nonatomic,strong)UILabel *endAdLB;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UITextField *priceTF;
@property(nonatomic,strong)UILabel *priceTLB;

@property(nonatomic,strong)UITextField *sumPriceTF;
@property(nonatomic,strong)UILabel *sumPriceTLB;

@property(nonatomic,strong)UILabel *priceLB;
@property(nonatomic,strong)UILabel *sumPriceLB;

@property(nonatomic,strong)UIButton *timeBtn;
@property(nonatomic,strong)UIImageView *timeBtnArrowImageView;

@property(nonatomic,strong)UIImageView *numberImageView;
@property(nonatomic,strong)UIButton *numberBtn;
@property(nonatomic,strong)UIImageView *numberArrowImageView;

@property(nonatomic,strong)UIImageView *parcelImageView;
@property(nonatomic,strong)UIButton *parcelBtn;
@property(nonatomic,strong)UIImageView *parcelArrowImageView;


@property(nonatomic,strong)UILabel *remarkLB;
@property(nonatomic,strong)UITextView *remarkTextView;


@property(nonatomic,strong)UILabel *distanceLB;

@property(nonatomic,strong)UIPickerView *pickView;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *lineView2;
@property(nonatomic,strong)UIView *timePickBgView;

@property(nonatomic,strong)UIPickerView *numberPickView;
@property(nonatomic,strong)UIView *numberBackView;
@property(nonatomic,strong)UIView *numberLineView2;
@property(nonatomic,strong)UIView *numberPickBgView;
@property(nonatomic,strong)NSMutableArray *numberArr;
@property(nonatomic,copy)NSString  *numberStr;

@property(nonatomic,strong)UIPickerView *parcelPickView;
@property(nonatomic,strong)UIView *parcelBackView;
@property(nonatomic,strong)UIView *parcelLineView2;
@property(nonatomic,strong)UIView *parcelPickBgView;
@property(nonatomic,strong)NSMutableArray *parcelArr;
@property(nonatomic,copy)NSString  *parcelStr;
@property(nonatomic,copy)NSString  *httpParcelStr;

@property(nonatomic,strong)NSDictionary *startDic;
@property(nonatomic,strong)NSDictionary *endDic;
@property(nonatomic,strong)LeeTagView *tagView;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray *remarkStrArr;

@property(nonatomic,assign)float driver_price;
@property(nonatomic,assign)float driver_fixed_price;
@property(nonatomic,copy)NSString *changeDriver_price;
@property(nonatomic,copy)NSString *changeDriver_fixed_price;
@property(nonatomic,copy, readwrite)NSString *start_province;//起点省份
@property(nonatomic,copy, readwrite)NSString *start_city;//起点城市
@property(nonatomic,copy, readwrite)NSString *start_county;//起点县区
@property(nonatomic,copy, readwrite)NSString *start_name;//起点名称
@property(nonatomic,copy, readwrite)NSString *start_address;//起点详地址
@property(nonatomic,copy, readwrite)NSString *start_lng;//起点经度
@property(nonatomic,copy, readwrite)NSString *start_lat;//起点纬度
@property(nonatomic,copy, readwrite)NSString *end_province;//终点省份
@property(nonatomic,copy, readwrite)NSString *end_city;//终点城市
@property(nonatomic,copy, readwrite)NSString *end_county;//终点县区
@property(nonatomic,copy, readwrite)NSString *end_name;//终点名称
@property(nonatomic,copy, readwrite)NSString *end_address;//终点详地址
@property(nonatomic,copy, readwrite)NSString *end_lng;//终点经度
@property(nonatomic,copy, readwrite)NSString *end_lat;//终点纬度


@property (nonatomic, strong) AMapLocationManager *locationManager;
@end

@implementation CustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布消息";
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    self.remarkStrArr = [NSMutableArray array];
    self.changeDriver_price = @"-";
    self.changeDriver_fixed_price = @"-";
    self.httpParcelStr = @"0";
    self.numberArr = [NSMutableArray array];
    self.parcelArr = [NSMutableArray array];
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    [self getLocation];
    [self setUpNav];//设置导航栏
    [self creatHttp];
}
-(void)creatHttp{
    
    [AFRequestManager postRequestWithUrl:TRAVEL_REMARK_LIST params:@{} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"responseObjectresponseObject%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"请求成功"]) {
            self.dataArr = [NSMutableArray array];
            for (NSDictionary *dic in responseObject[@"data"]) {

                [self.dataArr addObject:dic[@"remark"]];
            }
            [self mainHttp];
        }

    } failure:^(NSError *error) {

    }];
}
-(void)mainHttp{
    NSDictionary *dic = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
//    NSLog(@"NSDictionary *dic =%@",dic);
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_VEHICLE_INFO params:dic tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"responseObjectresponseObject%@",responseObject);
        if ([responseObject[@"message"] isEqualToString:@"请求成功"]) {
            [self.numberArr removeAllObjects];
            [self.parcelArr removeAllObjects];
            for (int i = 1; i <= [responseObject[@"data"][@"seat_num"] intValue]; i++) {
                [self.numberArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            for (int i = 0; i <= [responseObject[@"data"][@"luggage_num"] intValue]; i++) {
                [self.parcelArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [self creatMainView:responseObject[@"data"]];
        }

    } failure:^(NSError *error) {

    }];
}
-(void)creatMainView:(NSDictionary *)dic{
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, k_Height_NavBar, DeviceWidth, DeviceHeight - k_Height_NavBar - Bottom_Height)];
   //设置画布大小，一般比frame大
    
    if (DeviceWidth < 375) {
        
     self.scrollView.contentSize = CGSizeMake(0, DeviceHeight + 100);
    }else{
        
     self.scrollView.contentSize = CGSizeMake(0, DeviceHeight);
    }
    self.scrollView.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.scrollView.layer.cornerRadius = 6;
    self.scrollView.layer.masksToBounds = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.mas_offset(DeviceWidth);
        make.top.equalTo(self.scrollView);
        make.bottom.mas_equalTo(540);
    }];

    self.startImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-起始q"]];
    [self.bgView addSubview:self.startImageLB];
    
    self.startAdLB = [[UILabel alloc] init];
    self.startAdLB.text = @"请在此处选择您的位置";
    self.startAdLB.font = [UIFont systemFontOfSize:15];
    self.startAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self.bgView addSubview:self.startAdLB];
    
    self.startAddressLB = [[UILabel alloc] init];
    self.startAddressLB.text = @"";
    self.startAddressLB.font = [UIFont systemFontOfSize:12];
    self.startAddressLB.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.startAddressLB];
    
    self.endImageLB  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"坐标-终点q"]];
    [self.bgView addSubview:self.endImageLB];
    
    self.endAdLB = [[UILabel alloc] init];
    self.endAdLB.text = @"请在此处选择您要去哪儿";
    self.endAdLB.font = [UIFont systemFontOfSize:15];
    self.endAdLB.textColor = [CYTSI colorWithHexString:@"#333333"];
    [self.bgView addSubview:self.endAdLB];
    
    self.endAddressLB = [[UILabel alloc] init];
    self.endAddressLB.text = @"";
    self.endAddressLB.font = [UIFont systemFontOfSize:12];
    self.endAddressLB.textColor = [UIColor lightGrayColor];
    [self.bgView addSubview:self.endAddressLB];
    
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setTitle:@"" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startTapDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:startBtn];
    
    UIButton *endBtn = [[UIButton alloc] init];
   [endBtn setTitle:@"" forState:UIControlStateNormal];
   [endBtn addTarget:self action:@selector(endTapDidClick) forControlEvents:UIControlEventTouchUpInside];
   [self.bgView addSubview:endBtn];
    
    
    [self.startImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.bgView).offset(10);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    [self.startAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.startImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.startAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startImageLB.mas_right).offset(7);
        make.top.equalTo(self.startAdLB.mas_bottom).mas_offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.endImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.mas_offset(25);
        make.top.equalTo(self.startImageLB.mas_bottom).offset(20);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    [self.endAdLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.centerY.equalTo(self.endImageLB.mas_centerY).offset(-3);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [self.endAddressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endImageLB.mas_right).offset(7);
        make.top.equalTo(self.endAdLB.mas_bottom).mas_offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.startImageLB.mas_left);
       make.top.equalTo(self.startImageLB.mas_top);
       make.right.equalTo(self.bgView.mas_right).offset(-10);
       make.bottom.equalTo(self.startAddressLB.mas_bottom);
    }];
    
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.endImageLB.mas_left);
       make.top.equalTo(self.endImageLB.mas_top);
       make.right.equalTo(self.bgView.mas_right).offset(-10);
       make.bottom.equalTo(self.endAddressLB.mas_bottom);
    }];
    
    self.distanceLB = [[UILabel alloc] init];
    self.distanceLB.text = @"本次行程预计0km,大约行驶0小时";
    self.distanceLB.textColor = [UIColor lightGrayColor];
    self.distanceLB.font = [UIFont systemFontOfSize:13];
//    self.distanceLB.hidden = YES;
    [self.bgView addSubview:self.distanceLB];
    [self.distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.endAddressLB.mas_bottom).offset(2);
        make.height.mas_offset(20);
    
    }];
    
    UIImageView *priceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"价格IT"]];
    [self.bgView addSubview:priceImageView];
    [priceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.distanceLB.mas_bottom).offset(15);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.startImageLB);
    }];
    
    UILabel *priceLB = [[UILabel alloc] init];
    priceLB.text = @"单价";
    [self.bgView addSubview:priceLB];
    [priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceImageView.mas_right);
        make.centerY.equalTo(priceImageView.mas_centerY);
    }];
    
    self.priceTF = [[UITextField alloc] init];
    self.priceTF.placeholder = @"请输入价位";
    self.priceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.bgView addSubview:self.priceTF];
    [self.priceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB.mas_right);
        make.centerY.equalTo(priceImageView.mas_centerY);
        make.width.mas_offset(90);
        make.height.mas_offset(30);
    }];
    [self.priceTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    
    UILabel *princeLine = [[UILabel alloc] init];
    princeLine.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:princeLine];
    [princeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.priceTF);
        make.top.equalTo(self.priceTF.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    self.priceTLB = [[UILabel alloc] init];
    self.priceTLB.text = @"元/人";
    [self.bgView addSubview:self.priceTLB];
    [self.priceTLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTF.mas_right);
        make.centerY.equalTo(self.priceTF);
    }];
    
    self.priceLB = [[UILabel alloc] init];
    self.priceLB.text = [NSString stringWithFormat:@"(推荐价格%@元/人)",dic[@"driver_price"]];
    self.priceLB.font = [UIFont systemFontOfSize:11];
    self.priceLB.textColor = [CYTSI colorWithHexString:@"#f5a623"];
    self.priceLB.hidden = YES;
    [self.bgView addSubview:self.priceLB];
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTLB.mas_right).offset(5);
        make.centerY.equalTo(self.priceTLB);
    }];
    self.driver_price = [dic[@"driver_price"] floatValue];
    
    self.sumPriceLB = [[UILabel alloc] init];
    self.sumPriceLB.text = @"一口价包车";
    self.sumPriceLB.numberOfLines = 0;
    [self.bgView addSubview:self.sumPriceLB];
    [self.sumPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLB);
        make.top.equalTo(princeLine.mas_bottom).offset(10);
    }];

    self.sumPriceTF = [[UITextField alloc] init];
    self.sumPriceTF.placeholder = @"请输入";
    self.sumPriceTF.text = dic[@"driver_fixed_price"];
    self.sumPriceTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self.bgView addSubview:self.sumPriceTF];
    [self.sumPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sumPriceLB.mas_right);
        make.centerY.equalTo(self.sumPriceLB.mas_centerY);
        make.width.mas_offset(60);
        make.height.mas_offset(30);
    }];
    
    UILabel *sumPrinceLine = [[UILabel alloc] init];
    sumPrinceLine.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:sumPrinceLine];
    [sumPrinceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.equalTo(self.sumPriceTF);
        make.top.equalTo(self.sumPriceTF.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    self.sumPriceTLB = [[UILabel alloc] init];
    self.sumPriceTLB.text = @"元";
    [self.bgView addSubview:self.sumPriceTLB];
    [self.sumPriceTLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sumPriceTF.mas_right);
        make.centerY.equalTo(self.sumPriceTF);
    }];
    self.driver_fixed_price = [dic[@"driver_fixed_price"] floatValue];
    
    UILabel *sumLb = [[UILabel alloc] init];
    sumLb = [[UILabel alloc] init];
    sumLb.text = [NSString stringWithFormat:@"(推荐价格%@元)",dic[@"driver_fixed_price"]];
    sumLb.font = [UIFont systemFontOfSize:11];
    sumLb.hidden = YES;
    sumLb.textColor = [CYTSI colorWithHexString:@"#f5a623"];
    [self.bgView addSubview:sumLb];
    [sumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sumPriceTLB.mas_right).offset(5);
        make.centerY.equalTo(self.sumPriceTLB);
    }];
    
    //出发时间
    UIImageView *timeImageView = [[UIImageView alloc] init];
    timeImageView.image = [UIImage imageNamed:@"时间q"];
    [self.bgView addSubview:timeImageView];
    [timeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sumPriceLB.mas_bottom).offset(15);
        make.width.mas_offset(20);
        make.height.mas_offset(20);
        make.centerX.equalTo(self.startImageLB);
    }];
    
    UILabel *timeLB = [[UILabel alloc] init];
    timeLB.text = @"出发时间";
    [self.bgView addSubview:timeLB];
    [timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(timeImageView);
    }];
    
    self.timeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.timeBtn setTitle:@"请选择出发时间" forState:(UIControlStateNormal)];
    [self.timeBtn setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    self.timeBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [self.timeBtn addTarget:self action:@selector(timeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.timeBtn];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeImageView);
        make.width.mas_offset(160);
        make.height.mas_offset(25);
        make.left.equalTo(timeLB.mas_right);
    }];
    
    UILabel *timeBtnLineLb = [[UILabel alloc] init];
    timeBtnLineLb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:timeBtnLineLb];
    [timeBtnLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.timeBtn);
        make.top.equalTo(self.timeBtn.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    self.timeBtnArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.bgView addSubview:self.timeBtnArrowImageView];
    [self.timeBtnArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBtn.mas_right).offset(5);
        make.centerY.equalTo(timeImageView);
        make.width.and.height.mas_offset(15);
    }];
    //剩余座位数
    self.numberImageView = [[UIImageView alloc] init];
    self.numberImageView.image = [UIImage imageNamed:@"座位"];
    [self.bgView addSubview:self.numberImageView];
    [self.numberImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.startImageLB);
        make.top.equalTo(self.timeBtn.mas_bottom).offset(20);
        make.width.and.height.mas_offset(20);
    }];
    
    UILabel *numberLB = [[UILabel alloc] init];
    numberLB.text = @"座位";
    [self.bgView addSubview:numberLB];
    [numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.numberImageView);
    }];
    
    self.numberBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.numberBtn setTitle:@"请选择剩余座位数" forState:UIControlStateNormal];
    self.numberBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.numberBtn setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.numberBtn addTarget:self action:@selector(numberAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.numberBtn];
    [self.numberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberLB.mas_right);
        make.centerY.equalTo(self.numberImageView);
        make.height.mas_offset(25);
        make.width.mas_offset(160);
    }];
    
    UILabel *lineLb = [[UILabel alloc] init];
    lineLb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:lineLb];
    [lineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.numberBtn);
        make.top.equalTo(self.numberBtn.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    self.numberArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.bgView addSubview:self.numberArrowImageView];
    [self.numberArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberBtn.mas_right).offset(5);
        make.centerY.equalTo(self.numberImageView);
        make.width.and.height.mas_offset(15);
    }];
    //剩余行李数
    self.parcelImageView = [[UIImageView alloc] init];
    self.parcelImageView.image = [UIImage imageNamed:@"行李"];
    [self.bgView addSubview:self.parcelImageView];
    [self.parcelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.startImageLB);
        make.top.equalTo(self.numberImageView.mas_bottom).offset(20);
        make.width.and.height.mas_offset(20);
    }];
    
    UILabel *parcelLB = [[UILabel alloc] init];
    parcelLB.text = @"行李";
    [self.bgView addSubview:parcelLB];
    [parcelLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.parcelImageView.mas_right).mas_offset(5);
        make.centerY.equalTo(self.parcelImageView);
    }];
    
    self.parcelBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.parcelBtn setTitle:@"请选择剩余行李数" forState:UIControlStateNormal];
    self.parcelBtn.titleLabel.font=[UIFont systemFontOfSize:17];
    [self.parcelBtn setTitleColor:[CYTSI colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    [self.parcelBtn addTarget:self action:@selector(parcelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.parcelBtn];
    [self.parcelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(parcelLB.mas_right);
        make.centerY.equalTo(self.parcelImageView);
        make.height.mas_offset(25);
        make.width.mas_offset(160);
    }];
    
    UILabel *parcelLineLb = [[UILabel alloc] init];
    parcelLineLb.backgroundColor = [UIColor lightGrayColor];
    [self.bgView addSubview:parcelLineLb];
    [parcelLineLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.parcelBtn);
        make.top.equalTo(self.parcelBtn.mas_bottom);
        make.height.mas_offset(1);
    }];
    
    self.parcelArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"下拉箭头"]];
    [self.bgView addSubview:self.parcelArrowImageView];
    [self.parcelArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.parcelBtn.mas_right).offset(5);
        make.centerY.equalTo(self.parcelImageView);
        make.width.and.height.mas_offset(15);
    }];
    
    
    self.remarkLB = [[UILabel alloc] init];
    self.remarkLB.text = @"备注(可不填)";
    [self.bgView addSubview:self.remarkLB];
    [self.remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.parcelImageView);
        make.top.equalTo(self.parcelImageView.mas_bottom).offset(20);
    }];
    
    self.tagView = [[LeeTagView alloc] init];
    [self.bgView addSubview:self.tagView];
    self.tagView.delegate = self;
    self.tagView.tagViewSelectionStyle = LeeTagViewStyleSelectMulti;
    self.tagView.tagViewLineStyle = LeeTagViewLineStyleMulti;
    self.tagView.tagViewPadding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.tagView.tagViewMaxWidth = self.view.frame.size.width - 10;
    [self.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LeeTagItemViewModel * tagModel = [[LeeTagItemViewModel alloc]init];
        
        tagModel.normalTitle = obj;
        tagModel.normalFont = [UIFont systemFontOfSize:9.0f];
        tagModel.normalFontSize = 15.0f;
        tagModel.normalColor = RGBA(163, 163, 163, 1);
        tagModel.normalBGColor = RGBA(239, 239, 239, 1);
        tagModel.normalBorderColor = RGBA(163, 163, 163, 1);
        tagModel.normalBorderWidth = 1.0f;
        tagModel.normalCornerRadius = 3.0f;
        
        tagModel.selectedTitle = obj;
        tagModel.selectedFont = [UIFont systemFontOfSize:9.0f];
        tagModel.selectedFontSize = 15.0f;
        tagModel.selectedColor = [UIColor whiteColor];
        tagModel.selectedBGColor = [CYTSI colorWithHexString:@"#f5a623"];
        tagModel.selectedBorderColor = RGBA(163, 163, 163, 1);
        tagModel.selectedBorderWidth = 1.0f;
        tagModel.selectedCornerRadius = 3.0f;
        
        [self.tagView addTag:tagModel];
    }];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLB.mas_bottom).offset(5);
        make.left.equalTo(self.bgView).mas_offset(5);
        make.width.mas_offset(DeviceWidth - 10);
    }];
    
    self.remarkTextView = [[UITextView alloc]initWithFrame:CGRectMake(19, 0, DeviceWidth-38, 137)];
    self.remarkTextView.delegate = self;
    self.remarkTextView.font=[UIFont systemFontOfSize:11];
    self.remarkTextView.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    self.remarkTextView.layer.borderWidth     = 1;
    self.remarkTextView.layer.cornerRadius    = 4;
    self.remarkTextView.backgroundColor = RGBA(239, 238, 235, 0.7);
    self.remarkTextView.textColor=[CYTSI colorWithHexString:@"#999999"];
    [self.bgView addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.tagView.mas_bottom).offset(10);
        make.width.mas_offset(DeviceWidth - 20);
        make.height.mas_offset(80);
    }];
    
    
    placeHolderLable=[[UILabel alloc]init];
    placeHolderLable.textColor=[CYTSI colorWithHexString:@"#999999"];
    placeHolderLable.font=[UIFont systemFontOfSize:12];
    placeHolderLable.text=@"请输入...";
    [self.bgView addSubview:placeHolderLable];
    [placeHolderLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@23);
        make.top.equalTo(self.remarkTextView.mas_top).with.offset(7);
        make.width.equalTo(@120);
        make.height.equalTo(@20);
    }];
    

    
    UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发布" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:16];
    btn.layer.cornerRadius=5;
    btn.layer.masksToBounds=YES;
    btn.backgroundColor=[CYTSI colorWithHexString:@"#2488ef"];
    [btn addTarget:self action:@selector(OrderButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.width.mas_offset(DeviceWidth - 33);
        make.height.mas_offset(45);
        make.top.equalTo(self.bgView.mas_bottom).offset(20);
    }];
    
//    UILabel *bottomRemarkLB = [[UILabel alloc] init];
//    [self.scrollView addSubview:bottomRemarkLB];
//    bottomRemarkLB.text = @"注:本次行程包含广告费及税务等费用";
//    bottomRemarkLB.textColor = [UIColor lightGrayColor];
//    bottomRemarkLB.font = [UIFont systemFontOfSize:9];
//    [bottomRemarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.scrollView);
//        make.top.equalTo(btn.mas_bottom).offset(40);
//        make.height.mas_offset(20);
//        make.bottom.mas_offset(-30);
//    }];
}
-(void)textFieldChangeText:(UITextField *)textField
{
    if ([textField isEqual:self.priceTF] && textField.text!=nil ) {
        if (![textField.text isEqualToString:@""]) {
//            if ([self.priceTF.text floatValue] >= self.driver_price * 0.5 && [self.priceTF.text floatValue] <= self.driver_price * 1.5) {

                self.changeDriver_price = self.priceTF.text;
//            }
        }else{
              
            self.changeDriver_price = @"-";

        }
    }
}
#pragma mark ---- tagviewDelegate
-(void)leeTagView:(LeeTagView *)tagView tapTagItem:(LeeTagItem *)tagItem atIndex:(NSInteger)index{
    if (tagView == self.tagView){
        if (tagItem.selected) {
//            NSLog(@"124124141");
            [self.remarkStrArr addObject:tagItem.viewModel.selectedTitle];
        }else{
            [self.remarkStrArr removeObject:tagItem.viewModel.normalTitle];
        }
    }
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==self.remarkTextView) {
        if ([self.remarkTextView.text length] == 0) {
            [placeHolderLable setHidden:NO];
        }else{
            [placeHolderLable setHidden:YES];
        }
    }
}
#pragma mark ---- 确认发布任务
-(void)OrderButtonClicked{
    
    if ([self.startAdLB.text isEqualToString:@"请在此处选择起点"] || [self.startAdLB.text isEqualToString:@""]) {
         [CYTSI otherShowTostWithString:@"请选择起点"];
         return;
     }
     if ([self.endAdLB.text isEqualToString:@"请在此处选择终点"] || [self.endAdLB.text isEqualToString:@""]) {
            [CYTSI otherShowTostWithString:@"请选择终点"];
            return;
        }
    
    
    if ([self.priceTF.text isEqualToString:@""] || ![CYTSI isNumber:self.priceTF.text]) {
        [CYTSI otherShowTostWithString:@"请输入正确价位"];
        return;
    }

    if ([self.changeDriver_price isEqualToString:@"-"]||![CYTSI isNumber:self.changeDriver_price]) {
        [CYTSI otherShowTostWithString:@"请输入正确价格"];
        return;
    }
    if ([self.sumPriceTF.text isEqualToString:@""] || ![CYTSI isNumber:self.sumPriceTF.text]) {
            [CYTSI otherShowTostWithString:@"请输入正确一口包车价"];
            return;
    }

    NSString *estimate_time = @"";
    if ([self.timeBtn.titleLabel.text isEqualToString:@"请选择出发时间"]) {
        [CYTSI otherShowTostWithString:@"请选择出发时间"];
        return;
    }else{
        if ([[self.timeBtn.titleLabel.text substringToIndex:2] isEqualToString:@"今天"]) {
            estimate_time = [NSString stringWithFormat:@"%@%@",[CYTSI getCurrentTime],[self.timeBtn.titleLabel.text substringFromIndex:2]];
        }else if ([[self.timeBtn.titleLabel.text substringToIndex:2] isEqualToString:@"明天"]){
            NSDate *today = [CYTSI dateFromString:[CYTSI getCurrentTime]];
            estimate_time = [NSString stringWithFormat:@"%@%@",[CYTSI getTomorrowDay:today],[self.timeBtn.titleLabel.text substringFromIndex:2]];
        }else if ([[self.timeBtn.titleLabel.text substringToIndex:2] isEqualToString:@"后天"]){
            NSDate *today = [CYTSI dateFromString:[CYTSI getCurrentTime]];
            NSString *tomottow = [CYTSI getTomorrowDay:today];
            NSDate *tom = [CYTSI dateFromString:tomottow];
            estimate_time = [NSString stringWithFormat:@"%@%@",[CYTSI getTomorrowDay:tom],[self.timeBtn.titleLabel.text substringFromIndex:2]];
        }
    }
    if ([self.numberBtn.titleLabel.text isEqualToString:@"请选择剩余座位数"]) {
        [CYTSI otherShowTostWithString:@"请输入剩余座位数"];
        
        return;
    }
    if ([self.parcelBtn.titleLabel.text isEqualToString:@"请选择剩余行李数"]) {
        [CYTSI otherShowTostWithString:@"请输入剩余行李数"];
        
        return;
    }
    NSString *remarkStr = @"";
    if (self.remarkStrArr.count > 0) {
        for (int i = 0; i < self.remarkStrArr.count; i++) {
            if (i == 0) {
                remarkStr = self.remarkStrArr[i];
            }else{
                remarkStr = [NSString stringWithFormat:@"%@ %@",remarkStr,self.remarkStrArr[i]];
            }
        }
        if (![self.remarkTextView.text isEqualToString:@""]) {
            remarkStr = [NSString stringWithFormat:@"%@ %@",remarkStr,self.remarkTextView.text];
        }
    }else{
        remarkStr = self.remarkTextView.text;
    }
    
    [AFRequestManager postRequestWithUrl:DRIVER_TRAVEL_CREAT_TRAVEL params:@{
                                                                             @"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],
                                                                             @"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],
                                                                             @"start_time":estimate_time,
                                                                             @"remain_seat":self.numberStr,
                                                                             @"remark":remarkStr,
                                                                             @"price":self.changeDriver_price,
                                                                             @"fixed_price":self.sumPriceTF.text,
                                                                             @"remain_luggage":self.httpParcelStr,
                                                                             @"start_province":self.start_province,
                                                                             @"start_city":self.start_city,
                                                                             @"start_county":self.start_county,
                                                                             @"start_name":self.start_name,
                                                                             @"start_address":self.start_address,
                                                                             @"start_lng":self.start_lng,
                                                                             @"start_lat":self.start_lat,
                                                                             @"end_province":self.end_province,
                                                                             @"end_city":self.end_city,
                                                                             @"end_county":self.end_county,
                                                                             @"end_name":self.end_name,
                                                                             @"end_address":self.end_address,
                                                                             @"end_lng":self.end_lng,
                                                                             @"end_lat":self.end_lat
                                                                             } tost:YES special:0 success:^(id responseObject) {
                                                                                 if ([responseObject[@"message"] isEqualToString:@"发布成功"]) {
                                                                                     [CYTSI otherShowTostWithString:@"发布成功"];
                                                                                     NSArray * vcArray=self.navigationController.viewControllers;
                                                                                     for (ViewController * vc in vcArray) {
                                                                                         if ([vc isKindOfClass:[ViewController class]]) {
                                                                                             [vc creatHttp];
                                                                                             [self.navigationController popToViewController:vc animated:YES];
                                                                                         }
                                                                                     }
                                                                                 }
                                                                             } failure:^(NSError *error) {

                                                                             }];
}

-(void)timeAction{
    [self.view endEditing:YES];
    //创建时间pickerView
    dateArr = [NSMutableArray arrayWithArray:@[@"今天",@"明天",@"后天"]];
    hourArr = [NSMutableArray arrayWithArray:@[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22", @"23"]];
    minuteArr = [NSMutableArray arrayWithArray:@[@"00",@"10",@"20",@"30",@"40",@"50"]];
    [self compareDate];
    hourStr = todayHourArr[0];
    minuteStr = todayMinuteArr[0];
}
#pragma mark ------- 更改人数
-(void)numberAction{
    [self.view endEditing:YES];
    [self creatNumberPickView];
    self.numberStr = @"1";
}
#pragma mark ------- 更改行李件数
-(void)parcelBtnAction{
    [self.view endEditing:YES];
    [self creatParcelPickView];
    self.parcelStr = @"0";
}
#pragma mark -----  时间选择器相关
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (pickerView == self.numberPickView || pickerView == self.parcelPickView) {
        return 1;
    }else{
        return 3;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        return self.numberArr.count;
    }else if (pickerView == self.parcelPickView){
        return self.parcelArr.count;
    }else{
        if (component == 0) {
            return dateArr.count;
        }else if (component == 1){
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                return todayHourArr.count;
            }else{
                if (dateArr.count == 2) {
                    return todayHourArr.count;
                }else{
                    return hourArr.count;
                }
            }
        }else{
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                if ([hourStr isEqualToString:[NSString stringWithFormat:@"%@",todayHourArr[0]]]) {
                    return todayMinuteArr.count;
                }else{
                    return minuteArr.count;
                }
            }else{
                if (dateArr.count == 2) {
                    if ([minuteStr isEqualToString:[NSString stringWithFormat:@"%@",todayMinuteArr[0]]]) {
                        return todayMinuteArr.count;;
                    }else{
                        return minuteArr.count;;
                    }
                }else{
                    return minuteArr.count;
                }
            }
        }
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        return self.numberArr[row];
    }else if (pickerView == self.parcelPickView){
        return self.parcelArr[row];
    }else{
        if (component == 0) {
            return dateArr[row];
        }else if (component == 1){
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                return todayHourArr[row];
            }else{
                if (dateArr.count == 2) {
                    return todayHourArr[row];
                }else{
                    return hourArr[row];
                }
            }
        }else{
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                if ([hourStr isEqualToString:[NSString stringWithFormat:@"%@",todayHourArr[0]]]) {
                    return todayMinuteArr[row];
                }else{
                    return minuteArr[row];
                }
            }else{
                if (dateArr.count == 2) {
                    if ([minuteStr isEqualToString:[NSString stringWithFormat:@"%@",todayMinuteArr[0]]]) {
                        return todayMinuteArr[row];
                    }else{
                        return minuteArr[row];
                    }
                }else{
                    return minuteArr[row];
                }
            }
        }
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView == self.numberPickView) {
        if (component == 0) {
            self.numberStr = self.numberArr[row];
        }
    }else if (pickerView == self.parcelPickView){
        if (component == 0) {
            self.parcelStr = self.parcelArr[row];
        }
    }else{
        if (component == 0) {
            dateStr = dateArr[row];
            if (![dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                hourStr = @"00";
                minuteStr = @"00";
            }else{
                hourStr = todayHourArr[0];
                minuteStr = todayMinuteArr[0];
            }
            [self.pickView reloadComponent:1];
            [self.pickView reloadComponent:2];
            [self.pickView selectRow:0 inComponent:1 animated:YES];
            [self.pickView selectRow:0 inComponent:2 animated:YES];
        }else if (component == 1){
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]){
                hourStr = todayHourArr[row];
                if (![hourStr isEqualToString:[NSString stringWithFormat:@"%@",todayHourArr[0]]]) {
                    minuteStr = @"00";
                }else{
                    minuteStr = todayMinuteArr[0];
                }
            }else{
                if (dateArr.count == 2) {
                    hourStr = todayHourArr[row];
                    if (![hourStr isEqualToString:[NSString stringWithFormat:@"%@",hourArr[0]]]) {
                        minuteStr = @"00";
                    }else{
                        minuteStr = todayMinuteArr[0];
                    }
                }else{
                    hourStr = hourArr[row];
                    if (![hourStr isEqualToString:[NSString stringWithFormat:@"%@",hourArr[0]]]) {
                        minuteStr = @"00";
                    }else{
                        minuteStr = todayMinuteArr[0];
                    }
                }
            }
            [self.pickView selectRow:0 inComponent:2 animated:YES];
            [self.pickView reloadComponent:2];
        }else{
            if ([dateStr isEqualToString:[NSString stringWithFormat:@"%@",dateArr[0]]]) {
                if ([hourStr isEqualToString:[NSString stringWithFormat:@"%@",todayHourArr[0]]]) {
                    minuteStr = todayMinuteArr[row];
                }else{
                    minuteStr = minuteArr[row];
                }
            }else{
                if (dateArr.count == 2) {
                    if ([minuteStr isEqualToString:[NSString stringWithFormat:@"%@",todayMinuteArr[0]]]) {
                        minuteStr = todayMinuteArr[row];
                    }else{
                        minuteStr = minuteArr[row];
                    }
                }else{
                    minuteStr = minuteArr[row];
                }
            }
        }
    }
}


//pickerView确认
- (void)centerbtn2Action{
    [UIView animateWithDuration:0.6 animations:^{
        [self.pickView removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.timePickBgView removeFromSuperview];
    }];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@ %@:%@",dateStr,hourStr,minuteStr] forState:(UIControlStateNormal)];
}
//pickerView取消
- (void)cancelbtn2Action{
    [UIView animateWithDuration:0.6 animations:^{
        [self.pickView removeFromSuperview];
        [self.backView removeFromSuperview];
        [self.timePickBgView removeFromSuperview];
    }];
}
-(void)dismiss{
    [self.view endEditing:YES];
}
//截取时间
-(void)compareDate{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    NSInteger hour = [dateComponent hour];
    NSInteger minute = [dateComponent minute];
    //分钟
    todayMinuteArr = [NSMutableArray array];
    NSInteger newMinute;
    newMinute = (minute + 30)/10;
//    NSLog(@"%ld",(long)newMinute);
    if (newMinute > 6) {
        newMinute = newMinute - 6;
    }
    if (newMinute == 6) {
        todayMinuteArr = minuteArr;
    }else{
        do {
            [todayMinuteArr addObject:[NSString stringWithFormat:@"%ld",newMinute * 10]];
            newMinute ++;
        } while (newMinute < 6);
    }
//    NSLog(@"%@",todayMinuteArr);
    // 小时
    todayHourArr = [NSMutableArray array];
    NSInteger newHour;
    if (minute >= 30) {
        newHour = hour + 1;
    }else{
        newHour = hour;
    }
    if (newHour == 24) {
        todayHourArr = hourArr;
        dateArr = [NSMutableArray arrayWithArray:@[@"明天",@"后天"]];
        dateStr = @"明天";
    }else{
        do {
            [todayHourArr addObject:[NSString stringWithFormat:@"%ld",(long)newHour]];
            newHour ++;
//            NSLog(@"%ld",(long)newHour);
        } while (newHour < 24);
        dateStr = @"今天";
    }
//    NSLog(@"todayHourArrtodayHourArr%@",todayHourArr);
    [self creatPickView];
}
-(void)creatPickView{
    self.timePickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.timePickBgView];
    self.timePickBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210, self.view.frame.size.width, 210)];
    [self.timePickBgView addSubview:self.backView];
    self.backView.userInteractionEnabled = YES;
    self.backView.backgroundColor= [UIColor lightGrayColor];
    
    self.pickView = [[UIPickerView alloc] init];
    self.pickView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.pickView];
    self.pickView.delegate = self;
    self.pickView.dataSource = self;
    self.pickView.showsSelectionIndicator = YES;
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(180);
    }];
    
    //黑条
    self.lineView2 = [[UIView alloc]init];
    [self.backView addSubview:self.lineView2];
    self.lineView2.backgroundColor = [UIColor whiteColor];
    self.lineView2.userInteractionEnabled= YES;
    [self.lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.left.equalTo(self.backView.mas_left);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(40);
    }];
    
    //确定按钮
    UIButton *centerbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    centerbtn2.backgroundColor = [UIColor whiteColor];
    [self.lineView2 addSubview:centerbtn2];
    [centerbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.right.equalTo(self.backView.mas_right);
    }];
    [centerbtn2 setTitle:@"确定" forState:0];
    [centerbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [centerbtn2 addTarget:self action:@selector(centerbtn2Action) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    UIButton *cancelbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn2.backgroundColor = [UIColor whiteColor];
    [self.lineView2 addSubview:cancelbtn2];
    [cancelbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.left.equalTo(self.backView.mas_left);
    }];
    [cancelbtn2 setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [cancelbtn2 addTarget:self action:@selector(cancelbtn2Action) forControlEvents:UIControlEventTouchUpInside];
    //中间label
    UILabel *chooseL2 = [[UILabel alloc]init];
    chooseL2.text = @"选择上车时间";
    chooseL2.textAlignment = NSTextAlignmentCenter;
    chooseL2.backgroundColor = [UIColor whiteColor];
    chooseL2.textColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    [self.lineView2 addSubview:chooseL2];
    [chooseL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickView.mas_top);
        make.left.equalTo(cancelbtn2.mas_right);
        make.right.equalTo(centerbtn2.mas_left);
        make.height.mas_offset(40);
    }];
}
-(void)creatNumberPickView{
    self.numberPickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.numberPickBgView];
    self.numberPickBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.numberBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210, self.view.frame.size.width, 210)];
    [self.numberPickBgView addSubview:self.numberBackView];
    self.numberBackView.userInteractionEnabled = YES;
    self.numberBackView.backgroundColor= [UIColor lightGrayColor];
    
    self.numberPickView = [[UIPickerView alloc] init];
    self.numberPickView.backgroundColor = [UIColor whiteColor];
    [self.numberBackView addSubview:self.numberPickView];
    self.numberPickView.delegate = self;
    self.numberPickView.dataSource = self;
    self.numberPickView.showsSelectionIndicator = YES;
    [self.numberPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(180);
    }];
    
    //黑条
    self.numberLineView2 = [[UIView alloc]init];
    [self.numberBackView addSubview:self.numberLineView2];
    self.numberLineView2.backgroundColor = [UIColor whiteColor];
    self.numberLineView2.userInteractionEnabled= YES;
    [self.numberLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.left.equalTo(self.numberBackView.mas_left);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(40);
    }];
    
    //确定按钮
    UIButton *centerbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    centerbtn2.backgroundColor = [UIColor whiteColor];
    [self.numberLineView2 addSubview:centerbtn2];
    [centerbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.right.equalTo(self.numberBackView.mas_right);
    }];
    [centerbtn2 setTitle:@"确定" forState:0];
    [centerbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [centerbtn2 addTarget:self action:@selector(numCAction) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    UIButton *cancelbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn2.backgroundColor = [UIColor whiteColor];
    [self.numberLineView2 addSubview:cancelbtn2];
    [cancelbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.left.equalTo(self.numberBackView.mas_left);
    }];
    [cancelbtn2 setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [cancelbtn2 addTarget:self action:@selector(numberCancelAction) forControlEvents:UIControlEventTouchUpInside];
    //中间label
    UILabel *chooseL2 = [[UILabel alloc]init];
    chooseL2.text = @"选择上车人数";
    chooseL2.textAlignment = NSTextAlignmentCenter;
    chooseL2.backgroundColor = [UIColor whiteColor];
    chooseL2.textColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    [self.numberLineView2 addSubview:chooseL2];
    [chooseL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.numberPickView.mas_top);
        make.left.equalTo(cancelbtn2.mas_right);
        make.right.equalTo(centerbtn2.mas_left);
        make.height.mas_offset(40);
    }];
}
-(void)numCAction{
    [self.numberBtn setTitle:[NSString stringWithFormat:@"%@人",self.numberStr] forState:(UIControlStateNormal)];
    [self numberCancelAction];
}
-(void)numberCancelAction{
    [UIView animateWithDuration:0.6 animations:^{
        [self.numberPickView removeFromSuperview];
        [self.numberBackView removeFromSuperview];
        [self.numberPickBgView removeFromSuperview];
    }];
}
-(void)creatParcelPickView{
    self.parcelPickBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    [self.view addSubview:self.parcelPickBgView];
    self.parcelPickBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    
    self.parcelBackView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 210, self.view.frame.size.width, 210)];
    [self.parcelPickBgView addSubview:self.parcelBackView];
    self.parcelBackView.userInteractionEnabled = YES;
    self.parcelBackView.backgroundColor= [UIColor lightGrayColor];
    
    self.parcelPickView = [[UIPickerView alloc] init];
    self.parcelPickView.backgroundColor = [UIColor whiteColor];
    [self.parcelBackView addSubview:self.parcelPickView];
    self.parcelPickView.delegate = self;
    self.parcelPickView.dataSource = self;
    self.parcelPickView.showsSelectionIndicator = YES;
    [self.parcelPickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(180);
    }];
    
    //黑条
    self.parcelLineView2 = [[UIView alloc]init];
    [self.parcelBackView addSubview:self.parcelLineView2];
    self.parcelLineView2.backgroundColor = [UIColor whiteColor];
    self.parcelLineView2.userInteractionEnabled= YES;
    [self.parcelLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.parcelPickView.mas_top);
        make.left.equalTo(self.parcelBackView.mas_left);
        make.width.mas_offset(self.view.frame.size.width);
        make.height.mas_offset(40);
    }];
    
    //确定按钮
    UIButton *centerbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    centerbtn2.backgroundColor = [UIColor whiteColor];
    [self.parcelLineView2 addSubview:centerbtn2];
    [centerbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.parcelPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.right.equalTo(self.parcelBackView.mas_right);
    }];
    [centerbtn2 setTitle:@"确定" forState:0];
    [centerbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [centerbtn2 addTarget:self action:@selector(parcelAction) forControlEvents:UIControlEventTouchUpInside];
    //取消按钮
    UIButton *cancelbtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelbtn2.backgroundColor = [UIColor whiteColor];
    [self.parcelLineView2 addSubview:cancelbtn2];
    [cancelbtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.parcelPickView.mas_top);
        make.width.mas_offset(60);
        make.height.mas_offset(40);
        make.left.equalTo(self.parcelBackView.mas_left);
    }];
    [cancelbtn2 setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn2 setTintColor:[UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1]];
    [cancelbtn2 addTarget:self action:@selector(parcelCancelAction) forControlEvents:UIControlEventTouchUpInside];
    //中间label
    UILabel *chooseL2 = [[UILabel alloc]init];
    chooseL2.text = @"选择剩余行李数量";
    chooseL2.textAlignment = NSTextAlignmentCenter;
    chooseL2.backgroundColor = [UIColor whiteColor];
    chooseL2.textColor = [UIColor colorWithRed:65.0/255 green:164.0/255 blue:249.0/255 alpha:1];
    [self.parcelLineView2 addSubview:chooseL2];
    [chooseL2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.parcelPickView.mas_top);
        make.left.equalTo(cancelbtn2.mas_right);
        make.right.equalTo(centerbtn2.mas_left);
        make.height.mas_offset(40);
    }];
}
-(void)parcelAction{
    [self.parcelBtn setTitle:[NSString stringWithFormat:@"%@件",self.parcelStr] forState:(UIControlStateNormal)];
    self.httpParcelStr = self.parcelStr;
    [self parcelCancelAction];
}
-(void)parcelCancelAction{
    [UIView animateWithDuration:0.6 animations:^{
        [self.parcelPickView removeFromSuperview];
        [self.parcelBackView removeFromSuperview];
        [self.parcelPickBgView removeFromSuperview];
    }];
}
//设置导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 定位相关

- (void)getLocation{
    [AMapServices sharedServices].enableHTTPS = YES;
        self.locationManager = [[AMapLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        self.locationManager.locationTimeout =5;
        self.locationManager.reGeocodeTimeout = 5;
    __weak typeof(self) weakSelf = self;
        [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
            
            if (error)
            {
    //            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
                
                if (error.code == AMapLocationErrorLocateFailed)
                {
                    return;
                }
            }
            
    //        NSLog(@"location:%@", location);
            
            if (regeocode)
            {
//                NSLog(@"reGeocode:%@", regeocode);
                weakSelf.startAdLB.text = regeocode.POIName;
                weakSelf.startAddressLB.text = regeocode.formattedAddress;
                weakSelf.start_province = regeocode.province;
                weakSelf.start_city = regeocode.city;
                weakSelf.start_county = regeocode.district;
                weakSelf.start_name = regeocode.POIName;
                weakSelf.start_address = regeocode.formattedAddress;
                weakSelf.start_lng = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
                weakSelf.start_lat = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
                
            }
        }];
}


-(void)getDistance{
    
    if (![self.start_lat isEqualToString:@""] && ![self.start_lng isEqualToString:@""] && ![self.end_lat isEqualToString:@""] && ![self.end_lng isEqualToString:@""]) {
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;

    navi.strategy=2;

    /* 出发点. */
    navi.origin = [AMapGeoPoint locationWithLatitude:[self.start_lat floatValue]
                                           longitude:[self.start_lng floatValue]];
    /* 目的地. */
    navi.destination = [AMapGeoPoint locationWithLatitude:[self.end_lat floatValue]
                                                longitude:[self.end_lng floatValue]];



    [_search AMapDrivingRouteSearch:navi];//开始查费用距离时间
    }
}

//查询费用距离时间结果
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    AMapRouteSearchResponse *naviResponse = response;

    if (naviResponse.route == nil)
    {
        [CYTSI otherShowTostWithString:@"获取路径失败"];
        return;
    }
    AMapPath * path = [naviResponse.route.paths firstObject];
    self.distanceLB.hidden = NO;
    self.distanceLB.text= [NSString stringWithFormat:@"本行程公里数 %.2f km，大约行驶%.2f小时",path.distance / 1000.f, path.duration/3600.f];
}


#pragma mark - startTapDidClick

- (void)startTapDidClick{
    ITAddressViewController *vc = [[ITAddressViewController  alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.addressBlock = ^(NSDictionary * _Nonnull addressDic) {
      weakSelf.startAdLB.text = addressDic[@"name"];
      weakSelf.startAddressLB.text =  addressDic[@"address"];
      weakSelf.start_province =  addressDic[@"province"];
      weakSelf.start_city =  addressDic[@"city"];
      weakSelf.start_county =  addressDic[@"county"];
      weakSelf.start_name =  addressDic[@"name"];
      weakSelf.start_address =  addressDic[@"address"];
      weakSelf.start_lng = addressDic[@"lng"];
      weakSelf.start_lat = addressDic[@"lat"];
      [weakSelf getDistance];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - endTapDidClick

- (void)endTapDidClick{
   ITAddressViewController *vc = [[ITAddressViewController  alloc] init];
    __weak typeof(self) weakSelf = self;
    vc.addressBlock = ^(NSDictionary * _Nonnull addressDic) {
      weakSelf.endAdLB.text = addressDic[@"name"];
      weakSelf.endAddressLB.text =  addressDic[@"address"];
      weakSelf.end_province =  addressDic[@"province"];
      weakSelf.end_city =  addressDic[@"city"];
      weakSelf.end_county =  addressDic[@"county"];
      weakSelf.end_name =  addressDic[@"name"];
      weakSelf.end_address =  addressDic[@"address"];
      weakSelf.end_lng = addressDic[@"lng"];
      weakSelf.end_lat = addressDic[@"lat"];
     [weakSelf getDistance];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
