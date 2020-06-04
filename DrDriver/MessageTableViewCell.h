//
//  MessageTableViewCell.h
//  DrUser
//
//  Created by fy on 2018/10/12.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *imView;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *detailLB;
@property(nonatomic,strong)UILabel *timeLB;

@end
