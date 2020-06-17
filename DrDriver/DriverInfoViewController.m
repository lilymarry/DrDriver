//
//  DriverInfoViewController.m
//  DrDriver
//
//  Created by fy on 2019/10/28.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "DriverInfoViewController.h"
#import "DriverInfoTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetWorking.h"
#import "UIImage+FixIMG.h"
#import "CYAlertView.h"


@interface DriverInfoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;
    NSMutableArray * orderArray;
    NSInteger photoType;
    UIActionSheet * mySheet;
    CYAlertView * singleAlertView;//单个按钮弹出视图
}
@property(nonatomic,strong)UIButton *faceBtn;
@property (nonatomic, strong) NSMutableDictionary * DateDic;
@property (nonatomic, strong) UILabel *tipslb;

@end

@implementation DriverInfoViewController
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
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    orderArray=[[NSMutableArray alloc]init];
    self.view.backgroundColor = TABLEVIEW_BACKCOLOR;
    self.title = @"补全信息";
    [self setUpNav];
    self.DateDic = [[NSMutableDictionary alloc] init];
    
    [self creatMainView];//创建主要视图
    
    
    [self creatHttp];//请求界面数据
}
//请求界面数据
-(void)creatHttp
{
    [AFRequestManager postRequestWithUrl:DRIVER_LOGIN_COMPLEMENT params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"ITTripViewController%@",responseObject);
        NSArray *array = responseObject[@"data"][@"field_data"];
        self.tipslb.text =responseObject[@"data"][@"tips"];
        
        for (int i = 0; i < array.count; i++) {
            NSMutableDictionary *dic = [array[i] mutableCopy];
            [orderArray addObject:dic];
        }
//        NSLog(@"orderArrayorderArray%@",orderArray);
        [myTableView reloadData];
   
    } failure:^(NSError *error) {
        
    }];
}
//创建主要视图
-(void)creatMainView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *headiew = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 35)];
    
    self.tipslb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, DeviceWidth - 20, 25)];
    self.tipslb.backgroundColor = [UIColor whiteColor];
    self.tipslb.textColor = [UIColor redColor];
    self.tipslb.font = [UIFont systemFontOfSize:13];
    self.tipslb.text = @"1231231231231";
    [headiew addSubview:self.tipslb];
    
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - Top_Height - Bottom_Height - 60) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.tableHeaderView = headiew;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[DriverInfoTableViewCell class] forCellReuseIdentifier:@"DriverInfoTableViewCell"];
    
    self.faceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.faceBtn setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.faceBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.faceBtn addTarget:self action:@selector(scanFaceAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.faceBtn.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    self.faceBtn.layer.cornerRadius=5;
    self.faceBtn.layer.masksToBounds=YES;
    [self.view addSubview:self.faceBtn];
    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myTableView.mas_bottom).offset(5);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_offset(50);
    }];
}
#pragma mark ---------------  上传补全信息
-(void)scanFaceAction{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"] forKey:@"driver_id"];
    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
    for (int i = 0; i < orderArray.count; i++) {
        NSDictionary *dic = orderArray[i];
        if ([dic[@"field_type"] isEqualToString:@"1"]) {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i  inSection:0];
            DriverInfoTableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
//            NSLog(@"cell.tf.textcell.tf.text%@",cell.tf.text);
            if (![cell.tf.text isEqualToString:@""]) {
                [dict setValue:cell.tf.text forKey:dic[@"field_name"]];
            }
        }
    }
    
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
    
    NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_LOGIN_COMPLEMENT_INFO];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * dateString=[self getDateStr];
        
        for (NSDictionary *dic in orderArray) {
            if ([dic[@"field_type"] isEqualToString:@"2"]) {
            NSString * keyStr=dic[@"field_name"];
            NSString * imageStr=[NSString stringWithFormat:@"%@_PIC",dic[@"field_name"]];
            NSString * dateStr=[NSString stringWithFormat:@"%@%@.png",dateString,imageStr];
                if ([[_DateDic allKeys] containsObject:imageStr]) {
                    
                    if (_DateDic[imageStr] !=nil) {
                        
                        [self saveImage:[UIImage fixOrientation:[self compressImageQuality:_DateDic[imageStr]  toByte:1024*1024]]withName:dateStr];
                        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
                        [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:keyStr fileName:dateStr mimeType:@"image/png" error:nil];
                        
                    }
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
            [singleAlertView showAlertView];
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        [HUD removeFromSuperview];
        CYLog(@"请求失败：%@",error);
        if (error.code == -1009) {
            [CYTSI otherShowTostWithString:@"网络错误，请检查网络连接并重试"];
        }
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
    }];
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 15;
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = orderArray[indexPath.row];
    if ([dic[@"field_type"] isEqualToString:@"2"]) {
        return 128;
    }else{
        return 74;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DriverInfoTableViewCell *driverInfoCell = [myTableView dequeueReusableCellWithIdentifier:@"DriverInfoTableViewCell" forIndexPath:indexPath];
    [driverInfoCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [driverInfoCell setDataDic:orderArray[indexPath.row]];
    driverInfoCell.ipIow  = indexPath.row;
    driverInfoCell.photoBlock = ^(NSInteger ipIow) {
        photoType = ipIow;
        mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [mySheet showInView:self.view];
    };
    return driverInfoCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//创建导航栏视图
-(void)setUpNav
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 20, 40);
    [button setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * lefItem=[[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem=lefItem;
}
-(void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:photoType  inSection:0];
    DriverInfoTableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
//    NSLog(@"cell.tf.textcell.tf.text%@",cell.tf.text);
    NSDictionary *dic = orderArray[photoType];
    NSString * photoTypeStr= [NSString stringWithFormat:@"%@_PIC",dic[@"field_name"]];
    NSDictionary *photoDic = orderArray[photoType];
    [photoDic setValue:image forKey:@"image"];
    [_DateDic setObject:image forKey:photoTypeStr];
    [myTableView reloadData];
}
-(void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSString *)getDateStr
{
    NSDate * date=[NSDate date];
    NSDateFormatter * fomatter=[[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateStr=[fomatter stringFromDate:date];
    
    return dateStr;
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


@end
