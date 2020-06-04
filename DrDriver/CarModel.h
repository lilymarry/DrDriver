//
//  CarModel.h
//  DrDriver
//
//  Created by mac on 2017/8/16.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarModel : NSObject

@property (nonatomic, strong) NSString * brand_id;//品牌ID
@property (nonatomic, strong) NSString * brand_name;//品牌名称
@property (nonatomic, strong) NSArray * vehicle_style;//子品牌
@property (nonatomic, strong) NSString * intro;


@property (nonatomic, strong) NSString * color_id;//颜色ID
@property (nonatomic, strong) NSString * color_name;//颜色名称

@end
