//
//  IndependentTravelView.h
//  DrDriver
//
//  Created by fy on 2019/1/21.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndependentTravelView : UIViewController

@property (nonatomic,assign) BOOL isNeedReload;//是否需要刷新
-(void)creatHttp;
@end

NS_ASSUME_NONNULL_END
