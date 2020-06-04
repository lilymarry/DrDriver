//
//  ITDriverOrderViewController.m
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITDriverOrderViewController.h"
#import "ITShouYeTableViewCell.h"
#import "ITTableViewCell.h"



@interface ITDriverOrderViewController ()<YUFoldingTableViewDelegate>
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition arrowPosition;


@end

@implementation ITDriverOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    // 创建tableView
    YUFoldingTableView *foldingTableView = [[YUFoldingTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.bounds.size.height - topHeight - Bottom_Height - 294)];
    foldingTableView.backgroundColor =[UIColor groupTableViewBackgroundColor];
    self.foldingTableView = foldingTableView;
    foldingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:foldingTableView];
    foldingTableView.foldingDelegate = self;
    foldingTableView.sectionStateArray = @[@"1", @"0", @"0"];
    
    //添加下拉刷新及上拉加载
    foldingTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDown)];
    foldingTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshUp)];
    
    [self creatBottomView];
}
-(void)refreshDown{
    self.refreshD();
}
-(void)refreshUp{
    self.refreshU();
}
#pragma mark - YUFoldingTableViewDelegate / required（必须实现的代理）
- (NSInteger )numberOfSectionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    return 3;
}
- (NSInteger )yuFoldingTableView:(YUFoldingTableView *)yuTableView numberOfRowsInSection:(NSInteger )section
{
    if (section == 0) {
        if (self.today_list.count == 0) {
            return 1;
        }else{
            return self.today_list.count;
        }
    }else if (section == 1){
        if (self.tomorrow_list.count == 0) {
            return 1;
        }else{
            return self.tomorrow_list.count;
        }
    }else{
        if (self.after_tomorrow_list.count == 0) {
            return 1;
        }else{
            return self.after_tomorrow_list.count;
        }
    }
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForHeaderInSection:(NSInteger )section
{
    return 50;
}
- (CGFloat )yuFoldingTableView:(YUFoldingTableView *)yuTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.today_list.count == 0) {
            return 75;
        }else{
            return 225;
        }
    }else if (indexPath.section  == 1){
        if (self.tomorrow_list.count == 0) {
            return 75;
        }else{
            return 225;
        }
    }else{
        if (self.after_tomorrow_list.count == 0) {
            return 75;
        }else{
            return 225;
        }
    }
}

