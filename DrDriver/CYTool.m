//
//  CYTool.m
//  takeOut
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import "CYTool.h"

static CYTool * CYToolManager=nil;

@implementation CYTool

+(CYTool *)sharedInstance
{
    if (CYToolManager==nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            CYToolManager=[[CYTool alloc]init];
        });
    }
    return CYToolManager;
}

/**
 * TOST弹窗
 */
-(void)otherShowTostWithString:(NSString *)str
{
    UIWindow * window=[UIApplication sharedApplication].delegate.window;
    _HUD = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _HUD.delegate = self;
    _HUD.minShowTime = 2;
    _HUD.activityIndicatorColor=[UIColor whiteColor];
    _HUD.label.textColor=[UIColor whiteColor];
    _HUD.bezelView.backgroundColor=[UIColor blackColor];
    [self showTostWithString:str];
}
-(void)showTostWithString:(NSString *)str
{
    _HUD.mode=MBProgressHUDModeText;
    _HUD.label.textColor=[UIColor whiteColor];
    _HUD.labelText=[NSString stringWithFormat:@"%@",str];
    //    _HUD.detailsLabel.textColor=[UIColor whiteColor];
    //    _HUD.detailsLabel.text=[NSString stringWithFormat:@"%@",str];
    [_HUD hideAnimated:YES afterDelay:1];
}



/**
 *  判断是否是手机号
 */
-(BOOL)checkTelNumber:(NSString *) telNumber
{
    telNumber = [telNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (telNumber.length != 11)
        
    {
        
        return NO;
        
    }else{
        
        NSString *CM_NUM = @"1\\d{10}$";
        
        
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        
        BOOL isMatch1 = [pred1 evaluateWithObject:telNumber];
        
        
        if (isMatch1) {
            
            
            return YES;
            
        }else{
            
            return NO;
            
        }
        
    }
    
}




/**
 * 手机号中间四位加密
 */
- (void)setPhoneSecretWithLable:(UILabel *)lable string:(NSString *)value
{
    if (value.length<4) {
        return;
    }
    NSString * secretStr=[value substringWithRange:NSMakeRange(3,4)];
    NSString * sectet=[value stringByReplacingOccurrencesOfString:secretStr withString:@"****"];
    lable.text=sectet;
}



/**
 *  计算文字宽度
 *  str:            lable显示的文本
 *  lableFont:      字号
 */
-(int)planRectWidth:(NSString *)str font:(int)lableFont
{
    if (str==nil || [str isEqualToString:@""] || [str isKindOfClass:[NSNull class]]) {
        return 0;
    }
    
    CGRect rect=[str boundingRectWithSize:CGSizeMake(DeviceWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:lableFont]} context:nil];
    return rect.size.width+2;
}



/**
 *  计算文字高度
 *  str:            lable显示的文本
 *  lableFont:      字号
 *  width:          lable的宽度
 */
-(int)planRectHeight:(NSString *)str font:(int)lableFont theWidth:(int)width
{
    if (str==nil || [str isEqualToString:@""] || [str isKindOfClass:[NSNull class]]) {
        return 0;
    }
    
    CGRect rect=[str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:lableFont]} context:nil];
    return rect.size.height+2;
}



/**
 *  字符串显示不同颜色
 *  string:         lable显示的文本
 *  str:            要改变颜色的文字
 *  lable:          要设置的lable
 *  textColor:      要改变的部分文字的颜色
 */
-(void)setDefrientColorWith:(NSString *)string someStr:(NSString *)str theLable:(UILabel *)lable theColor:(UIColor *)textColor
{
    NSMutableAttributedString * theStr=[[NSMutableAttributedString alloc]initWithString:string];
    NSRange range=NSMakeRange([[theStr string] rangeOfString:str].location, [[theStr string] rangeOfString:str].length);
    [theStr addAttribute:NSForegroundColorAttributeName value:textColor range:range];
    
    [lable setAttributedText:theStr];
    //    [lable sizeToFit];
    
}



/**
 *  字符串显示不同字号
 *  string:         lable显示的文本
 *  str:            要改变字号的文字
 *  lable:          要设置的lable
 *  textFont:       要改变的部分文字的字号
 */
