//
//  SchoolFirstViewCell.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/14.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SLContract, SLTripList;
/// 校园拼cell
@interface SchoolViewCell : UITableViewCell

@property(nonatomic, strong, readwrite) SLContract *contract;
@property(nonatomic, strong, readwrite) SLTripList *tripList;


@end

NS_ASSUME_NONNULL_END
