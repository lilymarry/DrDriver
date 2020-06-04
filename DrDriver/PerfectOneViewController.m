//
//  PerfectOneViewController.m
//  DrDriver
//
//  Created by mac on 2017/6/20.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "PerfectOneViewController.h"
#import "RegisterProgressView.h"
#import "PerfectOneTableViewCell.h"
#import "PerfectTwoTableViewCell.h"
#import "PerfectTwoViewController.h"
#import "ChooseCityViewController.h"
#import "AFNetWorking.h"

@interface PerfectOneViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    UITableView * myTableView;
    NSArray * titleArray;//标题数组
    UIActionSheet * mySheet;
    UIActionSheet * sexSheet;
    UIImage * headImage;
    
    UITextField * nameTextFiled;//姓名输入框
    UITextField * numberTextFiled;//身份证输入框
    UITextField * companyTextFiled;//公司输入框
    
    BOOL isSex;//是否是选择性别
    NSMutableDictionary * chooseDic;//选择的字典
    
}

@end

@implementation PerfectOneViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [myTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"完善信息";
    titleArray=@[@"服务城市",@"真实姓名",@"身份证号",@"性别",@"所属公司"];
    chooseDic=[[NSMutableDictionary alloc]init];
        
    [self setUpNav];//创建导航栏
    [self creatMainView];//创建主要视图
    
}

//创建导航栏
-(void)setUpNav
{
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
    
}

//导航栏返回按钮
-(void)navBackButtonClicked
{
//    [self.navigationController popViewControllerAnimated:YES];
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
    
    [progressView setProgress:1];
    
    UIView * footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 100)];
    footerView.backgroundColor=TABLEVIEW_BACKCOLOR;
    
    UIButton * nextButton=[UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame=CGRectMake(12, 27, DeviceWidth-24, 44);
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
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
    [nameTextFiled resignFirstResponder];
    [numberTextFiled resignFirstResponder];
    [companyTextFiled resignFirstResponder];
    
    if (headImage==nil) {
        [CYTSI otherShowTostWithString:@"请选择你的头像"];
        return;
    }
    if (_choosedCity==nil || [_choosedCity isEqualToString:@""]) {
        [CYTSI otherShowTostWithString:@"请选择你所在的城市"];
        return;
    }
    if (chooseDic[@"name"]==nil) {
        [CYTSI otherShowTostWithString:@"请输入你的真实姓名"];
        return;
    }
    if (chooseDic[@"number"]==nil) {
        [CYTSI otherShowTostWithString:@"请输入你的身份证号"];
        return;
    }
    if (chooseDic[@"sex"]==nil) {
        [CYTSI otherShowTostWithString:@"请输入你的性别"];
        return;
    }
    if (chooseDic[@"company"]==nil) {
        [CYTSI otherShowTostWithString:@"请输入你的公司名称"];
        return;
    }
    
    BOOL isRight=[CYTSI validateIDCardNumber:chooseDic[@"number"]];
    if (isRight==NO) {
        [CYTSI otherShowTostWithString:@"请输入正确的身份证号码"];
        return;
    }
    
    NSString * dateString=[self getDateStr];
    NSString * dateStr=[NSString stringWithFormat:@"%@.png",dateString];
    
    [self saveImage:headImage withName:dateStr];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:dateStr];
    
    NSString * urlString=[NSString stringWithFormat:@"%@%@",HTTP_URL,DRIVER_REGISTER_PERSON_INFO];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.上传文件
    NSDictionary *dict = @{@"driver_id":_driver.driver_id,
                           @"city_name":_choosedCity,
                           @"driver_name":chooseDic[@"name"],
                           @"driver_number":chooseDic[@"number"],
                           @"driver_sex":chooseDic[@"sex"],
                           @"company_name":chooseDic[@"company"],
                           @"token":_driver.token};
    
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
        
        if ([[responseObject objectForKey:@"flag"] isEqualToString:@"success"]) {

            PerfectTwoViewController * vc=[[PerfectTwoViewController alloc]init];
            vc.driver=_driver;
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            
            [CYTSI otherShowTostWithString:responseObject[@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        CYLog(@"请求失败：%@",error);
        CYLog(@"请求地址:%@",urlString);
        CYLog(@"请求参数:%@",dict);
    }];
    
}

#pragma mark - UITextFiled 的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [nameTextFiled resignFirstResponder];
    [numberTextFiled resignFirstResponder];
    [companyTextFiled resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    myTableView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight-216);
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    myTableView.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    
    if (textField==nameTextFiled) {
        
        if (![nameTextFiled.text isEqualToString:@""]) {
            
            [chooseDic setObject:nameTextFiled.text forKey:@"name"];
            [myTableView reloadData];
            
        }
        
    }
    if (textField==numberTextFiled) {
        
        if (![numberTextFiled.text isEqualToString:@""]) {
            
            [chooseDic setObject:numberTextFiled.text forKey:@"number"];
            [myTableView reloadData];
            
        }
        
    }
    if (textField==companyTextFiled) {
        
        if (![companyTextFiled.text isEqualToString:@""]) {
            
            [chooseDic setObject:companyTextFiled.text forKey:@"company"];
            [myTableView reloadData];
            
        }

    }
    
}