-(void)setStringWith:(NSString *)string someStr:(NSString *)str lable:(UILabel *)lable theFont:(UIFont *)textFont
{
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:str].location, [[noteStr string] rangeOfString:str].length);
    [noteStr addAttribute:NSFontAttributeName value:textFont range:redRange];
    
    //    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:@"你好"].location, [[noteStr string] rangeOfString:@"你好"].length);
    //    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:redRangeTwo];
    
    [lable setAttributedText:noteStr];
    //    [lable sizeToFit];
}



/**
 *  字符串显示不同字号及颜色
 *  string:         lable显示的文本
 *  str:            要改变字号的文字
 *  lable:          要设置的lable
 *  textFont:       要改变的部分文字的字号
 *  textColor:      要改变的部分文字的颜色
 */
-(void)setStringWith:(NSString *)string someStr:(NSString *)str lable:(UILabel *)lable theFont:(UIFont *)textFont theColor:(UIColor *)textColor
{
    NSLog(@"555555555555555555%@     %@",string,str);
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:str].location, [[noteStr string] rangeOfString:str].length);
    [noteStr addAttribute:NSFontAttributeName value:textFont range:redRange];
    
    NSRange rangeTwo=NSMakeRange([[noteStr string] rangeOfString:str].location, [[noteStr string] rangeOfString:str].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:textColor range:rangeTwo];
    
    [lable setAttributedText:noteStr];
    //    [lable sizeToFit];
}



/**
 *  获取某个字符串或者汉字的首字母
 */
- (NSString *)firstCharactorWithString:(NSString *)string
{
    
    NSMutableString *str = [NSMutableString stringWithString:string];
    
    CFStringTransform((CFMutableStringRef) str, NULL, kCFStringTransformMandarinLatin, NO);
    
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    //    CYLog(@"1获取首字母：%@",str);
    
    /*多音字处理*/
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    
    //    CYLog(@"2获取首字母：%@",str);
    
    NSString *pinYin = [str capitalizedString];
    
    //    CYLog(@"3获取首字母：%@",pinYin);
    
    return [pinYin substringToIndex:1];
    
}



/**
 *  获取当前日期的  0:年，1:月，2:日，3:时，4:分，5:秒
 */
-(NSInteger)receiveDateType:(int)type
{
    //获取当前时间
    NSDate *now = [NSDate date];
    //    CYLog(@"now date is: %@", now);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    //    int year = [dateComponent year];
    //    int month = [dateComponent month];
    //    int day = [dateComponent day];
    //    int hour = [dateComponent hour];
    //    int minute = [dateComponent minute];
    //    int second = [dateComponent second];
    switch (type) {
        case 0://年
        {
            return [dateComponent year];
        }
            break;
        case 1://月
        {
            return [dateComponent month];
        }
            break;
        case 2://日
        {
            return [dateComponent day];
        }
            break;
        case 3://时
        {
            return [dateComponent hour];
        }
            break;
            
        case 4://分
        {
            return [dateComponent minute];
        }
            break;
        default://秒
        {
            return [dateComponent second];
        }
            break;
    }
}


/**
 *  返回今天的日期
 */
-(NSString *)getToday
{
    NSDate * date=[NSDate date];
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * dateStr=[dateFormatter stringFromDate:date];
    
    return dateStr;
}



/**
 *  返回明天的日期
 *  date:某天的日期
 */
-(NSString *)GetTomorrow:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:date];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}



/**
 *  四舍五入
 *  price:         需要处理的数字
 *  position:      保留小数点第几位
 */
-(NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
}



/**
 *  通讯录排序(多音字处理)
 *  string:         要转换的字符串
 */
- (NSString *)transformMandarinToLatin:(NSString *)string
{
    /*复制出一个可变的对象*/
    NSMutableString *preString = [string mutableCopy];
    /*转换成成带音 调的拼音*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformMandarinLatin, NO);
    /*去掉音调*/
    CFStringTransform((CFMutableStringRef)preString, NULL, kCFStringTransformStripDiacritics, NO);
    
    /*多音字处理*/
    if ([[(NSString *)string substringToIndex:1] compare:@"长"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"沈"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 4) withString:@"shen"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"厦"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"xia"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"地"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 3) withString:@"di"];
    }
    if ([[(NSString *)string substringToIndex:1] compare:@"重"] == NSOrderedSame)
    {
        [preString replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
    }
    return preString;
}

