//
//  LJTimerEnum.h
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#ifndef LJTimerEnum_h
#define LJTimerEnum_h
#import "LJTaskSourceInfo.h"
/**
 定时器构造类型

 - LJTHREADINITTYPE_TASK: task
 - LJTHREADINITTYPE_DELEGATE: delegate
 */
typedef NS_ENUM(NSUInteger, LJTHREADINITTYPE) {
    LJTHREADINITTYPE_TASK,
    LJTHREADINITTYPE_DELEGATE,
};

/**
 定时器当前状态

 - LJTHREADTIMERSTAT_VALID: 运行
 - LJTHREADTIMERSTAT_SUSPEND: 挂起
 - LJTHREADTIMERSTAT_CANCEL: 取消
 */
typedef NS_ENUM(NSUInteger, LJTHREADTIMERSTAT) {
    LJTHREADTIMERSTAT_VALID,
    LJTHREADTIMERSTAT_SUSPEND,
    LJTHREADTIMERSTAT_CANCEL,
};

/**
 timer添加LoopMode

 - LJTIMERRUNLOOPTYPE_Commons: NSRunLoopCommonModes
 - LJTIMERRUNLOOPTYPE_Default: NSDefaultRunLoopMode
 - LJTIMERRUNLOOPTYPE_Tracking: UITrackingRunLoopMode
 */
typedef NS_ENUM(NSUInteger, LJTIMERRUNLOOPMODETYPE) {
    LJTIMERRUNLOOPMODETYPE_DEFAULT,
    LJTIMERRUNLOOPMODETYPE_COMMONS,
    LJTIMERRUNLOOPMODETYPE_TRACKING,
};

typedef void(^lj_timerThreadTask)(LJTaskSourceInfo *latestObj, unsigned long long timer_source_id);
typedef void(^lj_timerThreadGetSourceID)(unsigned long long source_id);
#endif /* LJTimerEnum_h */
