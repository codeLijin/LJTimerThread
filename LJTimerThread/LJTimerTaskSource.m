//
//  LJTimerTaskSource.m
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import "LJTimerTaskSource.h"
@interface LJTimerTaskSource ()
/**
 定时器构造类型
 */
@property (nonatomic, readwrite, assign) LJTHREADINITTYPE type;

@end

@implementation LJTimerTaskSource

- (instancetype)delegate:(id<LJThreadDelegate>)delegate
                        task:(lj_timerThreadTask)task
                timeInterval:(NSTimeInterval)ti {
    if ([self delegate:delegate task:task timeInterval:ti stat:LJTHREADTIMERSTAT_VALID]) {
        
    }
    return self;
}

- (instancetype)delegate:(id<LJThreadDelegate>)delegate
                        task:(lj_timerThreadTask)task
                timeInterval:(NSTimeInterval)ti
                        stat:(LJTHREADTIMERSTAT)stat {
    if ([self initWithDelegate:delegate task:task timeInterval:ti runLoopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:stat]) {
        
    }
    return self;
}

- (instancetype)delegate:(id<LJThreadDelegate>)delegate
                    task:(lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti
                    runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode {
    if ([self initWithDelegate:delegate task:task timeInterval:ti runLoopMode:runLoopMode stat:LJTHREADTIMERSTAT_VALID]) {
        
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LJThreadDelegate>)delegate
                                            task:(lj_timerThreadTask)task
                                   timeInterval:(NSTimeInterval)ti
             runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode
                    stat:(LJTHREADTIMERSTAT)stat {
    NSAssert((!delegate + !task) == 1, @"arg of delegate or task must choose one");
    if (self = [super init]) {
        if (delegate) {
            _type = LJTHREADINITTYPE_DELEGATE;
        } else {
            _type = LJTHREADINITTYPE_TASK;
        }
        _source_id = [[NSDate date] timeIntervalSince1970]*1000;
        _source_id_adjust = false;
        _emb_in = false;
        _delegate = delegate;
        _task = task;
        _ti = ti;
        _runLoopMode = runLoopMode;
        _timer_stat = stat;
    }
    return self;
}

- (void)invalidate {
    self.timer_stat = LJTHREADTIMERSTAT_CANCEL;
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.latestObj = nil;
    self.delegate = nil;
    self.task = nil;
}

- (void)timer_suspend {
    if (self.timer && self.timer.isValid) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timer_stat = LJTHREADTIMERSTAT_SUSPEND;
    }
}

- (void)timer_active {
    if (self.timer && self.timer.isValid) {
        [self.timer setFireDate:[NSDate date]];
        self.timer_stat = LJTHREADTIMERSTAT_VALID;
    }
}

- (LJTaskSourceInfo *)latestObj {
    if (!_latestObj) {
        _latestObj = [[LJTaskSourceInfo alloc] init];
    }
    return _latestObj;
}

#pragma mark - getter
- (NSRunLoopMode)runloopMode_t {
    switch (_runLoopMode) {
        case LJTIMERRUNLOOPMODETYPE_COMMONS:
            return NSRunLoopCommonModes;
        case LJTIMERRUNLOOPMODETYPE_DEFAULT:
            return NSDefaultRunLoopMode;
        case LJTIMERRUNLOOPMODETYPE_TRACKING:
            return UITrackingRunLoopMode;
        default:
            return NSDefaultRunLoopMode;
            break;
    }
    return nil;
}

@end


