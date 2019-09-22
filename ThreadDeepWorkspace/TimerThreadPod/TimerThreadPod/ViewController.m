//
//  ViewController.m
//  TimerThreadPod
//
//  Created by 李晋 on 2019/9/22.
//  Copyright © 2019 李晋. All rights reserved.
//

#import "ViewController.h"
#import <LJTimerThread/LJTimerThread.h>
@interface ViewController () {
    LJTimerThread *_thread;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    static int a = 0;
    _thread = [LJTimerThread threadWithTask:^(LJTaskSourceInfo *latestObj, unsigned long long timer_source_id) {
        NSLog(@"%llu", timer_source_id);
        if (a++ == 10) {
            [self->_thread cancel];
        }
    } timeInterval:2 callBack:^(unsigned long long source_id) {
        
    }];
    [_thread start];
    // Do any additional setup after loading the view.
}


@end
