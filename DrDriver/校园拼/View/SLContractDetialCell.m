//
//  SLContractDetialCell.m
//  DrDriver
//
//  Created by qqqqqqq on 2019/12/16.
//  Copyright © 2019 tangchaoke. All rights reserved.
//

#import "SLContractDetialCell.h"
#import "SLStudent.h"

@interface SLContractDetialCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@end
 
@implementation SLContractDetialCell

- (void)setStudent:(SLStudent *)student{
    _student = student;
    if ([_student.m_name isEqualToString:@""]||_student.m_name == nil) {
       self.nameLabel.text = _student.child_name;
    }else{
        self.nameLabel.text = _student.m_name;
    }
    
    if ([_student.child_sex isEqualToString:@"1"]) {//男
        self.sexLabel.text = @"男";
    }else{
       self.sexLabel.text = @"女";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
