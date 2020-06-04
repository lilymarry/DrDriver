//
//  TakeAndSendView.h
//  DrDriver
//
//  Created by fy on 2019/3/13.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeAndSendAlertTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeAndSendView : UIView<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *alertView;

@property(nonatomic,strong)UILabel *takeLB;
@property(nonatomic,strong)UILabel *sendLB;
@property(nonatomic,strong)UITableView *takeTableView;
@property(nonatomic,strong)UITableView *sendTableView;
@property(nonatomic,strong)UIButton *closeBtn;

@property(nonatomic,strong)NSArray *takeArr;
@property(nonatomic,strong)NSArray *sendArr;

-(void)showAlertViewTake:(NSArray *)takeArr send:(NSArray *)sendArr;
-(void)hiddenAlertView;

@end

NS_ASSUME_NONNULL_END
