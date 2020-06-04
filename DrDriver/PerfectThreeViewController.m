//
//  PerfectThreeViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PerfectThreeViewController.h"
#import "RegisterProgressView.h"
#import "PerfectThreeTableViewCell.h"
#import "CYAlertView.h"
#import "AFNetWorking.h"
#import "LoginViewController.h"

@interface PerfectThreeViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UITableView * myTableView;
    NSArray * titleArray;//标题数组
    NSMutableDictionary * chooseDic;//选择的字典
    int photoType;//上传类型 1:车辆照片  2:运营从业资格证 3:行驶证 4:手持身份证
    UIActionSheet * mySheet;
    CYAlertView * singleAlertView;//单个按钮弹出视图
}

@end

@implementation PerfectThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"完善信息";
    titleArray=@[@"车辆照片",@"运营从业资格证",@"行驶证",@"手持身份证"];
    chooseDic=[[NSMutableDictionary alloc]init];
    
    [self setUpNav];//创建导航栏
    [self creatMainView];//创建主要视图
    [self creatAlertView];//创建弹出视图
    
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

//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
        [weakSelf uploadMessage];//上传信息
        
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
    //2.上传文件
    NSDictionary *dict = @{@"driver_id":_driver.driver_id,@"token":_driver.token};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSString * dateString=[self getDateStr];
        for (int i=0; i<4; i++) {
            
            NSString * keyStr=@"";
            NSString * imageStr=@"";
            switch (i) {
                case 0:
                {
                    keyStr=@"vahicle_pic";
                    imageStr=@"one";
                }
                    break;
                case 1:
                {
                    keyStr=@"license_pic";
                    imageStr=@"two";
                }
                    break;
                case 2:
                {
                    keyStr=@"drive_pic";
                    imageStr=@"three";
                }
                    break;
                case 3:
                {
                    keyStr=@"idcards_person_pic";
                    imageStr=@"four";
                }
                    break;
                default:
                    break;
            }
            
            NSString * dateStr=[NSString stringWithFormat:@"%@%@.png",dateString,imageStr];
            NSLog(@"dateStr%@",dateStr);
            [self saveImage:chooseDic[imageStr] withName:dateStr];
            NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:keyStr fileName:dateStr mimeType:@"image/png" error:nil];
            
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
        
        if (responseObject[@"data"]) {
            
            NSArray * vcArray=self.navigationController.viewControllers;
            for (LoginViewController * vc in vcArray) {
                
                if ([vc isKindOfClass:[LoginViewController class]]) {
                    
                    [CYTSI otherShowTostWithString:@"上传成功"];
                    [self.navigationController popToViewController:vc animated:YES];
                }
                
            }
            
        } else {
            
            [HUD removeFromSuperview];
            [CYTSI otherShowTostWithString:responseObject[@"data"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        [HUD removeFromSuperview];
        CYLog(@"请求失败：%@",error);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
    }];
}

-(void)dealloc
{
    [singleAlertView removeFromSuperview];
}

-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:myTableView];
    
    RegisterProgressView * progressView=[[RegisterProgressView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 68)];
    progressView.backgroundColor=TABLEVIEW_BACKCOLOR;
    [myTableView setTableHeaderView:progressView];
    
    [progressView setProgress:3];
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
    footerView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIButton * nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(12, 27, DeviceWidth-24, 44);
    [nextButton setTitle:@"提交审核" forState:UIControlStateNormal];
    nextButton.titleLabel.font=[UIFont systemFontOfSize:16];
    nextButton.backgroundColor=[CYTSI colorWithHexString:@"#386ac6"];
    nextButton.layer.cornerRadius=5;
    nextButton.layer.masksToBounds=YES;
    [nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:nextButton];
    
    [myTableView setTableFooterView:footerView];
    
}

