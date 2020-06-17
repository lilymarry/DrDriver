//
//  SLTripDetailTableViewCell.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/24.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLStudent;

@protocol  SLTripDetailTableViewCellDelegate<NSObject>

- (void)tableViewCell:(UITableViewCell *_Nullable)tableViewCell clickTellPhoneButton:(NSString *_Nonnull)phoneStr;

- (void)tableViewCell:(UITableViewCell *_Nullable)tableViewCell clickStateButton:(SLStudent *_Nullable)student;

- (void)tableViewCell:(UITableViewCell *_Nullable)tableViewCell clickPhotoButton:(SLStudent *_Nullable)student;

- (void)clickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)otherStateClickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)passengerTakeDrive:(SLStudent *_Nullable)student;

- (void)moreBtnClick:(NSString *_Nullable)studentStr;

- (void)cancelBtnClick:(NSString *_Nullable)orderStr;



@end


@interface SLTripDetailTableViewCell : UITableViewCell

@property(nonatomic, strong, readwrite)SLStudent * _Nullable  student;

@property(nonatomic, copy, readwrite)void (^ _Nullable tellBlock)(NSString * _Nullable tellStr);

@property(nonatomic, weak, readwrite)id<SLTripDetailTableViewCellDelegate> _Nullable delagte;

@property(nonatomic, strong) UIButton * _Nullable btn;//更多按钮

@property(nonatomic, strong)UIButton *_Nullable telButton;//联系乘客
@property (nonatomic, strong, readwrite) UIButton * _Nullable statu_button;//状态
@property (nonatomic, strong, readwrite) UILabel *_Nullable in_school_Lable;//时间名称
@end

