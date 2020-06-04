//
//  GetOrderAlertView.h
//  DrDriver
//
//  Created by fy on 2019/2/25.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetOrderAlertView : UIView

@property(nonatomic,strong)UIView *alertView;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *detailLB;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,copy)NSString *travel_id;

-(void)showOrderAlertView:(NSString *)travel_id;
-(void)hidenOrderAlertView;
@property(nonatomic,strong)void (^popViewBlock)(NSString *travel_id);

@end

NS_ASSUME_NONNULL_END
