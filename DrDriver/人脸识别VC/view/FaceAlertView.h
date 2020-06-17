//
//  FaceAlertView.h
//  DrDriver
//
//  Created by fy on 2018/9/27.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceAlertView : UIView

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *faceView;
@property(nonatomic,strong)UIImageView *faceImageView;
@property(nonatomic,strong)UILabel *titleLB;
@property(nonatomic,strong)UILabel *detailLB;

@property(nonatomic,strong)UIButton *scanFaceBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong) void (^scanFaceBlock)(NSDictionary *dataDic,NSString *str,NSString *orderID,NSInteger btnState);
//@property(nonatomic,strong) void (^cancel)();


@property(nonatomic,strong)NSDictionary *dataDic;
@property(nonatomic,copy)NSString *state;
@property(nonatomic,copy)NSString *orderID;
@property(nonatomic,assign)NSInteger btnState;

-(void)showFaceAlertView:(NSDictionary *)dataDic state:(NSString *)stateStr orderid:(NSString *)orderID btnSate:(NSInteger)btnSate;
-(void)cancelAction;
-(void)hidenFaceAlertView;
@end
