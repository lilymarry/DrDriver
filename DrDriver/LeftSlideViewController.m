//
//  LeftSlideViewController.m
//  Touch
//
//  Created by lanou3g on 15/12/14.
//  Copyright © 2015年 syx. All rights reserved.
//

#import "LeftSlideViewController.h"

@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>{
    CGFloat _scalef;  //实时横向位移
}
@property (nonatomic,strong) UITableView * leftTableView;

@property (nonatomic,strong) UIView * contentView;

@property (nonatomic,assign) CGFloat leftTableViewW;

@property (nonatomic ,strong) UIButton *clickBtn;

@end

@implementation LeftSlideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    //给mainVc 设置阴影效果
//    self.mainVC.view.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.mainVC.view.layer.shadowOffset = CGSizeMake(-3, -3);
//    self.mainVC.view.layer.shadowOpacity=  1;
//    self.mainVC.view.layer.shadowRadius = 5;
    self.view.backgroundColor =[UIColor whiteColor];
}



// 初始化左视图和右视图
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC{
    self = [super init];
    if (self) {
        self.speedf = 0.8;
        self.leftVC = leftVC;
        self.mainVC = mainVC;
        
        // 滑动手势
        self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureAction:)];
        [self.mainVC.view addGestureRecognizer:self.pan];
        
        [self.pan setCancelsTouchesInView:YES];
        self.pan.delegate = self;
        
        self.leftVC.view.hidden = YES;
        self.leftVC.view.backgroundColor=[UIColor whiteColor];
        self.leftVC.view.frame=CGRectMake(0, 0, DeviceWidth, DeviceHeight);
        [self.view addSubview:self.leftVC.view];
        
        // 蒙版
        UIView * view = [[UIView alloc]initWithFrame:self.leftVC.view.bounds];
        view.backgroundColor = [UIColor blackColor];
        self.contentView = view;
        [self.leftVC.view addSubview:self.contentView];
        
        // 按钮
        UIButton *clickButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        clickButton.frame = [UIScreen mainScreen].bounds;
        clickButton.backgroundColor = [UIColor clearColor];
        [clickButton addTarget:self action:@selector(clickBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.clickBtn = clickButton;
        [self.mainVC.view addSubview:clickButton];
        
        // 获取左侧TableView
        for (UIView * obj in self.leftVC.view.subviews) {
            if ([obj isKindOfClass:[UITableView class]]) {
                self.leftTableView = (UITableView *)obj;
            }
        }
        
        self.leftTableView.backgroundColor = [UIColor clearColor];
        self.leftTableView.frame = CGRectMake(0, 0, WIDTH - 100, HEIGHT - 80 - Bottom_Height);
        
        [self.view addSubview:self.mainVC.view];
        self.closed = YES;//初始时侧滑窗关闭
        self.clickBtn.hidden = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.leftVC.view.hidden = NO;
}

// 关闭左视图
- (void)closeLeftView{
    
    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.mainVC.view.center = CGPointMake(WIDTH / 2, HEIGHT / 2);
    self.closed = YES;
    
//    self.leftTableView.center = CGPointMake(30, HEIGHT * 0.5);
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
    self.contentView.alpha = kLeftAlpha;
    
    [UIView commitAnimations];
    
    self.clickBtn.hidden = YES;
}

- (void)clickBtnAction:(UIButton *)sender{

    [self closeLeftView];
    
    sender.hidden = YES;
}


// 打开左视图
- (void)openLeftView{

    [UIView beginAnimations:nil context:nil];
    self.mainVC.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1,1);
    self.mainVC.view.center = kMainPageCenter;
    self.closed = NO;
    
//    if (DeviceWidth<375) {
//        self.leftTableView.center = CGPointMake((WIDTH - 100) * 0.5, HEIGHT * 0.5 - 60);
//    }
//    if (DeviceWidth==375) {
//        if (DeviceHeight == 667) {
//        self.leftTableView.center = CGPointMake((WIDTH - 100) * 0.5, HEIGHT * 0.5 - 30);
//        }else{
//        self.leftTableView.center = CGPointMake((WIDTH - 100) * 0.5, HEIGHT * 0.5+50+44);
//        }
//
//
//    }
//    if (DeviceWidth>375) {
//        self.leftTableView.center = CGPointMake((WIDTH - 100) * 0.5, HEIGHT * 0.5+50+44);
//    }
    self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    self.contentView.alpha = 0;
    
    [UIView commitAnimations];
    
    self.clickBtn.hidden = NO;
    // [self disableTapButton];
        
}


