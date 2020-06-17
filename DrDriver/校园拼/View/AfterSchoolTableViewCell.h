//
//  AfterSchoolTableViewCell.h
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/30.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SLStudent;

@protocol  AfterSchoolTableViewCellDelegate<NSObject>

- (void)clickTellPhoneButton:(NSString *_Nonnull)phoneStr;

- (void)clickStateButton:(SLStudent *_Nullable)student;

- (void)clickPhotoButton:(NSString *_Nullable)order_id;

- (void)clickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)otherStateClickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)passengerTakeDrive:(SLStudent *_Nullable)student;

- (void)moreBtnClick:(NSString *_Nullable)studentStr;

- (void)skipBtnClick:(NSString *_Nullable)orderStr withType:(NSString *_Nullable)type;


@end

NS_ASSUME_NONNULL_BEGIN

@interface AfterSchoolTableViewCell : UITableViewCell

@property(nonatomic, strong, readwrite)SLStudent * _Nullable  student;

@property(nonatomic, copy, readwrite)void (^ _Nullable tellBlock)(NSString * _Nullable tellStr);

@property(nonatomic, weak, readwrite)id<AfterSchoolTableViewCellDelegate> _Nullable delagte;

@end

NS_ASSUME_NONNULL_END
