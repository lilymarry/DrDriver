//
//  SearchTopView.h
//  DrUser
//
//  Created by fy on 2018/8/3.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTopView : UIView


@property(nonatomic,strong)UIImageView *searchImage;
@property(nonatomic,strong)UIImageView *scanImage;
@property(nonatomic,strong)UITextField *CommericalTenantTF;
@property(nonatomic,strong)UILabel *placeHolderLB;
@property(nonatomic,copy)NSString *placeHolderText;

-(instancetype)initWithFrame:(CGRect)frame withName:(NSString *)placeHoldText;

@property(nonatomic,strong)void (^scanActionBlock)();

@end
