//
//  Register_TWO_ViewController.m
//  DrDriver
//
//  Created by D.F on 2017/12/26.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "ChooseCarTypeViewController.h"
#import "Register_TWO_ViewController.h"
#import "TimePickerView.h"
#import "RegisterProgressView.h"
#import "CYAlertView.h"
#import "AFNetWorking.h"
#import "LoginViewController.h"
#import "UIImage+FixIMG.h"
#import "BJNumberPlateOC.h"
#import <AVFoundation/AVFoundation.h>
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "Add_ONE_ViewController.h"


@interface Register_TWO_ViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,TimePickerViewDelegate>
{
    NSInteger alertType;
    
    UIActionSheet * mySheet;
    NSInteger photoType;//上传类型 1:人车合影   2:行驶证
    BOOL isSex;//是否是选择性别
    NSMutableDictionary * chooseDic;//选择的字典
    CYAlertView * singleAlertView;//单个按钮弹出视图
}
@property (strong, nonatomic)  TimePickerView *timePicker;
@property (nonatomic, strong) NSMutableDictionary * DateDic;
@end

@implementation Register_TWO_ViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_carColor!=nil) {
        self.Color_Label.text = _carColor.color_name;
    }
    //    if (_carBrandName!=nil) {
    //
    //    }
    if (_vehicleStyle!=nil) {
        _Brand_Label.text = [NSString stringWithFormat:@"%@ %@",_carBrandName,_vehicleStyle];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"注册";
    [self setUpNav];//创建导航栏
    [self setViewLayer];//设置10个小view的layer层
    self.DateDic = [[NSMutableDictionary alloc] init];
    
    alertType =0 ;
    //时间选择控件布局
    self.timePicker = [[TimePickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 260, self.view.frame.size.width, 250)];
    self.timePicker.delegate = self;
    [self.view addSubview:_timePicker];
    _timePicker.hidden = YES;
    [self creatAlertView];//创建弹出视图
    // Do any additional setup after loading the view.
    
    BJNumberPlateOC *numberPlate = [[BJNumberPlateOC alloc] initWithFrame:CGRectZero];
    self.Number_Field.inputView = numberPlate;
}


//时间选择
- (IBAction)didClickToTime:(UIButton *)sender {
    _timePicker.hidden = NO;
    [_Name_Field resignFirstResponder];
    [_Number_Field resignFirstResponder];
}

- (void)getTime:(NSDate *)time
{
    _timePicker.hidden =YES;
    //转换时间格式
    NSDateFormatter * df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString * str = [df stringFromDate:time];
    self.Time_Label.text = str;
    
}
-(void)cancleTime
{
    _timePicker.hidden=YES;
    
}
//车牌选择
- (IBAction)didClickToChooseBrand:(UIButton *)sender {
    _timePicker.hidden = YES;
    
    ChooseCarTypeViewController * vc=[[ChooseCarTypeViewController alloc]init];
    vc.type=1;
    [self.navigationController pushViewController:vc animated:YES];
}
//颜色选择
- (IBAction)didClickToChooseColor:(UIButton *)sender {
    _timePicker.hidden = YES;
    
    ChooseCarTypeViewController * vc=[[ChooseCarTypeViewController alloc]init];
    vc.type=2;
    [self.navigationController pushViewController:vc animated:YES];
}
//上传行驶证
- (IBAction)didClickToChooseDriveCard:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
    
}
//上传人车合影
- (IBAction)didClickToChoosePIC:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
    
}
//上传运输证
- (IBAction)yunshuzheng:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
- (IBAction)compulsory:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
- (IBAction)commercial:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
- (IBAction)contract1:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
- (IBAction)contract2:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
- (IBAction)contract3:(UIButton *)sender {
    _timePicker.hidden = YES;
    photoType = sender.tag;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}
