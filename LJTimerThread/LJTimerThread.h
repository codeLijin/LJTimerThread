//
//  LiThread.h
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LJTimerTaskSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface LJTimerThread : NSThread

#pragma mark - structure
+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                       runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;

+ (instancetype)threadWithSource:(nullable LJTimerTaskSource *)source callBack:(nullable lj_timerThreadGetSourceID)getSource_id;

#pragma mark - insert
- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti;

- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat;

- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat;

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti;

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat;

- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate
                          timeInterval:(NSTimeInterval)ti
                           runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                                  stat:(LJTHREADTIMERSTAT)stat;

#pragma mark - drop
- (BOOL)dropTimer:(unsigned long long)timer_source_id;
- (BOOL)dropTimerSource:(LJTimerTaskSource *)timer_source;

#pragma mark - suspend
- (BOOL)suspendTimer:(unsigned long long)timer_source_id;
- (BOOL)suspendTimerSource:(LJTimerTaskSource *)timer_source;

#pragma mark - active
- (BOOL)isActive:(unsigned long long)timer_source_id;
- (BOOL)activeTimer:(unsigned long long)timer_source_id;
- (BOOL)activeTimerSource:(LJTimerTaskSource *)timer_source;

#pragma timer all options
- (void)restartAllTimer;
- (void)suspendAllTimer;
- (void)cancelAllTimer;

#pragma unavailable
-(instancetype)init __attribute__((unavailable("use instance method type class")));
- (instancetype)initWithTarget:(id)target selector:(SEL)selector object:(nullable id)argument __attribute__((unavailable("use instance method type class")));
- (instancetype)initWithBlock:(void (^)(void))block __attribute__((unavailable("use instance method type class")));
+ (instancetype)new __attribute__((unavailable("use instance method type class")));
+ (void)detachNewThreadSelector:(SEL)selector toTarget:(id)target withObject:(nullable id)argument __attribute__((unavailable("use instance method type class")));
+ (void)detachNewThreadWithBlock:(void (^)(void))block  __attribute__((unavailable("use instance method type class")));

@end

NS_ASSUME_NONNULL_END
