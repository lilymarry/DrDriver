//
//  TopTypeView.h
//  DrDriver
//
//  Created by fy on 2019/2/22.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopTypeView : UIView

@property(nonatomic,strong)UIButton *ITDriverBtn;
@property(nonatomic,strong)UIButton *ITUserBtn;

-(void)showITTopView;
-(void)hidenITTopView;

@property(nonatomic,strong)void (^ITDriverActionBlock)();
@property(nonatomic,strong)void (^ITUserActionBlock)();

@end

NS_ASSUME_NONNULL_END
