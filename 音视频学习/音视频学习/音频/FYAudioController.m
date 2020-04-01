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
@interface FYAudioController ()
<AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic,strong) AVCaptureSession *fyCaptureSession;
@property (nonatomic , strong) AVCaptureConnection *fyAudioConnection;
@property (nonatomic , strong) NSFileHandle *fyAudioFileHandle;

@property(nonatomic, strong) AACEncoder *aacEncoder;
@property(nonatomic, strong) AACDecoder *aacDecoder;
//@property (nonatomic,strong) AVCaptureDeviceInput       *mCaptureDeviceInput;
//@property (nonatomic ,strong) AVCaptureDeviceInput      *mCaptureAudioDeviceInput;//负责从AVCaptureDevice获得输入数据
//@property (nonatomic,strong) AVCaptureVideoDataOutput   *mCaptureVideoOutput;
//@property (nonatomic , strong) AVCaptureAudioDataOutput *mCaptureAudioOutput;
//@property (nonatomic,strong) dispatch_queue_t mCaptureQueue;
//@property (nonatomic,strong) dispatch_queue_t mEncodeQueue;
//
//@property (nonatomic,strong) AVCaptureVideoPreviewLayer *mPreviewLayer;

@property (nonatomic , strong) NSFileHandle *audioFileHandle;

@end

@implementation FYAudioController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatMyAudioCapture];
    [self createFileToDocument];
   
}
- (IBAction)start:(UIButton *)sender {
    [_fyCaptureSession startRunning];
}
- (IBAction)stop:(UIButton *)sender {
    [_fyCaptureSession stopRunning];
}
- (IBAction)play:(UIButton *)sender {
    self.aacDecoder = [[AACDecoder alloc] init];
    [self.aacDecoder play];
}

#pragma mark 创建文件夹句柄
- (void)createFileToDocument{
    NSString *audioFile = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"fyAudioTest.aac"];
    // 有就移除掉
    [[NSFileManager defaultManager] removeItemAtPath:audioFile error:nil];
    // 移除之后再创建
    [[NSFileManager defaultManager] createFileAtPath:audioFile contents:nil attributes:nil];
    self.audioFileHandle = [NSFileHandle fileHandleForWritingAtPath:audioFile];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)creatMyAudioCapture {
    self.aacEncoder = [[AACEncoder alloc] init];
    // 创建会话
    AVCaptureSession *captureSession = [[AVCaptureSession alloc]init];
    _fyCaptureSession = captureSession;
    // 获取麦克风（音频输入）设备
    NSError *error = nil;
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 创建音频设备输入对象
    AVCaptureDeviceInput *audioDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"获取音频输入设备出错: %@", error.description);
    }
    // 添加音频设备输入对象
    if ([captureSession canAddInput:audioDeviceInput]) {
        [captureSession addInput:audioDeviceInput];
    }
    
    // 获取音频输出设备
    AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc]init];
    // 创建串行队列，且必须是串行队列，才能获取到数据，而且不能为空
    dispatch_queue_t audioQueue = dispatch_queue_create([@"Audio Capture Queue" UTF8String], DISPATCH_QUEUE_SERIAL);
    // 添加音频设备输出对象
    if ([captureSession canAddOutput:audioOutput]) {
        [captureSession addOutput:audioOutput];
    }
    // 设置代理，捕获音频数据
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];

    // 保存Connection，用于在SampleBufferDelegate中判断数据来源（是Video/Audio？）
    _fyAudioConnection = [audioOutput connectionWithMediaType:AVMediaTypeAudio];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {

    __weak __typeof(self)weakSelf = self;
    if (connection == _fyAudioConnection) {
        NSLog(@"正在音频采集");
        // 音频编码
        [_aacEncoder encodeSampleBuffer:sampleBuffer completionBlock:^(NSData *encodedData, NSError *error) {
            if (encodedData) {
                [weakSelf.audioFileHandle writeData:encodedData];
            } else {
                NSLog(@"AAC编码失败");
            }
        }];
    } else {
        //
    }
    
}

-(void)dealloc{
    [_audioFileHandle closeFile];
}

@end
