//
//  LJTimerTaskSource.h
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LJTimerProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface LJTimerTaskSource : NSObject
/**
 定时器ID
 */
@property (nonatomic, readwrite, assign) unsigned long long source_id;

/**
 是否经过调剂
 */
@property (nonatomic, readwrite, assign) BOOL source_id_adjust;

/**
 是否已经入队
 */
@property (nonatomic, readwrite, assign) BOOL emb_in;

/**
 定时器构造类型
 */
@property (nonatomic, readonly, assign) LJTHREADINITTYPE type;

/**
 定时器状态
 */
@property (nonatomic, readwrite, assign) LJTHREADTIMERSTAT timer_stat;

/**
 delegate
 */
@property (nonatomic, readwrite, assign) id<LJThreadDelegate> __nullable delegate;

/**
 task
 */
@property (nonatomic, readwrite, copy) lj_timerThreadTask __nullable task;

/**
 执行周期
 */
@property (nonatomic, readwrite, assign) NSTimeInterval ti;

/**
 定时器
 */
@property (nonatomic, readwrite, strong) NSTimer *__nullable timer;

/**
 RunLoopMode
 */
@property (nonatomic, readwrite, assign) LJTIMERRUNLOOPMODETYPE runLoopMode;

/**
 最近一次保留的数据, 该值较难检测准确性, 不推荐使用
 */
@property (nonatomic, readwrite, strong) LJTaskSourceInfo *__nullable latestObj;

#pragma mark - structure
- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti;

- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti
                    stat:(LJTHREADTIMERSTAT)stat;

- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti
             runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode;

- (instancetype)initWithDelegate:(nullable id<LJThreadDelegate>)delegate
                            task:(nullable lj_timerThreadTask)task
                    timeInterval:(NSTimeInterval)ti
                     runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode
                            stat:(LJTHREADTIMERSTAT)stat;

/**
 销毁定时器
 */
- (void)invalidate;

/**
 挂起定时器
 */
- (void)timer_suspend;

/**
 激活定时器
 */
- (void)timer_active;

#pragma mark - getter
- (NSRunLoopMode)runloopMode_t;

#pragma mark - unavailable
-(instancetype)init __attribute__((unavailable("use structure method")));
+ (instancetype)new __attribute__((unavailable("use structure method")));
@end

NS_ASSUME_NONNULL_END
