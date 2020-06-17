//
//  PersonalViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalTableViewCell.h"
#import "ChangePasswordOneViewController.h"
#import "ShouYeModel.h"
#import "AFNetWorking.h"
#import "RegisteViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FaceViewController.h"
#import "DriverInfoViewController.h"


@interface PersonalViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    UITableView * myTableView;
    NSArray * titleArray;//标题数组
    UIActionSheet *  mySheet;
    UIImage * headImage;//选择的头像
    
    ShouYeModel * shouYe;
    
}
@property(nonatomic,assign)NSInteger face_number;
@property (nonatomic, assign) NSInteger audit_state;//审核状态 1:审核中 2:已通过 3:未通过审核

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"个人资料";
    self.view.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    titleArray=@[@"头像",@"姓名",@"性别",@"手机号",@"公司",@"绑定车辆",@"修改密码",@"人脸识别认证（未录入）",@"补全信息"];
    
    [self setUpNav];//设置导航栏
    [self creatMainView];//创建主要视图
    [self requestMessage];//请求个人信息
    
}

//设置导航栏
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

//返回按钮点击事件
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

//请求个人信息
-(void)requestMessage
{
    [AFRequestManager postRequestWithUrl:DRIVER_BASE_DATA params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
//        NSLog(@"audit_stateaudit_state%@",responseObject[@"data"][@"audit_state"]);
        self.face_number = [responseObject[@"data"][@"face_number"] integerValue];
        self.audit_state = [responseObject[@"data"][@"audit_state"] integerValue];
        shouYe=[ShouYeModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (self.audit_state == 2){
            if ([shouYe.driver_face_state isEqualToString:@"1"]) {
                titleArray=@[@"头像",@"姓名",@"性别",@"手机号",@"公司",@"绑定车辆",@"修改密码",@"人脸识别认证（已录入）",@"补全信息"];
            }else{
                titleArray=@[@"头像",@"姓名",@"性别",@"手机号",@"公司",@"绑定车辆",@"修改密码",@"人脸识别认证（未录入）",@"补全信息"];
            }
        }else{
            if ([shouYe.driver_face_state isEqualToString:@"1"]) {
                titleArray=@[@"头像",@"姓名",@"性别",@"手机号",@"公司",@"绑定车辆",@"修改密码",@"人脸识别认证（已录入）"];
            }else{
                titleArray=@[@"头像",@"姓名",@"性别",@"手机号",@"公司",@"绑定车辆",@"修改密码",@"人脸识别认证（未录入）"];
            }
        }
        
        [myTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

////创建主要视图
-(void)creatMainView
{
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    myTableView.backgroundColor = TABLEVIEW_BACKCOLOR;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
if (self.audit_state == 2){
    return 9;
}else{
    return 8;
}
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10)];
    bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return 70;
    } else {
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"personalcell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    cell.headImageView.hidden=YES;
    cell.rightArrow.hidden=YES;
    cell.otherLable.hidden=NO;
    
    if (indexPath.row==0) {//头像
        cell.otherLable.hidden=YES;
        cell.headImageView.hidden=NO;
        cell.rightArrow.hidden=NO;
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:shouYe.driver_head] placeholderImage:[UIImage imageNamed:@"default_header"]];
        
        if (headImage!=nil) {
            cell.headImageView.image=headImage;
        }
    }
    
    if (indexPath.row==6) {//修改密码
        cell.otherLable.hidden=YES;
        cell.rightArrow.hidden=NO;
    }
    if (indexPath.row == 7) {
        cell.otherLable.hidden=YES;
        cell.rightArrow.hidden=NO;
    }
    if (indexPath.row == 8) {
        cell.lineView.hidden=YES;
        cell.otherLable.hidden=YES;
        cell.rightArrow.hidden=NO;
    }
    
    cell.nameLable.text=titleArray[indexPath.row];
    switch (indexPath.row) {
        case 1:
        {
            cell.otherLable.text=shouYe.driver_name;
        }
            break;
        case 2:
        {
            cell.otherLable.text=shouYe.driver_sex;
        }
            break;
        case 3:
        {
            cell.otherLable.text=shouYe.driver_account;
        }
            break;
        case 4:
        {
            cell.otherLable.text=shouYe.company_name;
        }
            break;
        case 5:
        {
            cell.otherLable.text=shouYe.vehicle_number;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {//修改头像
        
        mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
        [mySheet showInView:self.view];
        
    }
    
    if (indexPath.row==6) {//修改密码
        RegisteViewController * vc=[[RegisteViewController alloc]init];
        vc.isChange=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 7) {//人脸识别
        FaceViewController *vc = [[FaceViewController alloc] init];
        vc.face_number = self.face_number;
        vc.driver_face_state = shouYe.driver_face_state;
        __weak typeof(self) weakSelf = self;
        vc.reloadDataBlock = ^{
            [weakSelf requestMessage];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.row == 8) {//补全信息
        DriverInfoViewController *vc = [[DriverInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    
    NSString * dateString=[self getDateStr];
    NSString * dateStr=[NSString stringWithFormat:@"%@.png",dateString];
    
    [self saveImage:image withName:dateStr];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
    
    NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_EDIT_BASE_DATA];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.上传文件
    NSDictionary *dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"driver_head" fileName:dateStr mimeType:@"image/png" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        CYLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        CYLog(@"请求成功：%@",responseObject);
        CYLog(@"提示信息：%@",[responseObject objectForKey:@"message"]);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
        
        if ([responseObject[@"flag"] isEqualToString:@"success"]) {
            
            [CYTSI otherShowTostWithString:@"上传成功"];
            headImage=image;
            [myTableView reloadData];
            
        }else{
            
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        CYLog(@"请求失败：%@",error);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
    }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

