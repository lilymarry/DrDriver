//
//  ITSelectAddressViewController.m
//  DrDriver
//
//  Created by fy on 2019/5/28.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "ITSelectAddressViewController.h"
#import "GeoFenceMapTopView.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ShouYeTableViewCell.h"

@interface ITSelectAddressViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)GeoFenceMapTopView *topView;
@property(nonatomic,strong)AMapSearchAPI *search;
@property(nonatomic,strong)NSMutableArray *poiArr;
@property(nonatomic,strong)UITableView *tableView;

@end

@implementation ITSelectAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.poiArr = [NSMutableArray array];
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    [self creatTopView];
    [self creatTableView];
}
-(void)creatTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, k_Height_NavBar, DeviceWidth, DeviceHeight - k_Height_NavBar - Bottom_Height) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max ? 34 : 0;
}
-(void)textFieldChangeText:(UITextField *)textField
{
    if (textField.text!=nil && ![textField.text isEqualToString:@""]) {
        
        [self searchWithKeyWords:textField.text];
        
    }
}
//根据关键字搜索
-(void)searchWithKeyWords:(NSString *)keywords
{
    [_search cancelAllRequests];
    AMapPOIKeywordsSearchRequest * request=[[AMapPOIKeywordsSearchRequest alloc]init];
    request.city=self.city;
    request.keywords=keywords;
    request.cityLimit = YES;
    [_search AMapPOIKeywordsSearch:request];
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.poiArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShouYeTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"shouyecell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"ShouYeTableViewCell" owner:nil options:nil] firstObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    AMapPOI * poi=self.poiArr[indexPath.row];
    cell.nameLable.text=poi.name;
    cell.detailNameLable.text=poi.address;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI * poi=self.poiArr[indexPath.row];
    self.placeBlock(poi.name, poi.address, [NSString stringWithFormat:@"%f",poi.location.latitude], [NSString stringWithFormat:@"%f",poi.location.longitude]);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)creatTopView{
    self.topView = [[GeoFenceMapTopView alloc] initWithFrame:CGRectMake(0, k_Height_StatusBar, DeviceWidth, 44)];
    __weak typeof(self) weakSelf = self;
    self.topView.cancelBlock = ^{
        weakSelf.placeBlock(@"--", @"--", @"--", @"--");
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self.topView.btn setTitle:@"清除" forState:(UIControlStateNormal)];
    self.topView.searchTF.delegate = self;
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * helloButton = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"收回键盘" style:UIBarButtonItemStyleDone target:self action:@selector(dismissKeyBoard)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:helloButton,btnSpace,doneButton,nil];
    [topView setItems:buttonsArray];
    [self.topView.searchTF setInputAccessoryView:topView];
    [self.topView.searchTF addTarget:self action:@selector(textFieldChangeText:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.topView];
}
-(void)dismissKeyBoard{
    [self.topView.searchTF resignFirstResponder];
}
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }else{
//        NSLog(@"%@",response.pois);
        [self.poiArr removeAllObjects];
        for (AMapPOI *poi in response.pois) {
            [self.poiArr addObject:poi];
        }
        [self.tableView reloadData];
    }
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
