//
//  ShareView.m
//  DrDriver
//
//  Created by fy on 2020/7/3.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()

@end

@implementation ShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil];
        [self addSubview:_thisView];
        
     
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _thisView.frame = self.bounds;
}

@end
