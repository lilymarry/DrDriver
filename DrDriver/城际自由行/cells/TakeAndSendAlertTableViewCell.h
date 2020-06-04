//
//  TakeAndSendAlertTableViewCell.h
//  DrDriver
//
//  Created by fy on 2019/3/13.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeAndSendAlertTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *numberLB;
-(void)setData:(NSString *)title number:(float)number;

@end

NS_ASSUME_NONNULL_END
