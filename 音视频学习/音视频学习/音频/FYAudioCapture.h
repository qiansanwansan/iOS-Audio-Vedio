//
//  FYAudioCapture.h
//  音视频学习
//
//  Created by macbook on 2020/4/2.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "AACEncoder.h"
#import "AACDecoder.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYAudioCapture : NSObject

@property (nonatomic , strong) NSFileHandle *audioFileHandle;

-(void)creatAudioCapture;

-(void)startAudioInput;

-(void)stopAudioInput;

-(void)playAudio;

@end

NS_ASSUME_NONNULL_END