#pragma mark  acionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
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
        case 101:
        {
            photoTypeStr=@"manAndCar_PiC";
            [_PIC_BTN setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 102:
        {
            photoTypeStr=@"Drive_PIC";
            [_DriveCard_BTN setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 103:
        {
            photoTypeStr=@"transport_pic";
            [_yunshuzhengBtn setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 104:
        {
            photoTypeStr=@"compulsory_pic";
            [_compulsory setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 105:
        {
            photoTypeStr=@"commercial_pic";
            [_commercial setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 106:
        {
            photoTypeStr=@"contract1_pic";
            [_contract1 setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 107:
        {
            photoTypeStr=@"contract2_pic";
            [_contract2 setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        case 108:
        {
            photoTypeStr=@"contract3_pic";
            [_contract3 setImage:image forState:UIControlStateNormal];
            [_DateDic setObject:image forKey:photoTypeStr];
            
        }
            break;
        default:
            break;
    }
    
    
    
    
}
-(void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

//提交
- (IBAction)didClickToSend:(UIButton *)sender {
    if (_Name_Field.text.length<1) {
        [CYTSI otherShowTostWithString:@"请输入车辆所有人的姓名"];
        return;
    }
    if ([_Time_Label.text isEqualToString:@"请选择注册时间"]) {
        [CYTSI otherShowTostWithString:@"请选择车辆注册时间"];
        return;
    }
    if (_Number_Field.text.length<1) {
        [CYTSI otherShowTostWithString:@"请输入车牌号码"];
        return;
    }
    if ([_Brand_Label.text isEqualToString:@"请选择车辆品牌"]) {
        [CYTSI otherShowTostWithString:@"请输入车辆品牌"];
        return;
    }
    if ([_Color_Label.text isEqualToString:@"请选择车辆颜色"]) {
        [CYTSI otherShowTostWithString:@"请输入车辆颜色"];
        return;
    }
    if ([_DateDic objectForKey:@"manAndCar_PiC"] == nil) {
        [CYTSI otherShowTostWithString:@"请添加人车合影的照片"];
        return;
        
    }
    if (self.hezaiNumber.text.length<1 || ![CYTSI isNumber:self.hezaiNumber.text]) {
        [CYTSI otherShowTostWithString:@"请填写荷载人数"];
        return;
        
    }
    if (self.VinTf.text.length < 1) {
        [CYTSI otherShowTostWithString:@"请输入车辆识别代号(详见行驶证)"];
        return;
    }
    if (self.engineTF.text.length < 1) {
        [CYTSI otherShowTostWithString:@"请输入发动机号(详见行驶证)"];
        return;
    }
    [self uploadMessage];
    
    
}
//创建弹出视图
-(void)creatAlertView
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    
    singleAlertView=[[CYAlertView alloc]initWithFrame:CGRectMake(DeviceWidth, 0, window.frame.size.width, window.frame.size.height)];
    singleAlertView.titleStr=@"提交成功";
    singleAlertView.alertStr=@"恭喜您，资料提交成功且正在审核，审核结果将会以短信形式告知，请耐心等待。";
    singleAlertView.cancleButtonStr=@"";
    singleAlertView.sureButtonStr=@"我知道了";
    [singleAlertView setSingleButton];
    [singleAlertView setTextFiled:YES];
    [window addSubview:singleAlertView];
    
    __weak typeof (singleAlertView) weakSingleAlertView = singleAlertView;
    __weak typeof (self) weakSelf = self;
    singleAlertView.phoneBlock = ^{
        
        [weakSingleAlertView hideAlertView];
        NSArray * vcArray=weakSelf.navigationController.viewControllers;
        for (LoginViewController * vc in vcArray) {
            
            if ([vc isKindOfClass:[LoginViewController class]]) {
                
                //                [CYTSI otherShowTostWithString:@"上传成功"];
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
            
        }
    };
    
}

//上传信息
-(void)uploadMessage
{
    //初始化进度框，置于当前的View当中
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:window];
    
    [window addSubview:HUD];
    
    HUD.bezelView.backgroundColor=[UIColor blackColor];
    HUD.bezelView.alpha=1;
    HUD.label.textColor=[UIColor whiteColor];
    HUD.activityIndicatorColor=[UIColor whiteColor];
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    //设置对话框文字
    HUD.labelText = @"请稍等";
    [HUD showAnimated:YES];
    
    NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_REGISTER_CERTIFICATE_INFO];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dict = @{@"driver_id":_driver.driver_id,
                           @"token":_driver.token,
                           @"city_name":_DrivedateDic[@"DriveCity"],
                           @"driver_class":_DrivedateDic[@"DriveType"],
                           @"driver_sex":_DrivedateDic[@"sex"],
                           @"company_name":_DrivedateDic[@"DriveCompany"],
                           @"driver_number":_DrivedateDic[@"DriveIDCard"],
                           @"driver_name":_DrivedateDic[@"DriveName"],
                           @"driver_license":_DrivedateDic[@"DriveIDNumber"],
                           @"vehicle_number":_Number_Field.text,
                           @"certificate":_yunshuzhengNumber.text,
                           @"vehicle_brand":_carBrandName,
                           @"vehicle_style":_vehicleStyle,
                           @"vehicle_color":_carColor.color_name,
                           @"register_time":_Time_Label.text,
                           @"vehicle_person":_Name_Field.text,
                           @"seat_num":self.hezaiNumber.text,
                           @"vin":self.VinTf.text,
                           @"engineid":self.engineTF.text
                           };
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * dateString=[self getDateStr];
        for (int i=0; i<12; i++) {
            
            NSString * keyStr=@"";
            NSString * imageStr=@"";
            switch (i) {
                case 0:
                {
                    keyStr=@"driver_head";
                    imageStr=@"Head_PIC";
                }
                    break;
                case 1:
                {
                    keyStr=@"license_pic";
                    imageStr=@"DriveCard_PIC";
                }
                    break;
                case 2:
                {
                    keyStr=@"employ_pic";
                    imageStr=@"Permit_PIC";
                }
                    break;
                case 3:
                {
                    keyStr=@"idcards_person_pic";
                    imageStr=@"IdCar_PIC";
                }
                    break;
                case 4:
                {
                    keyStr=@"vehicle_pic";
                    imageStr=@"manAndCar_PiC";
                }
                    break;
                    
                case 5:
                {
                    keyStr=@"drive_pic";
                    imageStr=@"Drive_PIC";
                }
                    break;
                case 6:
                {
                    keyStr=@"transport_pic";
                    imageStr=@"transport_pic";
                }
                    break;
                case 7:
                {
                    keyStr=@"compulsory_insurance";
                    imageStr=@"compulsory_pic";
                }
                    break;
                case 8:
                {
                    keyStr=@"commercial_insurance";
                    imageStr=@"commercial_pic";
                }
                    break;
                case 9:
                {
                    keyStr=@"driver_contract1";
                    imageStr=@"contract1_pic";
                }
                    break;
                case 10:
                {
                    keyStr=@"driver_contract2";
                    imageStr=@"contract2_pic";
                }
                    break;
                case 11:
                {
                    keyStr=@"driver_contract3";
                    imageStr=@"contract3_pic";
                }
                    break;
                default:
                    break;
            }
            if (i<4) {
                NSString *dateStr = [NSString stringWithFormat:@"%@%@.png",dateString,imageStr];
                NSLog(@"dateStr%@",dateStr);
                if (_DrivedateDic[imageStr] !=nil) {
                    //[self saveImage:_DrivedateDic[imageStr] withName:dateStr];
                    //  if (i==0) {
                    //       [self saveImage:_DrivedateDic[imageStr] withName:dateStr];
                    
                    //  }else{
                    [self saveImage:[UIImage fixOrientation:[self compressImageQuality:_DrivedateDic[imageStr]  toByte:1024*1024] ]withName:dateStr];
                    //  }
                    
                    //                    [self saveImage:[UIImage fixOrientation:[self compressImageQuality:_DrivedateDic[imageStr]  toByte:1024*1024]]   withName:dateStr];
                    
                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:keyStr fileName:dateStr mimeType:@"image/png" error:nil];
                    
                }
            }else{
                
                NSString * dateStr=[NSString stringWithFormat:@"%@%@.png",dateString,imageStr];
                if (_DateDic[imageStr] !=nil) {
                    
                    [self saveImage:[UIImage fixOrientation:[self compressImageQuality:_DateDic[imageStr]  toByte:1024*1024]]withName:dateStr];
                    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:keyStr fileName:dateStr mimeType:@"image/png" error:nil];
                    
                }
            }
            
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        CYLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        CYLog(@"请求成功：%@",responseObject);
        CYLog(@"提示信息：%@",[responseObject objectForKey:@"message"]);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
        
        [HUD removeFromSuperview];
        
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            
            
            [self scanFaceAction];
        } else {
            
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        [HUD removeFromSuperview];
        CYLog(@"请求失败：%@",error);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
    }];
}
-(NSString *)getDateStr
{
    NSDate * date=[NSDate date];
    NSDateFormatter * fomatter=[[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateStr=[fomatter stringFromDate:date];
    
    return dateStr;
}

//设置10个小view的layer层
- (void)setViewLayer
{
    self.View_1.layer.masksToBounds = YES;
    self.View_1.layer.cornerRadius=5;
    self.View_1.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_1.layer.borderWidth=0.5;
    self.View_2.layer.masksToBounds = YES;
    self.View_2.layer.cornerRadius=5;
    self.View_2.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_2.layer.borderWidth=0.5;
    self.View_3.layer.masksToBounds = YES;
    self.View_3.layer.cornerRadius=5;
    self.View_3.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_3.layer.borderWidth=0.5;
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
    self.View_7.layer.masksToBounds = YES;
    self.View_7.layer.cornerRadius=5;
    self.View_7.layer.borderColor=[CYTSI colorWithHexString:@"#cccccc"].CGColor;;
    self.View_7.layer.borderWidth=0.5;
    
    
    
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    _timePicker.hidden=YES;
    return YES;
}
//导航栏返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    if (_timePicker!=nil) {
        _timePicker = nil;
    }
    [singleAlertView removeFromSuperview];
    
}
-(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"3333333333333333=======%ld",data.length);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}
-(void)scanFaceAction{
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    //    __weak typeof(self) weakSelf = self;
    lvc.liveBlock = ^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //初始化进度框，置于当前的View当中
            UIWindow * window=[UIApplication sharedApplication].delegate.window;
            MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:window];
            
            [window addSubview:HUD];
            
            HUD.bezelView.backgroundColor=[UIColor blackColor];
            HUD.bezelView.alpha=1;
            HUD.label.textColor=[UIColor whiteColor];
            HUD.activityIndicatorColor=[UIColor whiteColor];
            //如果设置此属性则当前的view置于后台
            HUD.dimBackground = YES;
            //设置对话框文字
            HUD.labelText = @"请稍等";
            [HUD showAnimated:YES];
            
            NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_BAIDUAIP_DRIVER_FACE_AUTH];
            
            //1.创建管理者对象
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSDictionary *dict = @{@"driver_id":_driver.driver_id,
                @"token":_driver.token};
            // NSLog(@"=======%@",dict);
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
            
            [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSString * dateString=[CYTSI getDateStr];
                NSString * dateStr=[NSString stringWithFormat:@"%@face_img.png",dateString];
                NSLog(@"dateStr%@",dateStr);
                [CYTSI saveImage:[UIImage fixOrientation:[CYTSI compressImageQuality:image  toByte:1024*1024] ] withName:dateStr];
                
                NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"face_img" fileName:dateStr mimeType:@"image/png" error:nil];
                
                
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
                //打印下上传进度
                CYLog(@"上传进度=========%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //请求成功
                CYLog(@"请求成功：%@",responseObject);
                CYLog(@"提示信息：%@",[responseObject objectForKey:@"message"]);
                CYLog(@"请求地址:%@",urlString);
                CYLog(@"请求参数:%@",dict);
                if ([responseObject[@"flag"] isEqualToString:@"error"]) {
                    
                }
                [HUD removeFromSuperview];
                
                
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    if ([responseObject[@"message"] isEqualToString:@"认证成功"]){
                        [CYTSI otherShowTostWithString:responseObject[@"message"]];
                        [singleAlertView showAlertView];
                    }else{
                        [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                        UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        Add_ONE_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Add_ONE_id"];
                        RVC.faceState = @"fail";
                        RVC.driver = _driver;
                        [self.navigationController pushViewController:RVC animated:YES];
                    }
                } else {
                    
                    [HUD removeFromSuperview];
                    [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    UIStoryboard * board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    Add_ONE_ViewController * RVC = [board instantiateViewControllerWithIdentifier:@"Add_ONE_id"];
                    RVC.faceState = @"fail";
                    RVC.driver = _driver;
                    [self.navigationController pushViewController:RVC animated:YES];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //请求失败
                [HUD removeFromSuperview];
                CYLog(@"请求失败：%@",error);
                CYLog(@"请求地址:%@",urlString);
                CYLog(@"请求参数:%@",dict);
            }];
        });
        
    };
//    NSLog(@"self.face_numberself.face_numberself.face_number%ld",self.face_number);
    [lvc livenesswithList:@[] order:0  numberOfLiveness:1];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
}

@end
