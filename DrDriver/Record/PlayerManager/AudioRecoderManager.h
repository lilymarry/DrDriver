//
//  AudioRecoderManager.h
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/19.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AudioRecoderManager : NSObject

- (void)startUploadRecoard;

- (void)stopRecord;

@property(nonatomic, copy, readwrite) NSString *order_id;
@property(nonatomic, copy, readwrite) NSString *order_type;//0普通订单，1自由行，2校园拼
@end

NS_ASSUME_NONNULL_END
