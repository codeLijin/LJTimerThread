//
//  LiThread.m
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//



#import "LJTimerThread.h"

#define TIMER_SOURCE_ID_ADJUST -10240

@interface LJTimerThread () {
    
}
@property (nonatomic, readwrite, assign, getter=is_keepRunning) BOOL  keepRunning;
/**
 资源ID调剂
 */
@property (nonatomic, readwrite, assign) long source_id_adjust;
/**
 队列
 */
@property (nonatomic, readwrite, strong) NSHashTable<LJTimerTaskSource *>  *sources;
@end
@implementation LJTimerThread

#pragma mark - structure
+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    return [self threadWithTask:task timeInterval:ti stat:LJTHREADTIMERSTAT_VALID callBack:getSource_id];
}

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    return [self threadWithDelegate:delegate timeInterval:ti stat:LJTHREADTIMERSTAT_VALID callBack:getSource_id ];
}

+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    return [self threadWithTask:task timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:stat callBack:getSource_id];
}

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    return [self threadWithDelegate:delegate timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:stat callBack:getSource_id ];
}

+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    LJTimerTaskSource *source = [[LJTimerTaskSource alloc] initWithDelegate:nil task:task timeInterval:ti runLoopMode:loopMode stat:stat];
    LJTimerThread *thread = [[LJTimerThread alloc] initWithSource:source getSource_id:getSource_id];
    return thread;
}

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                       runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id {
    LJTimerTaskSource *source = [[LJTimerTaskSource alloc] initWithDelegate:delegate task:nil timeInterval:ti runLoopMode:loopMode stat:stat];
    LJTimerThread *thread = [[self alloc] initWithSource:source getSource_id:getSource_id];
    return thread;
}

+ (instancetype)threadWithSource:(nullable LJTimerTaskSource *)source callBack:(nullable lj_timerThreadGetSourceID)getSource_id {
    LJTimerThread *thread = [[self alloc] initWithSource:source getSource_id:getSource_id];
    return thread;
}

#pragma mark - init
- (instancetype)initWithSource:(nullable LJTimerTaskSource *)source getSource_id:(nullable lj_timerThreadGetSourceID)getSource_id {
    self = [super init];
    if (self) {
        _source_id_adjust = TIMER_SOURCE_ID_ADJUST;
        if (source) {
            [self _addSource:source withAdjust:YES];
            if (getSource_id) {
                getSource_id(source.source_id);
            }
        }
    }
    return self;
}

#pragma mark - Public Method
// add
- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti {
    return [self addTimerTask:task timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:LJTHREADTIMERSTAT_VALID];
}

- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat {
    return [self addTimerTask:task timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:stat];
}

- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat {
    LJTimerTaskSource *source = [[LJTimerTaskSource alloc] initWithDelegate:nil task:task timeInterval:ti runLoopMode:loopMode stat:stat];
    unsigned long long source_id = [self _addSource:source withAdjust:YES];
    [self _addTimerControl];
    return source_id;
}

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti {
    return [self addTimerDelegate:delegate timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:LJTHREADTIMERSTAT_VALID];
}

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat {
    return [self addTimerDelegate:delegate timeInterval:ti runloopMode:LJTIMERRUNLOOPMODETYPE_DEFAULT stat:stat];
}

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat {
    LJTimerTaskSource *source = [[LJTimerTaskSource alloc] initWithDelegate:delegate task:nil timeInterval:ti runLoopMode:loopMode stat:stat];
    unsigned long long source_id = [self _addSource:source withAdjust:YES];
    [self _addTimerControl];
    return source_id;
}

// drop
- (BOOL)dropTimer:(unsigned long long)timer_source_id {
    LJTimerTaskSource *source = [self _findSourceBySourceId:timer_source_id];
    if (!source) return false;
    return [self dropTimerSource:source];
}

- (BOOL)dropTimerSource:(LJTimerTaskSource *)timer_source {
    if (!timer_source) return false;
    int ret = true;
    @try {
        @synchronized (self.sources) {
            [timer_source invalidate];
            [self.sources removeObject:timer_source];
            timer_source = nil;
        }
    } @catch (NSException *exception) {
        NSLog(@"%s -- [%d]%@", __FUNCTION__, __LINE__, exception);
        ret = false;
    } @finally {
        return ret;
    }
}

// suspend
- (BOOL)suspendTimer:(unsigned long long)timer_source_id {
    LJTimerTaskSource *source = [self _findSourceBySourceId:timer_source_id];
    if (!source) return false;
    return [self suspendTimerSource:source];
}