-(UITableViewCell *)yuFoldingTableView:(YUFoldingTableView *)yuTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    ITShouYeTableViewCell *ITShouYecell = [yuTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (ITShouYecell == nil) {
        ITShouYecell = [[ITShouYeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }else
    {
        //删除cell的所有子视图
        while ([ITShouYecell.contentView.subviews lastObject] != nil)
        {
            [(UIView*)[ITShouYecell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    [ITShouYecell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    ITTableViewCell *itCell = [yuTableView dequeueReusableCellWithIdentifier:@"itcell"];
    if (itCell == nil) {
        itCell = [[ITTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"itcell"];
    }
    [itCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (indexPath.section == 0) {
        if (self.today_list.count == 0) {
            itCell.titleLB.text = @"今日无行程，请点击下面“发布行程”";
            return itCell;
        }else{
            ITShouYecell.state = self.today_list[indexPath.row][@"state"];
            [ITShouYecell setDataDic:self.today_list[indexPath.row]];
            return ITShouYecell;
        }
    }else if (indexPath.section  == 1){
        if (self.tomorrow_list.count == 0) {
            itCell.titleLB.text = @"明日无行程，请点击下面“发布行程”";
            return itCell;
        }else{
            ITShouYecell.state = self.tomorrow_list[indexPath.row][@"state"];
            [ITShouYecell setDataDic:self.tomorrow_list[indexPath.row]];
            return ITShouYecell;
        }
    }else{
        if (self.after_tomorrow_list.count == 0) {
            itCell.titleLB.text = @"后日无行程，请点击下面“发布行程”";
            return itCell;
        }else{
            ITShouYecell.state = self.after_tomorrow_list[indexPath.row][@"state"];
            [ITShouYecell setDataDic:self.after_tomorrow_list[indexPath.row]];
            return ITShouYecell;
        }
    }
}

#pragma mark - YUFoldingTableViewDelegate / optional （可选择实现的）
-(NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"今日行程";
        
    }else if (section == 1){
        return @"明日行程";
        
    }else{
        return @"后日行程";
    }
}

- (void)yuFoldingTableView:(YUFoldingTableView *)yuTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [yuTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.today_list.count == 0) {
//            if (self.isCanListen) {
////                [self pushCreationOrderVC];
//            }else{
//                [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能发布行程"];
//            }
        }else{
            [self pushITTripDetailVC:self.today_list[indexPath.row][@"travel_id"] date:self.today_list[indexPath.row][@"travel_date"] time:self.today_list[indexPath.row][@"travel_time"]];
        }
    }else if (indexPath.section  == 1){
        if (self.tomorrow_list.count == 0) {
//            if (self.isCanListen) {
////                [self pushCreationOrderVC];
//            }else{
//                [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能发布行程"];
//            }
        }else{
            [self pushITTripDetailVC:self.tomorrow_list[indexPath.row][@"travel_id"] date:self.tomorrow_list[indexPath.row][@"travel_date"] time:self.tomorrow_list[indexPath.row][@"travel_time"]];
        }
    }else{
        if (self.after_tomorrow_list.count == 0) {
//            if (self.isCanListen) {
////                [self pushCreationOrderVC];
//            }else{
//                [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能发布行程"];
//            }
        }else{
            [self pushITTripDetailVC:self.after_tomorrow_list[indexPath.row][@"travel_id"] date:self.after_tomorrow_list[indexPath.row][@"travel_date"] time:self.after_tomorrow_list[indexPath.row][@"travel_time"]];
        }
    }
}

-(void)pushCreationOrderVC{
    self.pushCreationOrder();
}

-(void)pushITTripDetailVC:(NSString *)travelID date:(NSString *)date time:(NSString *)time{
    self.pushDetailVC(travelID, date, time);
}

// 返回箭头的位置
- (YUFoldingSectionHeaderArrowPosition)perferedArrowPositionForYUFoldingTableView:(YUFoldingTableView *)yuTableView
{
    // 没有赋值，默认箭头在左
    return YUFoldingSectionHeaderArrowPositionRight;
}

- (NSString *)yuFoldingTableView:(YUFoldingTableView *)yuTableView descriptionForHeaderInSection:(NSInteger )section
{
    return @"detailText";
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.foldingTableView) {
        CGFloat sectionHeaderHeight = 40;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//创建底部视图
-(void)creatBottomView
{
    CGFloat topHeight = [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
    UIButton * bgButton=[UIButton buttonWithType:UIButtonTypeCustom];
    bgButton.layer.borderWidth=1;
    bgButton.layer.borderColor=TABLEVIEW_BACKCOLOR.CGColor;
    bgButton.layer.cornerRadius=51;
    bgButton.layer.masksToBounds=YES;
    [self.view addSubview:bgButton];
    [bgButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        self.view.bounds.size.height - topHeight - Bottom_Height - 209
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@102);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    UIView * bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - topHeight - Bottom_Height - 209 - 92 - Bottom_Height, DeviceWidth, 112 + Bottom_Height)];
    bottomView.backgroundColor=[UIColor whiteColor];
    bottomView.layer.borderWidth=0.8;
    bottomView.layer.borderColor=TABLEVIEW_BACKCOLOR.CGColor;
    [self.view addSubview:bottomView];
    
    UIButton * frontButton=[UIButton buttonWithType:UIButtonTypeCustom];
    frontButton.backgroundColor=[UIColor whiteColor];
    frontButton.layer.cornerRadius=50.5;
    frontButton.layer.masksToBounds=YES;
    [self.view addSubview:frontButton];
    [frontButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-5);
        make.width.and.height.equalTo(@101);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    CALayer *layer=[[CALayer alloc]init];
    layer.frame=CGRectMake((DeviceWidth-93)/2, self.view.bounds.size.height - topHeight - Bottom_Height - 209-103 - Bottom_Height, 93, 93);
    layer.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    layer.cornerRadius=46.5;
    layer.masksToBounds=YES;
    [self.view.layer addSublayer:layer];
    
    self.midleButtonView=[[CYButtonView alloc]initWithFrame:CGRectMake((DeviceWidth-92)/2, self.view.bounds.size.height - topHeight - Bottom_Height - 209-103 - Bottom_Height, 92, 92) title:@"发布行程"];
    self.midleButtonView.layer.cornerRadius=46;
    self.midleButtonView.layer.masksToBounds=YES;
    self.midleButtonView.buttonState=SCAN_CLIKCK;
    [self.view addSubview:self.midleButtonView];
    
    __weak typeof (self) weakSelf = self;
#pragma mark -----------   按钮点击事件
   self.midleButtonView.buttonBlock = ^(NSInteger state) {
        if (weakSelf.isCanListen) {
            switch (state) {
                case 5:
                {
                    weakSelf.pushCreationOrder();
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            [CYTSI otherShowTostWithString:@"您还没有通过审核，暂时不能发布行程"];
            return;
        }
    };
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