/**
 *  lineView:       需要绘制成虚线的view
 *  lineLength:     虚线的宽度
 *  lineSpacing:    虚线的间距
 *  lineColor:      虚线的颜色
 */
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}


/**
 *  判断是否是有效的身份证号
 */
- (BOOL)validateIDCardNumber:(NSString *)value
{
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag =YES;
            
            break;
        }
    }
    
    if (!areaFlag) {
        
        return false;
    }
    
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    int year =0;
    
    switch (length) {
            
        case 15:
            
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"  options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$" options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            //            [regularExpression release];
            
            if(numberofMatch >0) {
                
                return YES;
                
            }else {
                
                return NO;
                
            }
            
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }else {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive
                                                                          error:nil];//测试出生日期的合法性
                
            }
            
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                    
                }else {
                    return NO;
                }
            }else {
                
                return NO;
            }
        default:
            
            return false;
            
    }
}


/**
 *  根据时间戳获得时间字符串
 *  str:         要转换的字符串
 */
-(NSString *)getDateFromInterValue:(NSString *)str
{
    NSDate * date=[NSDate dateWithTimeIntervalSince1970:[str integerValue]];
    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * timeStr=[dateFormatter stringFromDate:date];
    
    return timeStr;
}


/**
 *  将十六进制颜色转换为 UIColor 对象
 *  color:        要转换的十六进制字符串
 */
- (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip "0X" or "#" if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}



/**
 *  根据时间戳获得时间字符串
 *  chinese:         汉字
 */
- (NSString *)transformChineseToPinyin:(NSString *)chinese
{
    if (chinese==nil || [chinese isEqualToString:@""] || [chinese isKindOfClass:[NSNull class]]) {
        return @"";
    }
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    //返回最近结果
    return pinyin;
    
}


/**
 * 对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(1000, 1000 * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



/**
 * 调整行间距
 * lable:       要设置的lable
 * str:         lable上的字
 */
-(void)setLineSpace:(UILabel *)lable  string:(NSString *)str
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];
    lable.attributedText = attributedString;
    //    lable.textAlignment=NSTextAlignmentCenter;
    
    [lable sizeToFit];
}



/**
 *  获取当月的天数
 */
- (NSInteger)getNumberOfDaysInMonth
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDate * currentDate = [NSDate date]; // 这个日期可以你自己给定
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit
                                   inUnit: NSMonthCalendarUnit
                                  forDate:currentDate];
    return range.length;
}



/**
 *  获取当月中所有天数是周几
 */
- (void) getAllDaysWithCalender
{
    NSUInteger dayCount = [self getNumberOfDaysInMonth]; //一个月的总天数
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSDate * currentDate = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString * str = [formatter stringFromDate:currentDate];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableArray * allDaysArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= dayCount; i++) {
        NSString * sr = [NSString stringWithFormat:@"%@-%ld",str,i];
        NSDate *suDate = [formatter dateFromString:sr];
        [allDaysArray addObject:[self getweekDayWithDate:suDate]];
    }
    NSLog(@"allDaysArray %@",allDaysArray);
}



/**
 *  获得某天的数据
 *
 *  获取指定的日期是星期几
 */
- (id) getweekDayWithDate:(NSDate *) date
{
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; // 指定日历的算法
    NSDateComponents *comps = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    // 1 是周日，2是周一 3.以此类推
    return @([comps weekday]);
    
}



/**
 *  获得当前外网的IP地址
 */
- (NSString*) deviceWANIPAdress
{
    return @"";
}



/**
 判断是否是6-12位字母和数字组合
 
 @param secret 要判断的字符串
 @return 返回值
 */
-(BOOL)checkIsIncludeNumberWithLetter:(NSString *)secret
{
    if (secret.length < 6 || secret.length>12) return NO;
    
    //判断是否仅包含数字
    NSString * numberRegex =@"[0-9]*";
    NSPredicate * numberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    BOOL isAllNumber=[numberPred evaluateWithObject:secret];
    if (isAllNumber) {
        return NO;
    }
    
    //判断是否仅包含字母
    NSString * letterRegex =@"[a-zA-Z]*";
    NSPredicate * letterPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",letterRegex];
    BOOL isAllLetter=[letterPred evaluateWithObject:secret];
    if (isAllLetter) {
        return NO;
    }
    
    //判断是否仅包含字母和数字
    NSString * bothRegex =@"[a-zA-Z0-9]*";
    NSPredicate * bothPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bothRegex];
    return [bothPred evaluateWithObject:secret];
    
}



