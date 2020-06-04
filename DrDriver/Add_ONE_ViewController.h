//
//  Add_ONE_ViewController.h
//  DrDriver
//
//  Created by D.F on 2017/12/27.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"

@interface Add_ONE_ViewController : UIViewController
- (IBAction)didClickToChoosePicture:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_12;//新添手持身份证

@property (weak, nonatomic) IBOutlet UIView *View_11;
@property (weak, nonatomic) IBOutlet UILabel *Alert_Label;
@property (weak, nonatomic) IBOutlet UIView *View_1;

@property (weak, nonatomic) IBOutlet UIView *View_4;
- (IBAction)didClickToCleanNameField:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *Name_Field;
@property (weak, nonatomic) IBOutlet UIView *View_5;
@property (weak, nonatomic) IBOutlet UITextField *IDCard_Field;
@property (weak, nonatomic) IBOutlet UIView *View_6;
@property (weak, nonatomic) IBOutlet UITextField *DriveNumber_Field;
@property (weak, nonatomic) IBOutlet UIView *VIew_7;
- (IBAction)didClickToSex:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *Sex_Label;
@property (weak, nonatomic) IBOutlet UIView *View_8;
- (IBAction)didClickToChooseDrivePIC:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *CompanyName_Field;
@property (weak, nonatomic) IBOutlet UIView *View_9;
@property (weak, nonatomic) IBOutlet UIButton *DriveCard_BTN;
@property (weak, nonatomic) IBOutlet UIView *View_10;
@property (weak, nonatomic) IBOutlet UIButton *Permit_BTN;

@property (weak, nonatomic) IBOutlet UIButton *IdCar_BTN;//身份证信息

- (IBAction)didClickToChoosePermit:(UIButton *)sender;
- (IBAction)didClickToNext:(UIButton *)sender;

//点击选择上传身份证按钮
- (IBAction)didClickToChooseIdCard:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (nonatomic,strong) NSString * choosedCity;//已选择的城市
@property (nonatomic,strong) DriverModel * driver;
@property (nonatomic, strong)NSDictionary * ModelDic;
@property (nonatomic,copy) NSString *driver_class;//车辆类型


@property(nonatomic,copy)NSString *faceState;
@end
