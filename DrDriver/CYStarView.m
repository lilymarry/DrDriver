//
//  CYStarView.m
//  Foodspotting
//
//  Created by mac on 16/9/9.
//
//

#import "CYStarView.h"

@implementation CYStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//创建星星视图
-(void)setViewWithNumber:(int)number width:(int)width space:(int)space enable:(BOOL)enable
{
    for (int i=0; i<5; i++) {
        UIButton * starButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [starButton setImage:[UIImage imageNamed:@"shoper_star_gray"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"shoper_star_slected"] forState:UIControlStateSelected];
        
        if (enable) {
            starButton.tag=10+i;
            [starButton addTarget:self action:@selector(starButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        starButton.selected=YES;
        if (i>number-1) {
            starButton.selected=NO;
        }
        [self addSubview:starButton];
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((width+space)*(i%5));
            make.centerY.equalTo(self.mas_centerY);
            make.height.and.width.mas_equalTo(width);
        }];
    }
}

//星星按钮点击事件 tag:10+i
-(void)starButtonClicked:(UIButton *)btn
{
    for (int i=0; i<5; i++) {
        
        UIButton * starButton=[self viewWithTag:i+10];
        
        starButton.selected=YES;
        if (i>btn.tag-10) {
            starButton.selected=NO;
        }
        
    }
    
    self.starButtonClicked(btn.tag-9);
    
}

@end
