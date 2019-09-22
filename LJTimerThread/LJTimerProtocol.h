//
//  LJTimerProtocol.h
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#ifndef LJTimerProtocol_h
#define LJTimerProtocol_h
#import "LJTimerEnum.h"
@protocol LJThreadDelegate <NSObject>
@required

/**
 触发定时器回调

 @param timer_source_id 定时器ID
 @param latestObj 最近一次定时器保存的数据
 */
-(void)threadTimerTriggered:(unsigned long long)timer_source_id latestObj:(LJTaskSourceInfo *)latestObj;

@end

#endif /* LJTimerProtocol_h */
