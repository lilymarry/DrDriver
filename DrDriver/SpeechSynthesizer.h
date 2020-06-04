//
//  SpeechSynthesizer.h
//  DrDriver
//
//  Created by mac on 2017/8/11.
//  Copyright © 2017年 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SpeechSynthesizer : NSObject

@property (nonatomic, strong, readwrite) AVSpeechSynthesizer *speechSynthesizer;

/** * iOS7及以上版本可以使用 AVSpeechSynthesizer 合成语音 * * 或者采用"科大讯飞"等第三方的语音合成服务 */
+ (instancetype)sharedSpeechSynthesizer;
- (BOOL)isSpeaking;
- (void)speakString:(NSString *)string;
- (void)stopSpeak;

@end
