//
//  PerfectTwoTableViewCell.h
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectTwoTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImageView;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITextField *theTextFiled;
@property (strong, nonatomic) IBOutlet UIButton *clickedButton;

//设置cell类型
-(void)setCellType;

@end
