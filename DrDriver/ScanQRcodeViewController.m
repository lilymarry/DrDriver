//
//  ScanQRcodeViewController.m
//  DrDriver
//
//  Created by qqqqqqq on 2018/4/28.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import "ScanQRcodeViewController.h"
#import <UIImageView+WebCache.h>

@interface ScanQRcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *scanImageView;//二维码

- (IBAction)ScanSaveBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *scanBnt;

@end

@implementation ScanQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    [self setUpNav];//设置导航栏
    [self creatHttp];
}

- (void)setUpView{
    self.scanBnt.layer.cornerRadius = 10;
    self.scanBnt.layer.masksToBounds = YES;
    
    self.scanImageView.layer.shadowColor=[UIColor lightGrayColor].CGColor;
    self.scanImageView.layer.shadowOffset=CGSizeMake(10, 10);
    self.scanImageView.layer.shadowOpacity=0.9;
    self.scanImageView.layer.shadowRadius=5;
    self.scanImageView.layer.cornerRadius = 15.0f;
    self.scanImageView.layer.masksToBounds = YES;
    [self.scanImageView setContentMode:UIViewContentModeScaleAspectFit];
    
}
//设置导航栏
-(void)setUpNav
{
    self.title = @"收款码";
    UIButton * navBackButton=[UIButton buttonWithType:UIButtonTypeCustom];
    navBackButton.frame=CGRectMake(0, 0, 40, 40);
    navBackButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [navBackButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [navBackButton addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftItem=[[UIBarButtonItem alloc]initWithCustomView:navBackButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

- (void)navBackButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
//请求司机信息
-(void)creatHttp
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]==nil) {
        
        return;
        
    }
    __weak typeof(self) weakSelf = self;
    [AFRequestManager postRequestWithUrl:DRIVER_QRCODE_GETPAYQRCODE params:@{@"driver_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"],@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]} tost:YES special:0 success:^(id responseObject) {
        [weakSelf.scanImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"poster"] ]placeholderImage:[UIImage imageNamed:@"scanPayDetail"] options:SDWebImageRefreshCached];
    } failure:^(NSError *error) {
//        NSLog(@"ScanQRcodeViewController === %@",error);
    }];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//点击二维码
- (IBAction)ScanSaveBtnClick:(UIButton *)sender {
    [self loadImageFinished:self.scanImageView.image];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    [CYTSI otherShowTostWithString:@"保存成功！"];
}

@end
