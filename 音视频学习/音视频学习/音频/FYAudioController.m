//
//  FYAudioController.m
//  音视频学习
//
//  Created by macbook on 2020/3/31.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import "FYAudioController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "AACEncoder.h"
#import "AACDecoder.h"
#import "FYAudioCapture.h"
@interface FYAudioController ()

@property(nonatomic, strong) FYAudioCapture *audioCapture;

@end

@implementation FYAudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FYAudioCapture *audioCapture = [[FYAudioCapture alloc]init];
    _audioCapture = audioCapture;
    
}
- (IBAction)start:(UIButton *)sender {
    [_audioCapture startAudioInput];
}
- (IBAction)stop:(UIButton *)sender {
    [_audioCapture stopAudioInput];
}
- (IBAction)play:(UIButton *)sender {
    [_audioCapture playAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [_audioCapture.audioFileHandle closeFile];
}

@end
