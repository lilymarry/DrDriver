//
//  LeftSlideViewController.h
//  Touch
//
//  Created by lanou3g on 15/12/14.
//  Copyright © 2015年 syx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define SIZE [UIScreen mainScreen].bounds.size
#define vCouldChangeDeckStateDistance  (WIDTH - 100) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define kMainPageCenter  CGPointMake(WIDTH + WIDTH * 1 / 2.0 - 100, HEIGHT / 2)  //打开左侧窗时，中视图中心点
#define vDeckCanNotPanViewTag    20000 // 不响应此侧滑的View的tag

#define kLeftAlpha 0.2  //左侧蒙版的最大值

@interface LeftSlideViewController : UIViewController


@property (nonatomic, assign) CGFloat speedf; //滑动速度

@property (nonatomic, strong) UIViewController *leftVC; //左侧窗控制器

@property (nonatomic,strong) UIViewController *mainVC;

@property (nonatomic, strong) UITapGestureRecognizer *sideslipTapGes; //点击手势控制器，是否允许点击视图恢复视图位置。默认为yes

@property (nonatomic, strong) UIPanGestureRecognizer *pan; //滑动手势控制器

@property (nonatomic, assign) BOOL closed; //侧滑窗是否关闭(关闭时显示为主页)

// 初始化左视图和右视图
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC;

// 关闭左视图
- (void)closeLeftView;


// 打开左视图
- (void)openLeftView;

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled;

@end
