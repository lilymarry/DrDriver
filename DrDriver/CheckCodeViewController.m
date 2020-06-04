//
//  CheckCodeViewController.m
//  DrUser
//
//  Created by mac on 2017/6/18.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import "CheckCodeViewController.h"
#import "SGQRCode.h"
#import "AppDelegate.h"
#import "TrueRegisterViewController.h"

#import <AVFoundation/AVFoundation.h>

@interface CheckCodeViewController () <SGQRCodeManagerDelegate>

@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

@end

@implementation CheckCodeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.scanningView addTimer];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)dealloc {
    NSLog(@"SGQRCodeScanningVC - dealloc");
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"扫一扫";
    [self setUpNav];//创建导航栏
    
    [self openPhoto];
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.scanningView];
    
}

-(void)openPhoto
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        CheckCodeViewController *vc = [[CheckCodeViewController alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    
                    NSLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
//            CheckCodeViewController *vc = [[CheckCodeViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - 网路出行] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    [self setupQRCodeScanning];
    
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
    
//    UIButton * photoButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    photoButton.frame=CGRectMake(0, 0, 40, 20);
//    [photoButton setTitle:@"相册" forState:UIControlStateNormal];
//    photoButton.titleLabel.font=[UIFont systemFontOfSize:14];
//    [photoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [photoButton addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem * rightItem=[[UIBarButtonItem alloc]initWithCustomView:photoButton];
//    self.navigationItem.rightBarButtonItem=rightItem;
    
}

//导航栏返回按钮
-(void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {

        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}

- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

//相册选取二维码按钮点击事件
- (void)rightBarButtonItenAction {
    /// 从相册中读取二维码
    [[SGQRCodeManager sharedQRCodeManager] SG_readQRCodeFromAlbum];
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        BOOL isPHAuthorization = [SGQRCodeManager sharedQRCodeManager].isPHAuthorization;
        if (isPHAuthorization == YES) {
            [self removeScanningView];
        }
    });
}

- (void)manager:(SGQRCodeManager *)manager imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.view addSubview:self.scanningView];
}

- (void)manager:(SGQRCodeManager *)manager imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self.view addSubview:self.scanningView];
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:info[UIImagePickerControllerOriginalImage]];
    }];
}

#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个 CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count == 0) {
        NSLog(@"暂未识别出扫描的二维码");
        return;
    }
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *resultStr = feature.messageString;
        NSLog(@"scannedResult - - %@", resultStr);
        
        if ([resultStr hasPrefix:@"http"]) {//网址
            
            [self checkSuccess:resultStr];
            
        } else {//字符串
            
            [self checkSuccess:resultStr];
            
        }
        
    }
}

- (void)setupQRCodeScanning {
    SGQRCodeManager *manager = [SGQRCodeManager sharedQRCodeManager];
    manager.currentVC = self;
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [manager SG_setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr];
    manager.delegate = self;
}

- (void)manager:(SGQRCodeManager *)manager captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        [manager SG_palySoundName:@"SGQRCode.bundle/sound.caf"];
        [manager SG_stopRunning];
        [manager SG_videoPreviewLayerRemoveFromSuperlayer];
        
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        
        //扫描结果
        [self checkSuccess:[obj stringValue]];
        
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}

//扫描成功操作
-(void)checkSuccess:(NSString *)string
{
    NSArray * vcArray=self.navigationController.viewControllers;
    for (TrueRegisterViewController * vc in vcArray) {
        
        if ([vc isKindOfClass:[TrueRegisterViewController class]]) {
            
            //            NSLog(@"扫描结果%@",string);
            vc.inviteCode=string;
            [self.navigationController popToViewController:vc animated:YES];
        }
        
    }
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
