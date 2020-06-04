//
//  GeoFenceMapTopView.h
//  DrUser
//
//  Created by fy on 2019/3/8.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GeoFenceMapTopView : UIView

@property(nonatomic,strong)UITextField *searchTF;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)void(^cancelBlock)();

@end

NS_ASSUME_NONNULL_END
