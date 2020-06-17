//
//  AudioRecoderManager.m
//  DrDriver
//
//  Created by qqqqqqq on 2020/1/19.
//  Copyright © 2020 tangchaoke. All rights reserved.
//

#import "AudioRecoderManager.h"
#import <AVFoundation/AVFoundation.h>
#import "PlayerManager.h"
#import "ConvertAudioFile.h"
#import <AFNetworking.h>

#define isValidString(string) (string && [string isEqualToString:@""] == NO)
#define ETRECORD_RATE 11025.0

@interface AudioRecoderManager ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) NSString *mp3Path;
@property (nonatomic, strong) NSString *cafPath;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation AudioRecoderManager

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
- (AVAudioRecorder *)audioRecorder {
    if (!_audioRecorder) {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (session == nil) NSLog(@"Error creating session: %@", [sessionError description]);
        else [session setActive:YES error:nil];

        //创建录音文件保存路径
        NSURL *url = [self getSavePath];
        //创建录音格式设置
        NSDictionary *setting = [self getAudioSetting];
        //创建录音机
        NSError *error = nil;
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate = self;
        _audioRecorder.meteringEnabled = YES;//如果要监控声波则必须设置为YES
        [_audioRecorder prepareToRecord];
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@", error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */
- (NSDictionary *)getAudioSetting {
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    [dicM setObject:@(ETRECORD_RATE) forKey:AVSampleRateKey];
    [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    [dicM setObject:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    return dicM;
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
- (NSURL *)getSavePath {
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"AudioData"];
    NSLog(@"%@", path);

    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!bCreateDir) {
            NSLog(@"创建文件夹失败！");
        }
        NSLog(@"创建文件夹成功，文件路径%@", path);
    }
    NSString *fileName = @"record";
    NSString *cafFileName = [NSString stringWithFormat:@"%@.caf", fileName];
    NSString *mp3FileName = [NSString stringWithFormat:@"%@.mp3", fileName];

    NSString *cafPath = [path stringByAppendingPathComponent:cafFileName];
    NSString *mp3Path = [path stringByAppendingPathComponent:mp3FileName];

    self.mp3Path = mp3Path;
    self.cafPath = cafPath;

    NSLog(@"file path:%@", cafPath);

    NSURL *url = [NSURL fileURLWithPath:cafPath];
    return url;
}

- (void)cleanCafFile {
    if (isValidString(self.cafPath)) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.cafPath isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.cafPath error:nil];
            NSLog(@"  xxx.caf  file   already delete");
        }
    }
}

- (void)cleanMp3File {
    if (isValidString(self.mp3Path)) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir = FALSE;
        BOOL isDirExist = [fileManager fileExistsAtPath:self.mp3Path isDirectory:&isDir];
        if (isDirExist) {
            [fileManager removeItemAtPath:self.mp3Path error:nil];
            NSLog(@"  xxx.mp3  file   already delete");
        }
    }
}

- (void)startUploadRecoard {
    if (![self.audioRecorder isRecording]) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if (session == nil) NSLog(@"Error creating session: %@", [sessionError description]);
        else [session setActive:YES error:nil];
        [self.audioRecorder record];
        NSLog(@"录音开始");
    } else {
        NSLog(@"is  recording now  ....");
    }
}

- (void)stopRecord {
    if ([self.audioRecorder isRecording]) {
        __weak typeof(self) weakSelf = self;
        [ConvertAudioFile conventToMp3WithCafFilePath:self.cafPath
                                          mp3FilePath:self.mp3Path
                                           sampleRate:ETRECORD_RATE
                                             callback:^(BOOL result) {
            NSLog(@"转码结果 ------ %d", result);
            AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
            NSString *order_name;
            if ([weakSelf.order_type isEqualToString:@"0"]) {
                order_name = @"order_id";
            } else if ([weakSelf.order_type isEqualToString:@"1"]) {
                order_name = @"travel_id";
            } else if ([weakSelf.order_type isEqualToString:@"2"] || [weakSelf.order_type isEqualToString:@"3"]) {
                order_name = @"route_id";
            }
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"application/json", nil ];
            [manager POST:[NSString stringWithFormat:@"%@Driver/SchoolBus/uploadSound", HTTP_URL] parameters:@{ @"driver_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userid"], @"token": [[NSUserDefaults standardUserDefaults] objectForKey:@"token"], order_name: weakSelf.order_id, @"order_type": weakSelf.order_type } constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];                                       //这里面没做优化,建议用一个单例
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];                                   //文件名
                NSData *filedata = [NSData dataWithContentsOfFile:weakSelf.mp3Path];
                [formData appendPartWithFileData:filedata name:@"order_sound" fileName:fileName mimeType:@".mp3"]; //name:file与服务器对应
            } progress:^(NSProgress *_Nonnull uploadProgress) {
            } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
//                NSLog(@"uploadSound ================%@", responseObject[@"data"]);
                if ([responseObject[@"flag"] isEqualToString:@"success"]) {
                    NSLog(@"上传成功");
                    [weakSelf cleanMp3File];
                    [weakSelf cleanCafFile];
                    weakSelf.audioRecorder = nil;
                    [weakSelf.audioRecorder stop];
                }
            } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
                NSLog(@"uploadSound ============上传错误 error === %@", error);
            }];
        }];
        NSLog(@"完成");
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        NSLog(@"----- 录音  完毕");

        [[ConvertAudioFile sharedInstance] sendEndRecord];
    }
}

@end
