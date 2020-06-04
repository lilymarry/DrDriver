//
//  Register_ONE_ViewController.m
//  DrDriver
//
//  Created by D.F on 2017/12/25.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//
#import "ChooseCityViewController.h"
#import "Register_ONE_ViewController.h"
#import "Register_TWO_ViewController.h"
#import "GYZChooseCityController.h"
#import "CityListViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface Register_ONE_ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,GYZChooseCityDelegate,CityListViewDelegate>
{
    NSInteger alertType;
    UITableView * myTableView;
    NSArray * titleArray;//标题数组
    UIActionSheet * mySheet;
    UIActionSheet * sexSheet;
     NSInteger photoType;//上传类型 1:头像   2:行驶证 3:从业资格证
    BOOL isSex;//是否是选择性别
    NSMutableDictionary * chooseDic;//选择的字典
    
}
@property (nonatomic, strong) NSMutableDictionary * DateDic;

@end

@implementation Register_ONE_ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"self.choosedCityself.choosedCityself.choosedCity%@",self.choosedCity);
//    if (self.choosedCity == nil) {
//        NSLog(@"111111");
//        self.Address_Label.text = @"获取当前位置失败，请选择手动获取";
//    }else if ([self.choosedCity isKindOfClass:[NSNull class]]){
//        NSLog(@"222222");
//        self.Address_Label.text = @"获取当前位置失败，请选择手动获取";
//    }else if ([self.choosedCity isEqual:[NSNull null]]){
//        NSLog(@"333333");
//        self.Address_Label.text = @"获取当前位置失败，请选择手动获取";
//    }else if (_choosedCity.length<1) {
//        NSLog(@"1231230000");
//        self.Address_Label.text = @"获取当前位置失败，请选择手动获取";
//    }else if([self.choosedCity isEqualToString:@"(null)"]){
//        NSLog(@"0000000");
//        self.Address_Label.text = @"获取当前位置失败，请选择手动获取";
//    }else{
//        NSLog(@"zzzzzz");
//        self.Address_Label.text = [NSString stringWithFormat:@"%@(所在城市)",_choosedCity];
//    }

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    [self setUpNav];//创建导航栏
    [self setViewLayer];//设置10个小view的layer层
    self.DateDic = [[NSMutableDictionary alloc] init];
   // isSex = YES;
    alertType =0 ;
    // Do any additional setup after loading the view.
    
    
}
//创建导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}


