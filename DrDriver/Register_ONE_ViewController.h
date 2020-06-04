//
//  Register_ONE_ViewController.h
//  DrDriver
//
//  Created by D.F on 2017/12/25.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"

@interface Register_ONE_ViewController : UIViewController
- (IBAction)didClickToChoosePicture:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_1;

@property (weak, nonatomic) IBOutlet UIView *View_4;
@property (weak, nonatomic) IBOutlet UITextField *Name_Field;
- (IBAction)didClickToCleanNameField:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_5;
@property (weak, nonatomic) IBOutlet UITextField *IDCard_Field;
@property (weak, nonatomic) IBOutlet UIView *View_6;
@property (weak, nonatomic) IBOutlet UITextField *DriveNumber_Field;
@property (weak, nonatomic) IBOutlet UIView *VIew_7;
@property (weak, nonatomic) IBOutlet UILabel *Sex_Label;
- (IBAction)didClickToSex:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_8;
@property (weak, nonatomic) IBOutlet UITextField *CompanyName_Field;
@property (weak, nonatomic) IBOutlet UIView *View_9;
- (IBAction)didClickToChooseDrivePIC:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *DriveCard_BTN;
@property (weak, nonatomic) IBOutlet UIView *View_10;
@property (weak, nonatomic) IBOutlet UIView *View_11;//新增手持身份证

@property (weak, nonatomic) IBOutlet UIButton *idCard_BTN;//身份证按钮

- (IBAction)didClickToChangeIdCard:(UIButton *)sender;//点击选择身份

- (IBAction)didClickToChoosePermit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *Permit_BTN;
- (IBAction)didClickToNext:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic,strong) NSString * choosedCity;//已选择的城市
@property (nonatomic,copy) NSString * driver_class;//车辆类型
@property (nonatomic,strong) DriverModel * driver;
@end
