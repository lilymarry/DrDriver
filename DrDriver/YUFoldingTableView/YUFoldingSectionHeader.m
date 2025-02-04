//
//  YUFoldingSectionHeader.m
//  YUFoldingTableView
//
//  Created by administrator on 16/8/24.
//  Copyright © 2016年 timelywind. All rights reserved.
//

#import "YUFoldingSectionHeader.h"

static CGFloat const YUFoldingSeperatorLineWidth = 0.3f;
static CGFloat const YUFoldingMargin             = 8.0f;
static CGFloat const YUFoldingIconWidth           = 15.0f;

@interface YUFoldingSectionHeader ()
@property (nonatomic, strong) UIView   *bgView;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *lineLB;
@property (nonatomic, strong) UIImageView  *arrowImageView;
@property (nonatomic, strong) CAShapeLayer  *separatorLine;
@property (nonatomic, assign) YUFoldingSectionHeaderArrowPosition  arrowPosition;
@property (nonatomic, assign) YUFoldingSectionState  sectionState;
@property (nonatomic, strong) UITapGestureRecognizer  *tapGesture;

@property (nonatomic, assign) NSInteger sectionIndex;

@end

@implementation YUFoldingSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self setupSubviews];

    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupSubviews];
    
}

// 创建子视图
- (void)setupSubviews
{
    _autoHiddenSeperatorLine = NO;
    _separatorLineColor = [UIColor whiteColor];
    _arrowPosition = YUFoldingSectionHeaderArrowPositionRight;
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.lineLB];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addGestureRecognizer:self.tapGesture];
    [self.contentView.layer addSublayer:self.separatorLine];
}

- (void)configWithBackgroundColor:(UIColor *)backgroundColor
                     titleString:(NSString *)titleString
                      titleColor:(UIColor *)titleColor
                       titleFont:(UIFont *)titleFont
               descriptionString:(NSString *)descriptionString
                descriptionColor:(UIColor *)descriptionColor
                 descriptionFont:(UIFont *)descriptionFont
                      arrowImage:(UIImage *)arrowImage
                   arrowPosition:(YUFoldingSectionHeaderArrowPosition)arrowPosition
                    sectionState:(YUFoldingSectionState)sectionState
                    sectionIndex:(NSInteger)sectionIndex
{
    _sectionIndex = sectionIndex;
    [self.contentView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    self.titleLabel.text = titleString;
    self.titleLabel.textColor = titleColor;
    self.titleLabel.font = titleFont;
    
    self.arrowImageView.image = arrowImage;
    self.arrowPosition = arrowPosition;
    self.sectionState = sectionState;
    
    if (sectionState == YUFoldingSectionStateShow) {
        if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }else{
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }
    } else {
        if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
        }else{
            _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        }
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelWidth = (self.frame.size.width - YUFoldingMargin * 2 - YUFoldingIconWidth)/2;
    CGFloat labelHeight = self.frame.size.height;
    CGRect arrowRect = CGRectMake(0, 22, YUFoldingIconWidth, YUFoldingIconWidth);
    CGRect titleRect = CGRectMake(YUFoldingMargin + YUFoldingIconWidth , 5, labelWidth, labelHeight);
    CGRect descriptionRect = CGRectMake(YUFoldingMargin + YUFoldingIconWidth + labelWidth,  0, labelWidth, labelHeight);
    if (_arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
        arrowRect.origin.x = 80;
        titleRect.origin.x = YUFoldingMargin;
        descriptionRect.origin.x = YUFoldingMargin + labelWidth;
    }
    [self.bgView setFrame:CGRectMake(0, 10, self.frame.size.width, 40)];
    [self.titleLabel setFrame:titleRect];
    [self.lineLB setFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    [self.arrowImageView setFrame:arrowRect];
    [self.separatorLine setPath:[self getSepertorPath].CGPath];
}


// MARK: -----------------------  event

- (void)shouldExpand:(BOOL)shouldExpand
{
    
    [UIView animateWithDuration:0.2  animations:^{
        if (shouldExpand) {
            if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }else{
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }
        } else {
            if (self.arrowPosition == YUFoldingSectionHeaderArrowPositionRight) {
                self.arrowImageView.transform = CGAffineTransformMakeRotation(0);
            }else{
                _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
            }
        }
    } completion:^(BOOL finished) {
        if (_autoHiddenSeperatorLine) {
            if (finished == YES) {
                self.separatorLine.hidden = shouldExpand;
            }
        }
    }];
}


- (void)onTapped:(UITapGestureRecognizer *)gesture
{
    [self shouldExpand:![NSNumber numberWithInteger:self.sectionState].boolValue];
    if (_tapDelegate && [_tapDelegate respondsToSelector:@selector(yuFoldingSectionHeaderTappedAtIndex:)]) {
        self.sectionState = [NSNumber numberWithBool:(![NSNumber numberWithInteger:self.sectionState].boolValue)].integerValue;
        [_tapDelegate yuFoldingSectionHeaderTappedAtIndex:_sectionIndex];
    }
}

// MARK: -----------------------  getter
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
-(UILabel *)lineLB{
    if (!_lineLB) {
        _lineLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _lineLB.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineLB;
}
- (UIImageView *)arrowImageView
{
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrowImageView.backgroundColor = [UIColor clearColor];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _arrowImageView;
}
- (CAShapeLayer *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [CAShapeLayer layer];
        _separatorLine.strokeColor = _separatorLineColor.CGColor;
        _separatorLine.lineWidth = YUFoldingSeperatorLineWidth;
    }
    return _separatorLine;
}

- (UITapGestureRecognizer *)tapGesture
{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapped:)];
    }
    return _tapGesture;
}

- (UIBezierPath *)getSepertorPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height - YUFoldingSeperatorLineWidth)];
    [path addLineToPoint:CGPointMake(self.frame.size.width, self.frame.size.height - YUFoldingSeperatorLineWidth)];
    return path;
}

@end
