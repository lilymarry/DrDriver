//
//  CYOrderView.h
//  DrDriver
//
//  Created by mac on 2017/6/19.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYAddressView.h"

@interface CYOrderView : UIView

@property (nonatomic,strong) NSString * startStr;//开始位置
@property (nonatomic,strong) NSString * endStr;//结束位置

@property (nonatomic,strong) UILabel * startDistanceLable;//接驾距离
@property (nonatomic,strong) UILabel * allDistanceLable;//全程距离

@property (nonatomic,strong) UILabel * yuYueLable;//预约日期
@property (nonatomic,strong) UILabel * airPortLable;//航班号
@property (nonatomic,strong) UILabel * airPortDateLable;//航班日期
@property (nonatomic,strong) UIImageView * yuYueAndAirPortImg;//预约、接机显示图片

@property (nonatomic,copy) NSString *stateFlag;//弹窗类型


@property (nonatomic,strong) CYAddressView * addressView;//地址视图
@property (nonatomic,assign) BOOL isShake;//是否是摇一摇叫车

@property (nonatomic,strong) void (^ closeView)();//关闭按钮点击事件
@property (nonatomic,copy) NSString *remark;//备注信息
@property(nonatomic,strong)UILabel *bottomLb;


 @property(nonatomic,strong)UILabel * titleLable;
 @property(nonatomic,strong)UIImageView * bgImageView;

@end
