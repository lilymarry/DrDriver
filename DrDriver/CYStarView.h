//
//  CYStarView.h
//  Foodspotting
//
//  Created by mac on 16/9/9.
//
//

#import <UIKit/UIKit.h>

@interface CYStarView : UIView

@property (nonatomic, strong) void (^starButtonClicked)(NSInteger);//第几个星星按钮点击了 1~5

-(void)setViewWithNumber:(int)number width:(int)width space:(int)space enable:(BOOL)enable;//创建星星视图

@end