//下一步按钮点击事件
-(void)nextButtonClicked
{
    if (chooseDic[@"one"]==nil) {
        [CYTSI otherShowTostWithString:@"请上传车辆照片"];
        return;
    }
    if (chooseDic[@"two"]==nil) {
        [CYTSI otherShowTostWithString:@"请上传运营从业资格证"];
        return;
    }
    if (chooseDic[@"three"]==nil) {
        [CYTSI otherShowTostWithString:@"请上传行驶证"];
        return;
    }
    if (chooseDic[@"four"]==nil) {
        [CYTSI otherShowTostWithString:@"手持身份证"];
        return;
    }
    
    [singleAlertView showAlertView];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 38)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, DeviceWidth-24, 18)];
    lable.font=[UIFont systemFontOfSize:13];
    lable.text=titleArray[section];
    lable.textColor=[CYTSI colorWithHexString:@"#666666"];
    [bgView addSubview:lable];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PerfectThreeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"perfectthreecell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PerfectThreeTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0://车辆照片
        {
            cell.oneLable.text=@"* 请上传车辆正面照片，确保车牌号清晰可见";
            cell.twoLable.text=@"* 确保照片真实，严禁经过PS处理";
            cell.threeLable.hidden=YES;
            
            int height =[CYTSI planRectHeight:cell.oneLable.text font:11 theWidth:DeviceWidth-186];
            cell.oneLableHeight.constant=height;
            int heightOne =[CYTSI planRectHeight:cell.twoLable.text font:11 theWidth:DeviceWidth-186];
            cell.twoLableHeight.constant=heightOne;
            
            if (chooseDic[@"one"]!=nil) {
                [cell.photoButton setImage:chooseDic[@"one"] forState:UIControlStateNormal];
            }
            
        }
            break;
        case 1://运营从业资格证
        {
            cell.oneLable.text=@"* 请上传正面照片，确保信息完整无缺失";
            cell.twoLable.text=@"* 确保照片真实，严禁经过PS处理";
            cell.threeLable.hidden=YES;
            
            int height =[CYTSI planRectHeight:cell.oneLable.text font:11 theWidth:DeviceWidth-186];
            cell.oneLableHeight.constant=height;
            int heightOne =[CYTSI planRectHeight:cell.twoLable.text font:11 theWidth:DeviceWidth-186];
            cell.twoLableHeight.constant=heightOne;
            
            if (chooseDic[@"two"]!=nil) {
                [cell.photoButton setImage:chooseDic[@"two"] forState:UIControlStateNormal];
            }
            
        }
            break;
        case 2://行驶证
        {
            cell.oneLable.text=@"* 请确保信息完整无缺失";
            cell.twoLable.text=@"* 确保照片真实，严禁经过PS处理";
            cell.threeLable.hidden=YES;
            
            int height =[CYTSI planRectHeight:cell.oneLable.text font:11 theWidth:DeviceWidth-186];
            cell.oneLableHeight.constant=height;
            int heightOne =[CYTSI planRectHeight:cell.twoLable.text font:11 theWidth:DeviceWidth-186];
            cell.twoLableHeight.constant=heightOne;
            
            if (chooseDic[@"three"]!=nil) {
                [cell.photoButton setImage:chooseDic[@"three"] forState:UIControlStateNormal];
            }
            
        }
            break;
        case 3://手持身份证
        {
            cell.oneLable.text=@"* 请确保人脸五官清晰可见";
            cell.twoLable.text=@"* 请确保身份证信息清晰可见";
            cell.threeLable.text=@"* 确保照片真实，严禁经过PS处理";
            
            int heightthree =[CYTSI planRectHeight:cell.threeLable.text font:11 theWidth:DeviceWidth-186];
            cell.threeLableHeight.constant=heightthree;
            
            if (chooseDic[@"four"]!=nil) {
                [cell.photoButton setImage:chooseDic[@"four"] forState:UIControlStateNormal];
            }
            
        }
            break;
        default:
            break;
    }
    
    cell.photoButton.tag=10+indexPath.section;
    [cell.photoButton addTarget:self action:@selector(photoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//上传图片按钮点击事件
-(void)photoButtonClicked:(UIButton *)btn
{
    photoType=btn.tag-9;
    
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
                //相机
                sourceType=UIImagePickerControllerSourceTypeCamera;
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nofirst"];
            }
                break;
            case 1:
            {
                //相册
                sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"nofirst"];
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
        }
    }
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = NO;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{
    }];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    NSString * photoTypeStr=@"";
    switch (photoType) {
        case 1:
        {
            photoTypeStr=@"one";
        }
            break;
        case 2:
        {
            photoTypeStr=@"two";
        }
            break;
        case 3:
        {
            photoTypeStr=@"three";
        }
            break;
        case 4:
        {
            photoTypeStr=@"four";
        }
            break;
        default:
            break;
    }
    [chooseDic setObject:image forKey:photoTypeStr];
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

-(NSString *)getDateStr
{
    NSDate * date=[NSDate date];
    NSDateFormatter * fomatter=[[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateStr=[fomatter stringFromDate:date];
    return dateStr;
}



@end
