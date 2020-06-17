//
//  SLMoreInfoTableViewCell.m
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/2.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "SLMoreInfoTableViewCell.h"
#import "ChildMoreModel.h"

@interface  SLMoreInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *child_name_Label;
@property (weak, nonatomic) IBOutlet UILabel *sex_label;
@property (weak, nonatomic) IBOutlet UIImageView *childImageView;
@property (weak, nonatomic) IBOutlet UIImageView *child_toger_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *child_getCar_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *child_outCar_imageView;
@property (weak, nonatomic) IBOutlet UILabel *driver_go_label;
@property (weak, nonatomic) IBOutlet UILabel *driver_arrive_loabel;
@property (weak, nonatomic) IBOutlet UILabel *child_getCar_label;
@property (weak, nonatomic) IBOutlet UILabel *child_out_label;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *fiveLbal;

@property (weak, nonatomic) IBOutlet UILabel *sisLbale;

@end
@implementation SLMoreInfoTableViewCell

- (void)setChildmore:(ChildMoreModel *)childmore{
    _childmore = childmore;
    self.child_name_Label.text =_childmore.child_name;
     if ([_childmore.child_sex isEqualToString:@"1"]) {
        self.sex_label.text = @"男";
     }else{
       self.sex_label.text = @"女";
     }
     [self.childImageView sd_setImageWithURL:[NSURL URLWithString:_childmore.child_pic] placeholderImage:[UIImage imageNamed:@"defaut"]];
     [self.child_toger_ImageView sd_setImageWithURL:[NSURL URLWithString:_childmore.group_photo] placeholderImage:[UIImage imageNamed:@"defaut"]];
      [self.child_getCar_ImageView sd_setImageWithURL:[NSURL URLWithString:_childmore.aboard_pic] placeholderImage:[UIImage imageNamed:@"defaut"]];
     [self.child_outCar_imageView sd_setImageWithURL:[NSURL URLWithString:_childmore.debus_pic] placeholderImage:[UIImage imageNamed:@"defaut"]];
    self.driver_go_label.hidden = YES;
    self.driver_arrive_loabel.hidden = YES;
    self.child_getCar_label.hidden = YES;
    self.child_out_label.hidden = YES;
    self.fiveLbal.hidden = YES;
    self.sisLbale.hidden = YES;
    self.bgView.hidden = YES;
//    NSArray *array = [_childmore.order_times componentsSeparatedByString:@","]; //字符串按照,分隔成数组
    if (_childmore.order_times.count > 0) {
      self.bgView.hidden = NO;
    }
     for (int i = 0; i < _childmore.order_times.count; i++) {
         switch (i) {
            case 0:
             {
               self.driver_go_label.text = _childmore.order_times[0];
               self.driver_go_label.hidden = NO;
             }
            
                 break;
             case 1:{
                 self.driver_arrive_loabel.text = _childmore.order_times[1];
                 self.driver_arrive_loabel.hidden = NO;
             }
               
               break;
             case 2:{
                 self.child_getCar_label.text = _childmore.order_times[2];
                 self.child_getCar_label.hidden = NO;
             }
               
               break;
             case 3:{
                 self.child_out_label.hidden = NO;
                self.child_out_label.text = _childmore.order_times[3];
             }
               
               break;
         case 4:{
                       self.fiveLbal.hidden = NO;
                      self.fiveLbal.text = _childmore.order_times[4];
                   }
                     
                     break;
         case 5:{
                       self.sisLbale.hidden = NO;
                      self.sisLbale.text = _childmore.order_times[5];
                   }
                     
                     break;
         case 6:{
//                       self.child_out_label.hidden = NO;
//                      self.child_out_label.text = _childmore.order_times[6];
                   }
                     
                     break;
         case 7:{
//                       self.child_out_label.hidden = NO;
//                      self.child_out_label.text = _childmore.order_times[7];
                   }
                     
                     break;
         case 8:{
//                            self.child_out_label.hidden = NO;
//                           self.child_out_label.text = _childmore.order_times[8];
                        }
                          
                          break;
         case 9:{
//                            self.child_out_label.hidden = NO;
//                           self.child_out_label.text = _childmore.order_times[9];
                        }
                          
                          break;
         case 10:{
//                            self.child_out_label.hidden = NO;
//                           self.child_out_label.text = _childmore.order_times[10];
                        }
                          
                          break;

             default:
                 break;
         }
     }
}



@end
