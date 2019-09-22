//
//  FirstViewController.m
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import "PushedViewController.h"
#include <pthread.h>

@interface PushedViewController () {
    unsigned long long _timer_source_id;
}

@end

@implementation PushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // 使用
    __weak typeof(self) weakSelf = self;
    _timer_source_id = [_thread addTimerTask:^(LJTaskSourceInfo *latestObj, unsigned long long timer_source_id) {
        NSLog(@"new controller : %llu, %@", timer_source_id, weakSelf);
    } timeInterval:3];
}

- (void)dealloc {
    [_thread dropTimer:_timer_source_id];
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