//上传头像
- (IBAction)didClickToChoosePicture:(UIButton *)sender {
    
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
#pragma mark  acionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertType!=0) {
        if (alertType == 1) {
//            alertType = 0;
//            if (buttonIndex==0) {//
//
//                self.Type_Label.text = @"出租车";
//
//            } else if(buttonIndex == 1){//
//                self.Type_Label.text = @"快车";
//
//
//            }else if(buttonIndex == 2){
//                self.Type_Label.text = @"扫码车";
//            }else if(buttonIndex == 3){
//                self.Type_Label.text = @"专车";
//            }else if(buttonIndex == 4){
//                self.Type_Label.text = @"豪华车";
//            }else if(buttonIndex == 5){
//                self.Type_Label.text = @"包车";
//            }else if(buttonIndex == 6){
//                self.Type_Label.text = @"出租快车";
//            }else if(buttonIndex == 7){
//                self.Type_Label.text = @"城际自由行";
//            }

        }else if(alertType ==2){
            alertType =0 ;
            if (buttonIndex==0) {//男
                
                self.Sex_Label.text = @"男";
                
                
            } else if (buttonIndex==1){//女
                
                self.Sex_Label.text = @"女";
                
            }else{
                
               self.Sex_Label.text = @"保密";
            }
        }
    }else{
        NSInteger sourceType=0;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                {
                    //    iOS 判断应用是否有使用相机的权限
                    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
                    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
                        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往", nil];
                        [alter show];
                    }else{
                        sourceType=UIImagePickerControllerSourceTypeCamera;
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nofirst"];
                        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        
                        imagePickerController.delegate = self;
                        
                        imagePickerController.sourceType = sourceType;
                        
                        [self presentViewController:imagePickerController animated:YES completion:^{
                        }];
                    }
                    
                }
                    break;
                case 1:
                {
                    //相册
                    sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nofirst"];
                    // 跳转到相机或相册页面
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    
                    imagePickerController.delegate = self;
                    
                    imagePickerController.sourceType = sourceType;
                    
                    [self presentViewController:imagePickerController animated:YES completion:^{
                    }];
                }
                    break;
                case 2:
                {
                    //取消
                    return;
                    
                }
                    break;
                default:
                    break;
            }
        } else {
            if (buttonIndex==2) {
                //取消
                return;
            } else {
                //相册
                sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                
                imagePickerController.delegate = self;
                
                imagePickerController.sourceType = sourceType;
                
                [self presentViewController:imagePickerController animated:YES completion:^{
                }];
            }
        }
}
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if (buttonIndex == 1){
        NSURL * url = [NSURL URLWithString: UIApplicationOpenSettingsURLString];
        
        if ( [[UIApplication sharedApplication] canOpenURL: url] ) {
            
            NSURL*url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //   UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString * photoTypeStr=@"";
    switch (photoType) {
        case 100:
        {
            photoTypeStr=@"Head_PIC";
            _headImage.image=image;
            [self.DateDic setObject:image forKey:photoTypeStr];

        }
            break;
        case 101:
        {
            photoTypeStr=@"DriveCard_PIC";
            [_DriveCard_BTN setImage:image forState:UIControlStateNormal];
            [self.DateDic setObject:image forKey:photoTypeStr];

        }
            break;
        case 102:
        {
            photoTypeStr=@"Permit_PIC";
            [_Permit_BTN setImage:image forState:UIControlStateNormal];

            [self.DateDic setObject:image forKey:photoTypeStr];
        }
            
            break;
            
        case 103:
        {
            photoTypeStr=@"IdCar_PIC";
            [_idCard_BTN setImage:image forState:UIControlStateNormal];
            [self.DateDic setObject:image forKey:photoTypeStr];
        }
            
            break;
         
        default:
            break;
    }
    
    
    
}
//-(void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
//{
//    
//    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.1);
//    // 获取沙盒目录
//    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
//    
//    // 将图片写入文件
//    [imageData writeToFile:fullPath atomically:NO];
//}

//选择司机类型
- (IBAction)didClickToChooseType:(UIButton *)sender {
  
    sexSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"出租车",@"快车",@"扫码车",@"专车",@"豪华车",@"包车",@"出租快车",@"自由行", nil];
       alertType = 1;
    [sexSheet showInView:self.view];
}
//选择所在城市
- (IBAction)didClickToCity:(UIButton *)sender {    
    CityListViewController *cityListView = [[CityListViewController alloc]init];
    cityListView.delegate = self;
    //热门城市列表
    cityListView.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
    //定位城市列表
    cityListView.arrayLocatingCity   = [NSMutableArray arrayWithObjects:@"天津", nil];
    cityListView.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:cityListView animated:YES completion:nil];
    
}
#pragma mark - CityListViewDelegate
- (void)didClickedWithCityName:(NSString*)cityName
{
//    self.choosedCity  = cityName;
}
#pragma mark - GYZCityPickerDelegate
- (void) cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    //[chooseCityBtn setTitle:city.cityName forState:UIControlStateNormal];
//    self.choosedCity  = city.cityName;
    [chooseCityController.navigationController popViewControllerAnimated:YES];
}