//点击区头结束键盘第一响应
-(void)cancleButtolClicked
{
    [nameTextFiled resignFirstResponder];
    [numberTextFiled resignFirstResponder];
    [companyTextFiled resignFirstResponder];
}

#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    } else {
        return 38;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return nil;
    } else {
        
        UIView * bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 38)];
        bgView.backgroundColor=TABLEVIEW_BACKCOLOR;
        
        UILabel * lable=[[UILabel alloc]initWithFrame:CGRectMake(12, 10, DeviceWidth-24, 18)];
        lable.font=[UIFont systemFontOfSize:13];
        lable.text=titleArray[section-1];
        lable.textColor=[CYTSI colorWithHexString:@"#666666"];
        [bgView addSubview:lable];
        
        UIButton * cancleButton=[UIButton buttonWithType:UIButtonTypeCustom];
        cancleButton.frame=CGRectMake(0, 0, DeviceWidth, 38);
        [cancleButton addTarget:self action:@selector(cancleButtolClicked) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancleButton];
        
        return bgView;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 71;
    } else {
        return 44;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        PerfectOneTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"perfectonecell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"PerfectOneTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        if (headImage!=nil) {
            cell.headerImageView.image=headImage;
        }
        
        [cell.uploadButton addTarget:self action:@selector(uploadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
        
        PerfectTwoTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"perfecttwocell"];
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"PerfectTwoTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        switch (indexPath.section) {
            case 1://城市
            {
                cell.closeButton.hidden=YES;
                cell.theTextFiled.enabled=NO;
                cell.theTextFiled.text=[NSString stringWithFormat:@"%@（所在城市）",_choosedCity];
                
            }
                break;
            case 2://真实姓名
            {
                cell.rightArrowImageView.hidden=YES;
                cell.theTextFiled.placeholder=@"请输入你的真实姓名";
                nameTextFiled=cell.theTextFiled;
                nameTextFiled.returnKeyType=UIReturnKeyDone;
                nameTextFiled.delegate=self;
                
                [cell.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                
                if (chooseDic[@"name"]!=nil) {
                    cell.theTextFiled.text=chooseDic[@"name"];
                }
                
            }
                break;
            case 3://身份证号
            {
                cell.closeButton.hidden=YES;
                cell.rightArrowImageView.hidden=YES;
                cell.theTextFiled.placeholder=@"请输入身份证号";
                numberTextFiled=cell.theTextFiled;
                numberTextFiled.returnKeyType=UIReturnKeyDone;
                numberTextFiled.keyboardType=UIKeyboardTypeNumberPad;
                numberTextFiled.delegate=self;
                
                if (chooseDic[@"number"]!=nil) {
                    cell.theTextFiled.text=chooseDic[@"number"];
                }
                
            }
                break;
            case 4://性别
            {
                cell.closeButton.hidden=YES;
                cell.theTextFiled.placeholder=@"请选择";
                cell.theTextFiled.enabled=NO;
                
                if (chooseDic[@"sex"]!=nil) {
                    if ([chooseDic[@"sex"] intValue]==1) {
                        cell.theTextFiled.text=@"男";
                    } else {
                        cell.theTextFiled.text=@"女";
                    }
                }
                
            }
                break;
            case 5://所属公司
            {
                cell.closeButton.hidden=YES;
                cell.rightArrowImageView.hidden=YES;
                cell.theTextFiled.placeholder=@"请输入公司名称";
                companyTextFiled=cell.theTextFiled;
                companyTextFiled.returnKeyType=UIReturnKeyDone;
                companyTextFiled.delegate=self;
                
                if (chooseDic[@"company"]!=nil) {
                    cell.theTextFiled.text=chooseDic[@"company"];
                }
                
            }
                break;
            default:
                break;
        }
        
        return cell;
        
    }
}

//清空姓名按钮点击事件
-(void)closeButtonClicked
{
    [chooseDic removeObjectForKey:@"name"];
    [myTableView reloadData];
}

//上传头像
-(void)uploadButtonClicked
{
    isSex=NO;
    mySheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [mySheet showInView:self.view];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //选择城市
    if (indexPath.section==1) {
        
        ChooseCityViewController * vc=[[ChooseCityViewController alloc]init];
        vc.locationCityStr=[NSString stringWithFormat:@"%@",self.choosedCity];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    //选择性别
    if (indexPath.section==4) {
        
        isSex=YES;
        sexSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [sexSheet showInView:self.view];
        
    }
    
}

#pragma mark  acionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (isSex) {
        
        if (buttonIndex==0) {//男
            
            [chooseDic setObject:@"1" forKey:@"sex"];
            [myTableView reloadData];
            
            return;
            
        } else {//女
            
            [chooseDic setObject:@"2" forKey:@"sex"];
            [myTableView reloadData];
            
            return;
            
        }
        
    }
    
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
    
    headImage=image;
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
