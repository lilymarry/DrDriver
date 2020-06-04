//
//  Register_TWO_ViewController.h
//  DrDriver
//
//  Created by D.F on 2017/12/26.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DriverModel.h"
#import "CarModel.h"
@interface Register_TWO_ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *View_1;
@property (weak, nonatomic) IBOutlet UITextField *Name_Field;
- (IBAction)didClickToTime:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_2;
@property (weak, nonatomic) IBOutlet UILabel *Time_Label;
@property (weak, nonatomic) IBOutlet UIView *View_3;
@property (weak, nonatomic) IBOutlet UILabel *Brand_Label;
@property (weak, nonatomic) IBOutlet UILabel *Color_Label;
- (IBAction)didClickToChooseBrand:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_4;
@property (weak, nonatomic) IBOutlet UIView *View_5;
@property (weak, nonatomic) IBOutlet UITextField *Number_Field;
- (IBAction)didClickToChooseColor:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *View_6;
- (IBAction)didClickToChooseDriveCard:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *DriveCard_BTN;
@property (weak, nonatomic) IBOutlet UIView *View_7;
- (IBAction)didClickToChoosePIC:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *PIC_BTN;
- (IBAction)didClickToSend:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *yunshuzhengBtn;
- (IBAction)yunshuzheng:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *yunshuzhengNumber;
@property (nonatomic,strong) DriverModel * driver;
@property (nonatomic,strong) CarModel * carColor;//车辆颜色
@property (strong, nonatomic) IBOutlet UITextField *hezaiNumber;
@property (strong, nonatomic) IBOutlet UITextField *VinTf;
@property (strong, nonatomic) IBOutlet UITextField *engineTF;
- (IBAction)compulsory:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *compulsory;

- (IBAction)commercial:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *commercial;
- (IBAction)contract1:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *contract1;
- (IBAction)contract2:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *contract2;
- (IBAction)contract3:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *contract3;
@property (nonatomic,strong) NSString * carBrandName;//车辆大品牌
@property (nonatomic,strong) NSString * vehicleStyle;//车辆详细品牌
@property (nonatomic, strong) NSMutableDictionary * DrivedateDic;

@end