- (void) cityPickerControllerDidCancel:(GYZChooseCityController *)chooseCityController
{
    [chooseCityController.navigationController popViewControllerAnimated:YES];
}
//清除名字输入框内的文字
- (IBAction)didClickToCleanNameField:(UIButton *)sender {
    _Name_Field.text = @"";
}
//选择性别
- (IBAction)didClickToSex:(UIButton *)sender {
    sexSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女",@"保密", nil];
       alertType = 2;
    [sexSheet showInView:self.view];
    
}
//上传驾驶证
- (IBAction)didClickToChooseDrivePIC:(UIButton *)sender {
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
//上传身份证
- (IBAction)didClickToChangeIdCard:(UIButton *)sender {
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
//上传从业资格证
- (IBAction)didClickToChoosePermit:(UIButton *)sender {
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
//保存数据到下一步
- (IBAction)didClickToNext:(UIButton *)sender {
//    if (headImage==nil) {
//        [CYTSI otherShowTostWithString:@"请选择你的头像"];
//        return;
//    }
//    if (_choosedCity==nil || [_choosedCity isEqualToString:@""]) {
//        [CYTSI otherShowTostWithString:@"请选择你所在的城市"];
//        return;
//    }
    if (_Name_Field.text.length<2) {
        [CYTSI otherShowTostWithString:@"请输入你的真实姓名"];
        return;
    }
    if (![CYTSI validateIDCardNumber:_IDCard_Field.text]) {
        [CYTSI otherShowTostWithString:@"请输入正确的身份证号"];
        return;
    }
//    if ([_Type_Label.text isEqualToString:@"请选择车辆类型"]) {
//        [CYTSI otherShowTostWithString:@"请选择车辆类型"];
//        return;
//    }
//
//    if ([_Type_Label.text isEqualToString:@"出租车"]) {
//
//        [self.DateDic setObject:@"2" forKey:@"DriveType"];
//
//    }else  if([_Type_Label.text isEqualToString:@"快车"]){
//
//        [self.DateDic setObject:@"1" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"扫码车"]){
//
//        [self.DateDic setObject:@"3" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"专车"]){
//
//        [self.DateDic setObject:@"4" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"豪华车"]){
//
//        [self.DateDic setObject:@"5" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"包车"]){
//
//        [self.DateDic setObject:@"6" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"出租快车"]){
//
//        [self.DateDic setObject:@"7" forKey:@"DriveType"];
//
//    }else if([_Type_Label.text isEqualToString:@"城际自由行"]){
//
//        [self.DateDic setObject:@"8" forKey:@"DriveType"];
//
//    }
    if ([_Sex_Label.text isEqualToString:@"男"]) {
       [self.DateDic setObject:@"1" forKey:@"sex"];
    }else if ([_Sex_Label.text isEqualToString:@"女"]) {
        [self.DateDic setObject:@"0" forKey:@"sex"];
    }else {
        [self.DateDic setObject:@"2" forKey:@"sex"];

    }
    [self.DateDic setObject:self.driver_class forKey:@"DriveType"];
    [self.DateDic setObject:_choosedCity forKey:@"DriveCity"];
    [self.DateDic setObject:_Name_Field.text forKey:@"DriveName"];
    [self.DateDic setObject:_IDCard_Field.text forKey:@"DriveIDCard"];
    [self.DateDic setObject:_DriveNumber_Field.text forKey:@"DriveIDNumber"];
    [self.DateDic setObject:_CompanyName_Field.text forKey:@"DriveCompany"];


    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    Register_TWO_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Register_TWO_id"];
    RVC.DrivedateDic = _DateDic;
        RVC.driver=_driver;
   
   [self.navigationController pushViewController:RVC animated:YES];
}
//设置10个小view的layer层
- (void)setViewLayer
{
    self.View_1.layer.masksToBounds = YES;
    self.View_1.layer.cornerRadius=5;
    self.View_1.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_1.layer.borderWidth=0.5;
//    self.View_2.layer.masksToBounds = YES;
//    self.View_2.layer.cornerRadius=5;
//    self.View_2.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
//    self.View_2.layer.borderWidth=0.5;
//    self.View_3.layer.masksToBounds = YES;
//    self.View_3.layer.cornerRadius=5;
//    self.View_3.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
//    self.View_3.layer.borderWidth=0.5;
    self.View_4.layer.masksToBounds = YES;
    self.View_4.layer.cornerRadius=5;
    self.View_4.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_4.layer.borderWidth=0.5;
    self.View_5.layer.masksToBounds = YES;
    self.View_5.layer.cornerRadius=5;
    self.View_5.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_5.layer.borderWidth=0.5;
    self.View_6.layer.masksToBounds = YES;
    self.View_6.layer.cornerRadius=5;
    self.View_6.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_6.layer.borderWidth=0.5;
    self.VIew_7.layer.masksToBounds = YES;
    self.VIew_7.layer.cornerRadius=5;
    self.VIew_7.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.VIew_7.layer.borderWidth=0.5;
    self.View_8.layer.masksToBounds = YES;
    self.View_8.layer.cornerRadius=5;
    self.View_8.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_8.layer.borderWidth=0.5;
    self.View_9.layer.masksToBounds = YES;
    self.View_9.layer.cornerRadius=5;
    self.View_9.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_9.layer.borderWidth=0.5;
    self.View_10.layer.masksToBounds = YES;
    self.View_10.layer.cornerRadius=5;
    self.View_10.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_10.layer.borderWidth=0.5;
    self.View_11.layer.masksToBounds = YES;
    self.View_11.layer.cornerRadius=5;
    self.View_11.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_11.layer.borderWidth=0.5;
    
    
}
//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
