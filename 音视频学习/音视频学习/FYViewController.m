//
//  FYViewController.m
//  音视频学习
//
//  Created by macbook on 2020/3/31.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import "FYViewController.h"
#import "FYAudioController.h"
#import "FYPreViewController.h"
@interface FYViewController ()

@end

#warning 多谢网络上前人指点，站在巨人肩膀上学习成长

@implementation FYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)audio:(UIButton *)sender {
    FYAudioController *vc = [FYAudioController new];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)vedio:(UIButton *)sender {
    FYPreViewController *vc = [FYPreViewController new];
    [self.navigationController pushViewController:vc animated:YES];
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
