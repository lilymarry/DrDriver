//
//  FaceViewController.h
//  DrDriver
//
//  Created by fy on 2018/9/27.
//  Copyright © 2018年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FaceViewController : UIViewController

@property(nonatomic,strong)UIImageView *faceImageView;
@property(nonatomic,strong)UIButton *faceBtn;
@property(nonatomic,assign)NSInteger face_number;
@property(nonatomic,copy)NSString *driver_face_state;

@property(nonatomic,copy)void (^reloadDataBlock)();

@end
