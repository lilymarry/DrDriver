//
//  SuggestionViewController.h
//  takeOut
//
//  Created by mac on 16/10/14.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLable;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextFiled;

@end
