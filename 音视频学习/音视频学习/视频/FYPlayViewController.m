//
//  FYPlayViewController.m
//  音视频学习
//
//  Created by macbook on 2020/4/1.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#warning 视屏播放变得很快，是因为对编解码这块不了解，我觉着把这块学习一下，以后能解决掉这个问题

#import "FYPlayViewController.h"

#import "WXCAEAGLLayer.h"
#import "WXVideoDecoder.h"
@interface FYPlayViewController ()
@property(nonatomic, strong) WXCAEAGLLayer *playLayer;
@property(nonatomic, strong) WXVideoDecoder *videoDecoder;
@end

@implementation FYPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _videoDecoder = [[WXVideoDecoder alloc]init];
    
    _playLayer = [[WXCAEAGLLayer alloc] initWithFrame:self.view.bounds];

    [self.view.layer insertSublayer:_playLayer atIndex:0];
    
    __weak __typeof(self)weakSelf = self;
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.h264"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [weakSelf.videoDecoder decodeWithPath:filePath complete:^(CVPixelBufferRef pixelBuffer) {
                NSLog(@">>> pixelBuffer = %@",pixelBuffer);

                weakSelf.playLayer.pixelBuffer = pixelBuffer;
            }];
        });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
