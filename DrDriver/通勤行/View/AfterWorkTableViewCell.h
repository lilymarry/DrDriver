//
//  AfterWorkTableViewCell.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/5/12.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SLStudent;

@protocol  AfterWorkTableViewCellDelegate<NSObject>

- (void)clickTellPhoneButton:(NSString *_Nonnull)phoneStr;

- (void)clickStateButton:(SLStudent *_Nullable)student;

- (void)clickPhotoButton:(SLStudent *_Nullable)student;

- (void)clickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)otherStateClickMapNavButton:(NSDictionary *_Nullable)dictionary;

- (void)passengerTakeDrive:(SLStudent *_Nullable)student;

- (void)moreBtnClick:(NSString *_Nullable)studentStr;

- (void)skipBtnClick:(NSString *_Nullable)orderStr withType:(NSString *_Nullable)type;


@end

NS_ASSUME_NONNULL_BEGIN

@interface AfterWorkTableViewCell : UITableViewCell

@property(nonatomic, strong, readwrite)SLStudent * _Nullable  student;

@property(nonatomic, copy, readwrite)void (^ _Nullable tellBlock)(NSString * _Nullable tellStr);

@property(nonatomic, weak, readwrite)id<AfterWorkTableViewCellDelegate> _Nullable delagte;

@end

NS_ASSUME_NONNULL_END

