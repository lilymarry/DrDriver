//
//  ITOrderView.h
//  DrUser
//
//  Created by fy on 2019/1/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ITOrderView : UIView

@property(nonatomic,strong)UILabel *stateTitleLB;
@property(nonatomic,strong)UILabel *stateLB;
@property(nonatomic,strong)UILabel *priceTitleLB;
@property(nonatomic,strong)UILabel *priceLB;
@property(nonatomic,strong)UILabel *timeTitleLB;
@property(nonatomic,strong)UILabel *timeLB;
//@property(nonatomic,strong)UILabel *remarkLB;
@property(nonatomic,strong)UIButton *kefuBtn;
//@property(nonatomic,strong)UILabel *tuikuanLB;

//@property(nonatomic,strong)void (^kefuBlock)();

-(void)setData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
