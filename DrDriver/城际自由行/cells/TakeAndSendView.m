//
//  TakeAndSendView.m
//  DrDriver
//
//  Created by fy on 2019/3/13.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "TakeAndSendView.h"

@implementation TakeAndSendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatView];
    }
    return self;
}

-(void)creatView{
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    self.bgView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    [self addSubview:self.bgView];
    
    self.alertView = [[UIView alloc] init];
    self.alertView.backgroundColor = [UIColor whiteColor];
    self.alertView.layer.cornerRadius = 10;
    self.alertView.layer.masksToBounds = YES;
    [self addSubview:self.alertView];
    [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(DeviceWidth - 30);
        make.height.mas_offset(400);
        make.center.equalTo(self);
    }];
    
    self.takeLB = [[UILabel alloc] init];
    self.takeLB.text = @"接乘客顺序";
    [self.alertView addSubview:self.takeLB];
    self.takeLB.font = [UIFont systemFontOfSize:15];
    [self.takeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.alertView).offset(15);
    }];
    
    self.takeTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 25, DeviceWidth - 40, 160) style:(UITableViewStylePlain)];
    self.takeTableView.backgroundColor = [UIColor whiteColor];
    self.takeTableView.showsVerticalScrollIndicator = NO;
    self.takeTableView.delegate = self;
    self.takeTableView.dataSource = self;
    [self.alertView addSubview:self.takeTableView];
    self.takeTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.takeTableView registerClass:[TakeAndSendAlertTableViewCell class] forCellReuseIdentifier:@"TakeAndSendAlertTableViewCell"];
    [self.takeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.takeLB.mas_bottom).offset(10);
        make.width.mas_offset(DeviceWidth - 40);
        make.height.mas_offset(120);
    }];
  
    self.sendLB = [[UILabel alloc] init];
    self.sendLB.text = @"送乘客顺序";
    [self.alertView addSubview:self.sendLB];
    self.sendLB.font = [UIFont systemFontOfSize:15];
    [self.sendLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.takeTableView.mas_bottom).offset(15);
    }];
    
    self.sendTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 25, DeviceWidth - 40, 160) style:(UITableViewStylePlain)];
    self.sendTableView.backgroundColor = [UIColor whiteColor];
    self.sendTableView.showsVerticalScrollIndicator = NO;
    self.sendTableView.delegate = self;
    self.sendTableView.dataSource = self;
    [self.alertView addSubview:self.sendTableView];
    self.sendTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.sendTableView registerClass:[TakeAndSendAlertTableViewCell class] forCellReuseIdentifier:@"TakeAndSendAlertTableViewCell"];
    [self.sendTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.alertView);
        make.top.equalTo(self.sendLB.mas_bottom).offset(10);
        make.width.mas_offset(DeviceWidth - 40);
        make.height.mas_offset(120);
    }];
    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.alertView addSubview:self.closeBtn];
    self.closeBtn.layer.cornerRadius = 5;
    self.closeBtn.layer.masksToBounds = YES;
    [self.closeBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
    [self.closeBtn setBackgroundColor:[CYTSI colorWithHexString:@"#2488ef"]];
    [self.closeBtn addTarget:self action:@selector(affirmAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(DeviceWidth - 120);
        make.height.mas_offset(33);
        make.bottom.equalTo(self.alertView).offset(-20);
        make.centerX.equalTo(self.alertView);
    }];
}
#pragma mark - 表的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.takeTableView]) {
        return self.takeArr.count;
    }else{
        return self.sendArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakeAndSendAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TakeAndSendAlertTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if ([tableView isEqual:self.takeTableView]) {
        [cell setData:self.takeArr[indexPath.row] number:indexPath.row];
    }else{
        [cell setData:self.sendArr[indexPath.row] number:indexPath.row];
    }
    return cell;
}

-(void)showAlertViewTake:(NSArray *)takeArr send:(NSArray *)sendArr;{
    self.takeArr = [NSArray arrayWithArray:takeArr];
    self.sendArr = [NSArray arrayWithArray:sendArr];
    [self.takeTableView reloadData];
    [self.sendTableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    }];
}
-(void)hiddenAlertView{
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(DeviceWidth, 0, DeviceWidth, DeviceHeight);
    }];
}
-(void)affirmAction{
    [self hiddenAlertView];
}

@end