/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled{

    [self.pan setEnabled:enabled];

}

#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap{
    
    if ((!self.closed) && (tap.state == UIGestureRecognizerStateEnded))
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        self.closed = YES;
        
//        self.leftTableView.center = CGPointMake(30, HEIGHT * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.7,0.7);
        self.contentView.alpha = kLeftAlpha;
        
        [UIView commitAnimations];
        _scalef = 0;
        // [self removeSingleTap];
    }
    
}

// 手势触发事件
- (void)panGestureAction:(UIPanGestureRecognizer *)panAction{

    CGPoint point = [panAction translationInView:self.view];
    _scalef = (point.x * self.speedf + _scalef);

    BOOL needMoveWithTap = YES; // 是否跟随手势移动
    if (((self.mainVC.view.frame.origin.x <= 0) && (_scalef <= 0)) || ((self.mainVC.view.frame.origin.x >= (WIDTH - 100 )) && (_scalef >= 0))) {
        //
        _scalef = 0;
        needMoveWithTap = NO;
    }
    
    // 根据视图位置判断是左滑还是右滑
    if (needMoveWithTap && (panAction.view.frame.origin.x >= 0) && (panAction.view.frame.origin.x <= (WIDTH - 100))) {
        CGFloat panCenterX = panAction.view.center.x + point.x * self.speedf;
        if (panCenterX < WIDTH * 0.5 - 2) {
            panCenterX = WIDTH * 0.5;
        }
        CGFloat panCenterY = panAction.view.center.y;
        panAction.view.center = CGPointMake(panCenterX, panCenterY);
        
        // scale
        CGFloat scale = 1;
        panAction.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
        [panAction setTranslation:CGPointMake(0, 0) inView:self.view];
        CGFloat leftTabCenterX = 30 + ((WIDTH - 100) * 0.5 - 30) * (panAction.view.frame.origin.x / (WIDTH - 100));
        
        // leftScale
        CGFloat leftScale = 0.7 + (1 - 0.7) * (panAction.view.frame.origin.x / (WIDTH - 100));
        
//        self.leftTableView.center = CGPointMake(leftTabCenterX, HEIGHT * 0.5);
        self.leftTableView.transform = CGAffineTransformScale(CGAffineTransformIdentity, leftScale,leftScale);
        
        //tempAlpha kLeftAlpha~0
        CGFloat tempAlpha = kLeftAlpha - kLeftAlpha * (panAction.view.frame.origin.x / (WIDTH - 100));
        self.contentView.alpha = tempAlpha;

    }else{
        //超出范围，
        if (self.mainVC.view.frame.origin.x < 0){
            [self closeLeftView];
            _scalef = 0;
        }
        else if (self.mainVC.view.frame.origin.x > (WIDTH - 100)){
            [self openLeftView];
            _scalef = 0;
            
        }
    }
    //手势结束后修正位置,超过约一半时向多出的一半偏移
    if (panAction.state == UIGestureRecognizerStateEnded) {
        if (fabs(_scalef) > vCouldChangeDeckStateDistance)
        {
            if (self.closed)
            {
                [self openLeftView];
                
                self.clickBtn.hidden = NO;
            }
            else
            {
                [self closeLeftView];
                
                self.clickBtn.hidden = YES;
            }
        }
        else
        {
            if (self.closed)
            {
                [self closeLeftView];
                
                self.clickBtn.hidden = YES;
            }
            else
            {
                [self openLeftView];
                
                self.clickBtn.hidden = NO;
            }
        }
        _scalef = 0;
    }

    
}

#pragma mark - Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    
    if(touch.view.tag == vDeckCanNotPanViewTag)
    {
        //        NSLog(@"不响应侧滑");
        return NO;
    }
    else
    {
        //        NSLog(@"响应侧滑");
        return YES;
    }
}

@end