- (BOOL)suspendTimerSource:(LJTimerTaskSource *)timer_source {
    if (!timer_source) return false;
    int ret = true;
    @try {
        @synchronized (self.sources) {
            if (timer_source.timer_stat == LJTHREADTIMERSTAT_VALID) {
                [timer_source timer_suspend];
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s -- [%d]%@", __FUNCTION__, __LINE__, exception);
        ret = false;
    } @finally {
        return ret;
    }
}

// active
- (BOOL)isActive:(unsigned long long)timer_source_id {
    LJTimerTaskSource *source = [self _findSourceBySourceId:timer_source_id];
    if (!source) return false;
    return source.timer_stat == LJTHREADTIMERSTAT_VALID;
}

- (BOOL)activeTimer:(unsigned long long)timer_source_id {
    LJTimerTaskSource *source = [self _findSourceBySourceId:timer_source_id];
    if (!source) return false;
    return [self activeTimerSource:source];
}

- (BOOL)activeTimerSource:(LJTimerTaskSource *)timer_source {
    if (!timer_source) return false;
    int ret = true;
    @try {
        @synchronized (self.sources) {
            if (timer_source.timer_stat == LJTHREADTIMERSTAT_CANCEL) {
                ret = false;
            } else {
                if (timer_source.timer_stat == LJTHREADTIMERSTAT_SUSPEND) {
                    [timer_source timer_active];
                }
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%s -- [%d]%@", __FUNCTION__, __LINE__, exception);
        ret = false;
    } @finally {
        return ret;
    }
}

#pragma mark - Private Method
/**
 添加定时器数据

 @param source 定时器数据
 @param adjust 是否需要调剂ID
 @return 定时器Obj ID
 */
- (unsigned long long)_addSource:(nonnull LJTimerTaskSource *)source withAdjust:(BOOL)adjust {
    if (adjust) {
        source.source_id += (_source_id_adjust++);
        source.source_id_adjust = true;
    }
    @synchronized (self.sources) {
        [self.sources addObject:source];
        return source.source_id;
    }
}

/**
 添加定时器
 */
- (void)_addTimerControl {
    @synchronized (self.sources) {
        for (LJTimerTaskSource *obj in self.sources.allObjects) {
            if (!obj.emb_in && obj.timer_stat != LJTHREADTIMERSTAT_CANCEL) {
                obj.timer = [NSTimer timerWithTimeInterval:obj.ti target:self selector:@selector(timerFunction:) userInfo:obj repeats:YES];
                if (obj.timer_stat == LJTHREADTIMERSTAT_SUSPEND) {
                    [obj.timer setFireDate:[NSDate distantFuture]];
                } else {
                    [obj.timer setFireDate:[NSDate date]];
                }
                [NSRunLoop.currentRunLoop addTimer:obj.timer forMode:obj.runloopMode_t];
                obj.emb_in = true;
            }
        }
    }
}

- (LJTimerTaskSource *)_findSourceBySourceId:(unsigned long long)timer_source_id {
    for (LJTimerTaskSource *source in self.sources.allObjects) {
        if (source.source_id == timer_source_id) {
            return source;
        }
    }
    return nil;
}

#pragma mark - loop
- (void)main {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
    [self _addTimerControl];
    if (self.is_keepRunning && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
    }
    [runLoop run];
}

#pragma mark - task fire
- (void)timerFunction:(NSTimer *)timer {
    LJTimerTaskSource *source = (LJTimerTaskSource *)timer.userInfo;
    if ([source isKindOfClass:LJTimerTaskSource.class]) {
        switch (source.type) {
            case LJTHREADINITTYPE_TASK:
                if (source.task) {
                    source.task(source.latestObj, source.source_id);
                }
                break;
            case LJTHREADINITTYPE_DELEGATE:
                if (source.delegate && [source.delegate respondsToSelector:@selector(threadTimerTriggered:latestObj:)]) {
                    [source.delegate threadTimerTriggered:source.source_id latestObj:source.latestObj];
                }
                break;
            default:
                break;
        }
    } else {
        // TODO: 兼容处理
    }
}

#pragma timer options
- (void)restartAllTimer {
    if (!self.isExecuting) return;
    @synchronized (self.sources) {
        if (!_sources.count) return;
        for (LJTimerTaskSource *obj in self.sources) {
            if (obj.timer_stat == LJTHREADTIMERSTAT_CANCEL || obj.timer_stat == LJTHREADTIMERSTAT_VALID) continue;
            [obj timer_active];
        }
    }
}

- (void)suspendAllTimer {
    if (!self.isExecuting) return;
    @synchronized (self.sources) {
        if (!_sources.count) return;
        for (LJTimerTaskSource *obj in self.sources) {
            if (obj.timer_stat == LJTHREADTIMERSTAT_CANCEL || obj.timer_stat == LJTHREADTIMERSTAT_SUSPEND) continue;
            [obj timer_suspend];
        }
    }
}

- (void)cancelAllTimer {
    if (!self.isExecuting) return;
    @synchronized (self.sources) {
        if (!_sources.count) return;
        for (LJTimerTaskSource *obj in self.sources) {
            [obj invalidate];
        }
        [self.sources removeAllObjects];
    }
}

#pragma mark - override
- (void)cancel {
    @synchronized (self) {
        self.keepRunning = false;
        [self cancelAllTimer];
        CFRunLoopStop(CFRunLoopGetCurrent());
        [super cancel];
    }
}

- (void)start {
    @synchronized (self) {
        self.keepRunning = true;
        if (!self.isExecuting) {
            [super start];
        }
    }
}

#pragma mark - getter & setter
- (NSHashTable<LJTimerTaskSource *> *)sources {
    if (nil == _sources) {
        _sources = [NSHashTable hashTableWithOptions:NSHashTableStrongMemory];
    }
    return _sources;
}

@end
