//
//  VideoCaptureDevice.h
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//
// 相机视频流处理类
// 初始化之后，设定delegate，即可从代理里面获取到每一个分帧的image
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol CaptureDataOutputProtocol;
@interface VideoCaptureDevice : NSObject
@property (nonatomic, readwrite, weak) id<CaptureDataOutputProtocol> delegate;

@property (nonatomic, readwrite, assign) BOOL runningStatus;

- (instancetype)creatWithFount:(BOOL)isFount;

- (void)startSession;

- (void)stopSession;

- (void)resetSession;


@end

@protocol CaptureDataOutputProtocol <NSObject>

/**
 * 回调每一个分帧的image
 */
- (void)captureOutputSampleBuffer:(UIImage *)image;

- (void)captureError;

@end
