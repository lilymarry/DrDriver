//
//  SLMoreInfoTableViewCell.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/2.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class ChildMoreModel;
@interface SLMoreInfoTableViewCell : UITableViewCell

@property(nonatomic,strong,readwrite)ChildMoreModel *childmore;
@end

NS_ASSUME_NONNULL_END