/**
 崩溃日志名称
 
 @return 返回的名称
 */
-(NSString *)crashName
{
    NSDate * date=[NSDate date];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:hh"];
    NSString * name=[formatter stringFromDate:date];
    NSString * crashName=[NSString stringWithFormat:@"IOS:CY:eDriver崩溃日志%@",name];
    
    return crashName;
}



/**
 拨打电话
 
 @param phoneStr 电话字符串
 @param selfvc 拨打电话所在视图控制器
 */
-(void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc
{
    if (phoneStr.length >= 10) {
        NSString *str2 = [[UIDevice currentDevice] systemVersion];
        if ([str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [str2 compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
        {
            NSString* PhoneStr = [NSString stringWithFormat:@"telprompt://%@",phoneStr];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:PhoneStr] options:@{} completionHandler:^(BOOL success) {
                NSLog(@"phone success");
            }];
            
        }else {
            NSMutableString* str1 = [[NSMutableString alloc]initWithString:phoneStr];// 存在堆区，可变字符串
            if (phoneStr.length == 10) {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:7];// 把一个字符串插入另一个字符串中的某一个位置
            }else {
                [str1 insertString:@"-"atIndex:3];// 把一个字符串插入另一个字符串中的某一个位置
                [str1 insertString:@"-"atIndex:8];// 把一个字符串插入另一个字符串中的某一个位置
            }
            NSString * str = [NSString stringWithFormat:@"是否拨打电话\n%@",str1];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str message: nil preferredStyle:UIAlertControllerStyleAlert];
            // 设置popover指向的item
            alert.popoverPresentationController.barButtonItem = selfvc.navigationItem.leftBarButtonItem;
            // 添加按钮
            [alert addAction:[UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                NSLog(@"点击了呼叫按钮10.2下");
                NSString* PhoneStr = [NSString stringWithFormat:@"tel://%@",phoneStr];
                if ([PhoneStr hasPrefix:@"sms:"] || [PhoneStr hasPrefix:@"tel:"]) {
                    UIApplication * app = [UIApplication sharedApplication];
                    if ([app canOpenURL:[NSURL URLWithString:PhoneStr]]) {
                        [app openURL:[NSURL URLWithString:PhoneStr]];
                    }
                }
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                NSLog(@"点击了取消按钮");
            }]];
            [selfvc presentViewController:alert animated:YES completion:nil];
        }
    }
}
//获取手机型号
- (NSString*)iphoneType {
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,3"])  return@"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone9,4"])  return@"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhone X";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhone Simulator";
    
    return platform;
    
}

//判断app是否在后台
-(BOOL)runningInBackground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateBackground);
    
    return result;
}


-(NSString *)getDateStr
{
    NSDate * date=[NSDate date];
    NSDateFormatter * fomatter=[[NSDateFormatter alloc]init];
    [fomatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateStr=[fomatter stringFromDate:date];
    
    return dateStr;
}

-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData * imageData = UIImageJPEGRepresentation(currentImage, 0.1);
    // 获取沙盒目录
    NSString * fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

-(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    // NSLog(@"3333333333333333=======%ld",data.length);
    if (data.length < maxLength) return image;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    return resultImage;
}


-(BOOL)isNumber:(NSString *)strValue
{
    if (strValue == nil || [strValue length] <= 0)
    {
        return NO;
    }
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    NSString *filtered = [[strValue componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if (![strValue isEqualToString:filtered])
    {
        return NO;
    }
    return YES;
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
        return confromTimespStr;
}
- (NSString *)dateWithTimeIntervalString:(NSString *)timeString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


//获取当地时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}
//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
//传入今天的时间，返回明天的时间
- (NSString *)getTomorrowDay:(NSDate *)aDate {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:aDate];
    [components setDay:([components day]+1)];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"yyyy-MM-dd"];
    return [dateday stringFromDate:beginningOfWeek];
}
@end
