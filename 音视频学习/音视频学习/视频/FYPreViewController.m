//
//  FYPreViewController.m
//  音视频学习
//
//  Created by macbook on 2020/4/1.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import "FYPreViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WXVideoEncoder.h"
#import "WXVideoDecoder.h"
#import "FYPlayViewController.h"
#import "WXCAEAGLLayer.h"

@interface FYPreViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>

///摄像头位置，默认为前置摄像头
@property(nonatomic, assign) AVCaptureDevicePosition devicePosition;
/// 视频分辨率，有人说默认为1280x720
@property(nonatomic, assign) AVCaptureSessionPreset sessionPresent;
/// 每秒多少帧，有人说默认是15帧
//@property(nonatomic, assign) NSInteger frameRate;
/// 摄像头方向，默认为当前手机屏幕方向
@property(nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

@property(nonatomic, strong) AVCaptureSession *fyCaptureSession;
@property(nonatomic, strong) AVCaptureDeviceInput *deviceInput;
@property(nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;

@property(nonatomic, strong) WXCAEAGLLayer *playLayer;

/// 预览图层
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property(nonatomic, strong) WXVideoEncoder *videoEncoder;
//@property(nonatomic, strong) WXVideoDecoder *videoDecoder;

@end

@implementation FYPreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    
    [self baseSetting];
    [self initVideoCapture];
    [self setPreview];
}
- (void)baseSetting {
    _devicePosition = AVCaptureDevicePositionFront;
    _sessionPresent = AVCaptureSessionPreset1920x1080;
//    _frameRate = 30;
    _videoOrientation = AVCaptureVideoOrientationPortrait;
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
            _videoOrientation = AVCaptureVideoOrientationPortrait;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            _videoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            _videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
            
        default:
            break;
    }
    
    _videoEncoder = [[WXVideoEncoder alloc]init];
//    [_videoEncoder createWithWidth:self.view.bounds.size.width height:self.view.bounds.size.height frameInterval:30];
    
//    _videoDecoder = [[WXVideoDecoder alloc]init];
}

- (void)initVideoCapture {
    // 创建会话
    AVCaptureSession *fyCaptureSession = [[AVCaptureSession alloc]init];
    _fyCaptureSession = fyCaptureSession;
    [fyCaptureSession setSessionPreset:_sessionPresent];
    // 设置输入输出
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"获取视频输入设备出错");
    }
    _deviceInput = videoDeviceInput;
    if ([fyCaptureSession canAddInput:videoDeviceInput]) {
        [fyCaptureSession addInput:videoDeviceInput];
    }
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    if ([fyCaptureSession canAddOutput:videoOutput]) {
        [fyCaptureSession addOutput:videoOutput];
    }
    _videoOutput = videoOutput;
    dispatch_queue_t videoQueue = dispatch_queue_create([@"Video Capture Queue" UTF8String], DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    
    // 设置输出视频方向
    AVCaptureConnection * connection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([connection isVideoOrientationSupported]) {
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
}
- (void)setPreview {
    // 初始化预览图层并关联当前视频会话
    _videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_fyCaptureSession];
    _videoPreviewLayer.frame = self.view.bounds;
    // 如果需要全屏可以设置该属性
//    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:_videoPreviewLayer atIndex:0];
}
- (IBAction)startCapture:(UIButton *)sender {
    // 关闭上一条session
    [_fyCaptureSession stopRunning];
    
    [_videoEncoder endEncode];
    // 重新创建编码文件
    [_videoEncoder createWithWidth:self.view.bounds.size.width height:self.view.bounds.size.height frameInterval:30];
    
    [self switchCamera:AVCaptureDevicePositionBack];
    [_fyCaptureSession startRunning];
}
- (IBAction)stopCapture:(UIButton *)sender {
    [_fyCaptureSession stopRunning];
}
- (IBAction)reverseCamera:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self switchCamera:AVCaptureDevicePositionFront];
    } else {
        [self switchCamera:AVCaptureDevicePositionBack];
    }
}
- (IBAction)decoder:(UIButton *)sender {
    
    FYPlayViewController *vc = [FYPlayViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    [_videoEncoder encode:CMSampleBufferGetImageBuffer(sampleBuffer)];
}
- (void)switchCamera:(AVCaptureDevicePosition)position {
    
    // 获取当前设备方向
    AVCaptureDevicePosition curPosition = _deviceInput.device.position;
    
    if (curPosition == position) {
        return;
    }
    // 创建设备输入对象
    AVCaptureDevice *captureDevice = [AVCaptureDevice  defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:position];
    
    // 获取改变的摄像头输入设备
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];

    // 移除之前摄像头输入设备
    [_fyCaptureSession removeInput:_deviceInput];
    
    // 添加新的摄像头输入设备
    [_fyCaptureSession addInput:videoDeviceInput];
    
    // 记录当前摄像头输入设备
    _deviceInput = videoDeviceInput;
    
    //重置采集方向
    AVCaptureConnection *connection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    if ([connection isVideoOrientationSupported]) {
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }
}
- (void)dealloc {

    if (_fyCaptureSession) {
        [_fyCaptureSession stopRunning];
        _fyCaptureSession = nil;
    }
    if (_deviceInput) {
        _deviceInput = nil;
    }
    if (_videoOutput) {
        _videoOutput = nil;
    }
    
    [_videoPreviewLayer removeFromSuperlayer];
    _videoPreviewLayer = nil;
}
@end
