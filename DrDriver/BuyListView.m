//
//  BuyListView.m
//  DrDriver
//
//  Created by fy on 2020/7/3.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "BuyListView.h"
#import "BuyListViewCell.h"
@interface BuyListView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *imageArr;
    NSArray *nameArr;
 
}
@property(nonatomic,strong)NSIndexPath *lastPath;
@property (weak, nonatomic) IBOutlet UITableView *mTable;
@property (strong, nonatomic) IBOutlet UIButton *payBtn;
@end

@implementation BuyListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"BuyListView" owner:self options:nil];
        [self addSubview:_thisView];
        
        _mTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTable.dataSource=self;
        _mTable.delegate=self;
        [_mTable registerNib:[UINib nibWithNibName:NSStringFromClass([BuyListViewCell class]) bundle:nil] forCellReuseIdentifier:@"BuyListViewCell"];
       
        nameArr=@[@"微信支付",@"支付宝支付",@"银联支付"];
        imageArr=@[@"pay_wechat",@"pay_alipaly",@"pay_unionpay"];
        
        //设置默认初值
      _lastPath= [NSIndexPath indexPathForRow:0 inSection:0];
       [_mTable selectRowAtIndexPath:_lastPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        _payBtn.layer.cornerRadius=15;
        _payBtn.layer.masksToBounds=YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _thisView.frame = self.bounds;
}
- (IBAction)cancelPress:(id)sender {
    [self removeFromSuperview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return nameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BuyListViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BuyListViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    cell.Imagview_flag.image=[UIImage imageNamed:imageArr[indexPath.row]];
    cell.lab_name.text=nameArr[indexPath.row];
    
   if (_lastPath.row==indexPath.row&&_lastPath!=nil) {
              cell.Imagview_select.image=[UIImage imageNamed:@"member_select"];
              
          }
          else
          {
             cell.Imagview_select.image=[UIImage imageNamed:@"member_noselect"];
          }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow =(int) [indexPath row];
    

        int oldRow =(int)( (_lastPath !=nil)?[_lastPath row]:-1);
        if (newRow != oldRow) {
            BuyListViewCell *newcell =(BuyListViewCell *)[tableView cellForRowAtIndexPath:indexPath];
           newcell.Imagview_select.image=[UIImage imageNamed:@"member_select"];
                         
            BuyListViewCell *oldCell =(BuyListViewCell *)[tableView cellForRowAtIndexPath:_lastPath];
            
            oldCell.Imagview_select.image=[UIImage imageNamed:@"member_noselect"];
          
            _lastPath = indexPath;
            
            [_payBtn setTitle:nameArr[indexPath.row] forState:UIControlStateNormal];
        }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
    
}


@end
