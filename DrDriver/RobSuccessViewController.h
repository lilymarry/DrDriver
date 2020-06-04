//
//  RobSuccessViewController.h
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapLocationKit/AMapLocationKit.h>

@interface RobSuccessViewController : UIViewController

@property (nonatomic, assign) CLLocationCoordinate2D endCoordinate;//终点的经纬度(订单终点)
@property (nonatomic,strong) NSString * endAddress;//结束地址(订单终点)
@property (nonatomic,strong) NSString * endName;
@property (nonatomic,strong) NSString * orderID;//订单id
@property (nonatomic,strong) NSString * journey_fee;//快车费用
@property (nonatomic,assign) NSInteger order_class;//订单类型  1:快车 2：出租车
@property (nonatomic,assign) NSInteger submit_class;//叫车类型 1:普通叫车 2:摇一摇叫车

@property (nonatomic, assign) CLLocationCoordinate2D userStartCoordinate;//终点的经纬度(订单起点)
@property (nonatomic,strong) NSString * userStartAddress;//结束地址(订单起点)
@property (nonatomic,strong) NSString * userStartname;//结束地址(订单起点)
@property (nonatomic,strong) NSString * userName;//乘客姓名
@property (nonatomic,strong) NSString * m_card_number;
@property (nonatomic,strong) NSString * userPhone;//乘客电话
@property (nonatomic,strong) NSString * cust_phone;//客服电话
@property (nonatomic,strong) NSString * m_header;//乘客头像

//从进行中的订单点击进来需要的参数
@property (nonatomic,assign) BOOL isOrderList;//是否是从进行中的订单进来的
@property (nonatomic,assign) NSInteger orderState;//订单状态
@property (nonatomic,copy) NSString *appoint_type;//0及时单 1预约单 2接机单
@property (copy, nonatomic) NSString *appoint_time;//预约的时间
@property (copy, nonatomic) NSString *flight_number;//航班号
@property (copy, nonatomic) NSString *user_real_phone;
@property(copy,nonatomic)NSString *remarkStr;//备注
//结束订单时设置首页开始听单
@property (nonatomic,strong) void (^AlreadyListenBlock)();
@property(nonatomic,copy)NSString *flight_date;

//移除地图数据
-(void)clearMapView;

@end
