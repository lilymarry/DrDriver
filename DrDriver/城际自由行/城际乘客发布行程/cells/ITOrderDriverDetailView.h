//
//  ITOrderDriverDetailView.h
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CYStarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ITOrderDriverDetailView : UIView
@property(nonatomic,strong)UIImageView *driverHeaderImageView;
@property(nonatomic,strong)UILabel *driverNameLB;
@property(nonatomic,strong)CYStarView *cyStarView;
//@property(nonatomic,strong)UILabel *carNumberLB;
@property(nonatomic,strong)UIButton *telePhoneNumberBtn;
//@property(nonatomic,strong)UILabel *carTypeLB;
@property(nonatomic,strong)UILabel *remarkLB;
//@property(nonatomic,strong)UILabel *sumNumberLB;
//@property(nonatomic,copy)NSString *state;
@property(nonatomic,strong)UIImageView *luggage_numImageView;
@property(nonatomic,strong)UILabel *luggage_numLB;

-(void)setData:(NSDictionary *)dataDic;
@property(nonatomic, copy)NSString *driver_phone;


@end

NS_ASSUME_NONNULL_END
