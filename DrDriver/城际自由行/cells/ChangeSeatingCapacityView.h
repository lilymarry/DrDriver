//
//  ChangeSeatingCapacityView.h
//  DrDriver
//
//  Created by fy on 2019/2/18.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeSeatingCapacityView : UIView<UITextViewDelegate>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UILabel *capacityTitleLB;
@property(nonatomic,strong)UITextField *capacityTF;
@property(nonatomic,strong)UILabel *remarkLB;
@property(nonatomic,strong)UITextView *remarkTV;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *coffimBtn;
@property(nonatomic,strong)UILabel *placeHolderLable;




@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UITextField *pintuanTF;
@property(nonatomic,strong)UITextField *yikojiaTF;

@property(nonatomic,strong) void (^cancelBlock)(NSString *number,NSString *remark,NSString *pintuan,NSString *yikojia);
@property(nonatomic,strong) void (^coffimBlock)();

-(instancetype)initWithFrame:(CGRect)frame Number:(NSString *)number pintuan:(NSString *)pintuanStr yikojia:(NSString *)yikojiaStr remark:(NSString *)remarkStr;

@end

NS_ASSUME_NONNULL_END
