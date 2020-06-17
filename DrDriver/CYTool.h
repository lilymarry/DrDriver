//
//  CYTool.h
//  takeOut
//
//  Created by mac on 16/10/10.
//  Copyright © 2016年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import <sys/utsname.h>

@interface CYTool : NSObject<MBProgressHUDDelegate>

@property(nonatomic,strong)MBProgressHUD * HUD;

+(CYTool *)sharedInstance;

/**
 *   TOST弹窗
 */
-(void)otherShowTostWithString:(NSString *)str;



/**
 *   判断是否是手机号
 */
-(BOOL)checkTelNumber:(NSString *) telNumber;



/**
 *   手机号中间四位加密
 */
- (void)setPhoneSecretWithLable:(UILabel *)lable string:(NSString *)value;



/**
 *  计算文字宽度
 *  str:            lable显示的文本
 *  lableFont:      字号
 */
-(int)planRectWidth:(NSString *)str font:(int)lableFont;



/**
 *  计算文字高度
 *  str:            lable显示的文本
 *  lableFont:      字号
 *  width:          lable的宽度
 */
-(int)planRectHeight:(NSString *)str font:(int)lableFont theWidth:(int)width;



/**
 *  字符串显示不同颜色
 *  string:         lable显示的文本
 *  str:            要改变颜色的文字
 *  lable:          要设置的lable
 *  textColor:      要改变的部分文字的颜色
 */
-(void)setDefrientColorWith:(NSString *)string someStr:(NSString *)str theLable:(UILabel *)lable theColor:(UIColor *)textColor;



/**
 *  字符串显示不同字号
 *  string:         lable显示的文本
 *  str:            要改变字号的文字
 *  lable:          要设置的lable
 *  textFont:       要改变的部分文字的字号
 */
-(void)setStringWith:(NSString *)string someStr:(NSString *)str lable:(UILabel *)lable theFont:(UIFont *)textFont;



/**
 *  字符串显示不同字号及颜色
 *  string:         lable显示的文本
 *  str:            要改变字号的文字
 *  lable:          要设置的lable
 *  textFont:       要改变的部分文字的字号
 *  textColor:      要改变的部分文字的颜色
 */
-(void)setStringWith:(NSString *)string someStr:(NSString *)str lable:(UILabel *)lable theFont:(UIFont *)textFont theColor:(UIColor *)textColor;



/**
 *  获取某个字符串或者汉字的首字母
 */
- (NSString *)firstCharactorWithString:(NSString *)string;



/**
 *  获取当前日期的  0:年，1:月，2:日，3:时，4:分，5:秒
 */
-(NSInteger)receiveDateType:(int)type;



/**
 *  返回今天的日期
 */
-(NSString *)getToday;



//获取当前时间
- (NSString*)getCurrentTimes;

/**
 *  返回明天的日期
 *  date:某天的日期
 */
-(NSString *)GetTomorrow:(NSDate *)date;



/**
 *  四舍五入
 *  price:         需要处理的数字
 *  position:      保留小数点第几位
 */
-(NSString *)notRounding:(float)price afterPoint:(int)position;



/**
 *  通讯录排序(多音字处理)
 *  string:         要转换的字符串
 */
- (NSString *)transformMandarinToLatin:(NSString *)string;



/**
 *  lineView:       需要绘制成虚线的view
 *  lineLength:     虚线的宽度
 *  lineSpacing:    虚线的间距
 *  lineColor:      虚线的颜色
 */
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;



/**
 *  判断是否是有效的身份证号
 */
- (BOOL)validateIDCardNumber:(NSString *)value;



/**
 *  根据时间戳获得时间字符串
 *  str:         要转换的字符串
 */
-(NSString *)getDateFromInterValue:(NSString *)str;



/**
 *  将十六进制颜色转换为 UIColor 对象
 *  color:        要转换的十六进制字符串
 */
- (UIColor *)colorWithHexString:(NSString *)color;


/**
 *  根据时间戳获得时间字符串
 *  chinese:         汉字
 */
- (NSString *)transformChineseToPinyin:(NSString *)chinese;



/**
 *  对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image;



/**
 * 调整行间距
 * lable:       要设置的lable
 * str:         lable上的字
 */
-(void)setLineSpace:(UILabel *)lable  string:(NSString *)str;



/**
 *  获取当月的天数
 */
- (NSInteger)getNumberOfDaysInMonth;



/**
 *  获取当月中所有天数是周几
 */
- (void) getAllDaysWithCalender;



/**
 *  获得某天的数据
 *
 *  获取指定的日期是星期几
 */
- (id) getweekDayWithDate:(NSDate *) date;



/**
 *  获得当前外网的IP地址
 */
- (NSString*) deviceWANIPAdress;



/**
 判断是否是字母和数字组合
 
 @param secret 要判断的字符串
 @return 返回值
 */
-(BOOL)checkIsIncludeNumberWithLetter:(NSString *)secret;



/**
 崩溃日志名称
 
 @return 返回的名称
 */
-(NSString *)crashName;



/**
 拨打电话
 
 @param phoneStr 电话字符串
 @param selfvc 拨打电话所在视图控制器
 */
-(void)callPhoneStr:(NSString*)phoneStr withVC:(UIViewController *)selfvc;


/**
 获取手机型号
 
 @return 返回手机型号
 */
-(NSString*)iphoneType;

/**
 判断app是否在后台
 
 */
-(BOOL)runningInBackground;



-(NSString *)getDateStr;

-(void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName;

-(UIImage *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength;

//判断是否为数字
-(BOOL)isNumber:(NSString *)strValue;

//时间戳装换为时间到分
- (NSString *)timeWithTimeIntervalString:(NSString *)timeString;

- (int)secondWithTimeIntervalString:(NSString *)timeString;

//时间戳装换为天
- (NSString *)dateWithTimeIntervalString:(NSString *)timeString;

- (NSString *)getCurrentTime;

//将字符串转成NSDate类型
- (NSDate *)dateFromString:(NSString *)dateString;

//传入今天的时间，返回明天的时间
- (NSString *)getTomorrowDay:(NSDate *)aDate;
@end
