//
//  FaceViewController.m
//  DrDriver
//
//  Created by fy on 2018/9/27.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "FaceViewController.h"
#import "LivingConfigModel.h"
#import "LivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "UIImage+FixIMG.h"
#import "AFNetWorking.h"


@interface FaceViewController ()

@end

@implementation FaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"人脸识别";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNav];
    [self creatMainView];
}
-(void)creatMainView{
    self.faceImageView = [[UIImageView alloc] init];
    self.faceImageView.image = [UIImage imageNamed:@"scanfacehui"];
    [self.view addSubview:self.faceImageView];
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@139);
        make.width.and.height.mas_offset(70);
    }];
    
    self.faceBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.faceBtn setTitle:@"去认证" forState:(UIControlStateNormal)];
    [self.faceBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.faceBtn addTarget:self action:@selector(scanFaceAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.faceBtn.backgroundColor = [CYTSI colorWithHexString:@"#2488ef"];
    self.faceBtn.layer.cornerRadius=5;
    self.faceBtn.layer.masksToBounds=YES;
    [self.view addSubview:self.faceBtn];
    [self.faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faceImageView.mas_bottom).offset(80);
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.mas_offset(50);
    }];
    if ([self.driver_face_state isEqualToString:@"1"]) {
        self.faceImageView.image = [UIImage imageNamed:@"scanfacelan"];
        [self.faceBtn setTitle:@"重新认证" forState:(UIControlStateNormal)];
    }else{
        self.faceImageView.image = [UIImage imageNamed:@"scanfacehui"];
        [self.faceBtn setTitle:@"去认证" forState:(UIControlStateNormal)];
    }
}
-(void)scanFaceAction{
    
    if ([[FaceSDKManager sharedInstance] canWork]) {
        NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
        [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    }
    
    LivenessViewController* lvc = [[LivenessViewController alloc] init];
    lvc.isFount = YES;
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
            NSDictionary *dict = @{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]};
            // NSLog(@"=======%@",dict);
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", nil];
            
            [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                
                NSString * dateString=[CYTSI getDateStr];
                NSString * dateStr=[NSString stringWithFormat:@"%@face_img.png",dateString];
//                NSLog(@"dateStr%@",dateStr);
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
                        self.reloadDataBlock();
                        [self.navigationController popViewControllerAnimated:YES];
                        [CYTSI otherShowTostWithString:responseObject[@"message"]];
                    }else{
                        [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    }
                } else {
                    
                    [HUD removeFromSuperview];
                    [CYTSI otherShowTostWithString:@"认证失败，请重试"];
                    
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
    [lvc livenesswithList:@[] order:0  numberOfLiveness:self.face_number];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    [self presentViewController:navi animated:YES completion:nil];
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
-(void)navBackButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
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
