//
//  FYViewController.m
//  音视频学习
//
//  Created by macbook on 2020/3/31.
//  Copyright © 2020 音视频学习. All rights reserved.
//

#import "FYViewController.h"
#import "FYAudioController.h"

@interface FYViewController ()

@end

@implementation FYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)audio:(UIButton *)sender {
    FYAudioController *vc = [FYAudioController new];
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
