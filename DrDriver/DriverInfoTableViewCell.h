//
//  DriverInfoTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/10/28.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DriverInfoTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *topTitleLB;
@property(nonatomic,strong)UILabel *xingLB;

@property(nonatomic,strong)UIView *tfView;
@property(nonatomic,strong)UITextField *tf;

@property(nonatomic,strong)UIView *lbView;
@property(nonatomic,strong)UILabel *lbDetailLB;
@property(nonatomic,strong)UIImageView *lbArrowImageView;

@property(nonatomic,strong)UIView *photoView;
@property(nonatomic,strong)UILabel *photoTopDetailLB;
@property(nonatomic,strong)UILabel *photoBottomDetailLB;
@property(nonatomic,strong)UIButton *photoBtn;


@property(nonatomic,copy)void (^photoBlock)(NSInteger ipIow);

@property(nonatomic,assign)NSInteger ipIow;


-(void)setDataDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
