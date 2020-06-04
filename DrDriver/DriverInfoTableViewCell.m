//
//  DriverInfoTableViewCell.m
//  DrDriver
//
//  Created by fy on 2019/10/28.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "DriverInfoTableViewCell.h"

@implementation DriverInfoTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = TABLEVIEW_BACKCOLOR;
        self.topTitleLB = [[UILabel alloc] init];
        self.topTitleLB.font = [UIFont systemFontOfSize:13];
        self.topTitleLB.textColor = [UIColor darkGrayColor];
        [self addSubview:self.topTitleLB];
        
        self.xingLB = [[UILabel alloc] init];
        self.xingLB.text = @"*";
        self.xingLB.font = [UIFont systemFontOfSize:15];
        self.xingLB.textColor = [UIColor redColor];
        [self addSubview:self.xingLB];
        
        
        //输入框
        
        self.tfView = [[UIView alloc] init];
        self.tfView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tfView];
        
        self.tf = [[UITextField alloc] init];
        self.tf.borderStyle = UITextBorderStyleNone;
        [self.tfView addSubview:self.tf];
        
       //选择框
        
        self.lbView = [[UIView alloc] init];
        self.lbView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.lbView];
        
        self.lbDetailLB = [[UILabel alloc] init];
        [self.lbView addSubview:self.lbDetailLB];
        
        self.lbArrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"money_arrow"]];
        [self.lbView addSubview:self.lbArrowImageView];
        
        
        //照片选择
        
        self.photoView = [[UIView alloc] init];
        self.photoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.photoView];
        
        self.photoBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.photoBtn setImage:[UIImage imageNamed:@"pic_add"] forState:(UIControlStateNormal)];
        [self.photoBtn addTarget:self action:@selector(photoAction) forControlEvents:(UIControlEventTouchUpInside)];
        [self.photoView addSubview:self.photoBtn];
        
        self.photoTopDetailLB = [[UILabel alloc] init];
        self.photoTopDetailLB.text = @"* 请确保信息完整无缺失";
        self.photoTopDetailLB.textColor = [UIColor redColor];
        self.photoTopDetailLB.font = [UIFont systemFontOfSize:11];
        self.photoTopDetailLB.numberOfLines = 0;
        [self.photoView addSubview:self.photoTopDetailLB];
        
        self.photoBottomDetailLB = [[UILabel alloc] init];
        self.photoBottomDetailLB.text = @"* 请确保照片真实,严禁经过PS处理";
        self.photoBottomDetailLB.textColor = [UIColor redColor];
        self.photoBottomDetailLB.font = [UIFont systemFontOfSize:11];
        self.photoBottomDetailLB.numberOfLines = 0;
        [self.photoView addSubview:self.photoBottomDetailLB];
        
    }
    return self;
}
-(void)layoutSubviews{
    [self.topTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(5);
    }];
    
    [self.xingLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTitleLB.mas_right);
        make.centerY.equalTo(self.topTitleLB);
    }];
    
    
    //输入框
    [self.tfView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.topTitleLB.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.mas_offset(44);
    }];
    
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.and.right.equalTo(self.tfView);
        make.left.equalTo(self.tfView).offset(19);
    }];
    
    //选择
    [self.lbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self.topTitleLB.mas_bottom).offset(5);
        make.right.equalTo(self).offset(-10);
        make.height.mas_offset(44);
    }];
    
    [self.lbArrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lbView.mas_right).offset(2);
        make.centerY.equalTo(self.lbView);
        make.width.mas_offset(15);
        make.height.mas_offset(15);
    }];
    
    [self.lbDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbView).mas_offset(5);
        make.centerY.equalTo(self.lbView);
        make.right.equalTo(self.lbArrowImageView.mas_left).offset(5);
    }];
    
    //照片
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self).offset(10);
       make.top.equalTo(self.topTitleLB.mas_bottom).offset(5);
       make.right.equalTo(self).offset(-10);
       make.height.mas_offset(98);
    }];
    
    [self.photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.photoView);
        make.right.equalTo(self.photoView);
        make.width.mas_offset(140);
        make.height.mas_offset(88);
    }];
    
    [self.photoTopDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.photoView).offset(5);
        make.top.equalTo(self.photoView).offset(10);
        make.right.equalTo(self.photoBtn.mas_left);
    }];
    
    [self.photoBottomDetailLB mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.photoView).offset(5);
       make.top.equalTo(self.photoTopDetailLB.mas_bottom).offset(3);
       make.right.equalTo(self.photoBtn.mas_left);
    }];    
}
-(void)setDataDic:(NSDictionary *)dic{
    self.topTitleLB.text = dic[@"field_desc"];
    if ([dic[@"is_fill"] isEqualToString:@"0"]) {
        self.xingLB.hidden = YES;
    }else{
        self.xingLB.hidden = NO;
    }
    //文本
    if ([dic[@"field_type"] isEqualToString:@"1"]) {
        self.tf.hidden = NO;
        self.lbView.hidden = YES;
        self.photoView.hidden = YES;
        self.tf.placeholder = [NSString stringWithFormat:@"请输入%@",dic[@"field_desc"]];
    }
    //图片
    else if ([dic[@"field_type"] isEqualToString:@"2"]){
        self.tf.hidden = YES;
        self.lbView.hidden = YES;
        self.photoView.hidden = NO;
        NSLog(@"imageimage%@",dic[@"image"]);
        if (dic[@"image"] != nil) {
            [self.photoBtn setImage:dic[@"image"] forState:(UIControlStateNormal)];
        }else{
            [self.photoBtn setImage:[UIImage imageNamed:@"pic_add"] forState:(UIControlStateNormal)];
        }
    }
    //选择
    else if ([dic[@"field_type"] isEqualToString:@"3"] || [dic[@"field_type"] isEqualToString:@"4"]){
        self.tf.hidden = YES;
        self.lbView.hidden = NO;
        self.photoView.hidden = YES;
        self.lbDetailLB.text = [NSString stringWithFormat:@"请选择%@",dic[@"field_desc"]];
    }
}
-(void)photoAction{
    self.photoBlock(self.ipIow);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
