//
//  TuiSongTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/7/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TuiSongTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *carTypeLB;
@property(nonatomic,strong)UILabel *timeLB;
@property(nonatomic,strong)UILabel *travelStateLB;

@property(nonatomic,strong)UIImageView *startImageView;
@property(nonatomic,strong)UILabel *startNameLB;
@property(nonatomic,strong)UILabel *startAddressLB;
@property(nonatomic,strong)UIImageView *endImageView;
@property(nonatomic,strong)UILabel *endNameLB;
@property(nonatomic,strong)UILabel *endAddressLB;

@property(nonatomic,strong)UILabel *userDistanceLB;
@property(nonatomic,strong)UILabel *distanceLB;
@property(nonatomic,strong)UILabel *priceLB;

-(void)setDataDic:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
