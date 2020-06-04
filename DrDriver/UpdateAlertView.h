//
//  UpdateAlertView.h
//  DrUser
//
//  Created by fy on 2018/5/22.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateAlertView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView * alertView;


@property(nonatomic,strong)UIImageView *updateImage;//更新图标
@property(nonatomic,strong)UILabel *titleLabel;//更新标题
@property(nonatomic,strong)UILabel *versionNumberLabel;//更新版本号
@property(nonatomic,strong)UILabel *descriptionLabel;//更新内容描述
@property(nonatomic,strong)UIButton *confirmBtn;//确认按钮
@property(nonatomic,strong)UIButton *cancelBtn;//取消按钮

@end
