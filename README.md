# LJTimerThread
thread manager of timer
### LJTImerThread是一款基于`NSThread`管理`NSTimer`的管理类, 可以在项目中灵活的添加多个定时器完成功能需求
#### 一. LJTimerThread
    LJTimerThread类为管理类, 使用自定义构造函数进行初始化, 接下来将逐一进行介绍
###### 1: 初始化
    您可使用LJTImerThread的类构造灵活的构造管理器
* 使用delegate初始化定时器任务
    
            delegate: 初始化定时器监听事件代理对象, 代理函数可参考LJTimerProtocol.h
            ti: 定时器循环周期, 默认秒计时
            loopMode: 定时器在何种RunLoopMode中运行, 例如: 为了在滑动过程中不影响timer正常相应, 您可设置为LJTIMERRUNLOOPMODETYPE_TRACKING
            stat: 定时器创建时的运行状态, 为了更方便的操作任务, l可在定时器初始化阶段将timer的默认状态设置为VALID(运行)/SUSPEND(挂起)
            !!!初始化参数不要将stat设置为LJTHREADTIMERSTAT_CANCEL, 这将使定时器无法被管理, 不推荐手动管理该状态!!!
            callBack: 初始化函数回调将会返回当前创建TimerSource的唯一标示, 请谨慎保存, 这将是您后续操作定时任务的关键参数
```cpp
+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                       runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```
        delegate构造: 简化初始化方式
        具体参数同上, 当调用此函数时, NSTimer将会在NSDefaultRunLoopMode上运行
        !!!初始化参数不要将stat设置为LJTHREADTIMERSTAT_CANCEL, 这将使定时器无法被管理, 不推荐手动管理该状态!!!
        callBack: 初始化函数回调将会返回当前创建TimerSource的唯一标示, 请谨慎保存, 这将是您后续操作定时任务的关键参数
```cpp
+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                              stat:(LJTHREADTIMERSTAT)stat
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```
        delegate构造: 简化初始化方式
        具体参数同上, 当调用此函数时, NSTimer将会在NSDefaultRunLoopMode上运行, 默认开启定时器
        callBack: 初始化函数回调将会返回当前创建TimerSource的唯一标示, 请谨慎保存, 这将是您后续操作定时任务的关键参数
```cpp
+ (instancetype)threadWithDelegate:(nonnull id<LJThreadDelegate>)delegate
                      timeInterval:(NSTimeInterval)ti
                          callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```

* 使用block初始化定时器任务

        参数同delegate, 注意block中的引用问题
```cpp
+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                   runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```

```cpp
+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                          stat:(LJTHREADTIMERSTAT)stat
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```

```cpp
+ (instancetype)threadWithTask:(nonnull lj_timerThreadTask)task
                  timeInterval:(NSTimeInterval)ti
                      callBack:(nonnull lj_timerThreadGetSourceID)getSource_id;
```

* 使用TimerSource对象初始化定时器任务

        可以手动构造LJTimerTaskSource对象初始化管理器, 如果需要初始化一个无定时任务的管理器, 可使用该函数, 并将sourcez传nil
```cpp
+ (instancetype)threadWithSource:(nullable LJTimerTaskSource *)source callBack:(nullable lj_timerThreadGetSourceID)getSource_id;
```

<br>

###### 2: 添加定时任务
* 使用delegate初始化定时器任务

        返回添加的定时任务ID, 供给后续操作使用
```cpp
- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate
                          timeInterval:(NSTimeInterval)ti
                          runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                                 stat:(LJTHREADTIMERSTAT)stat;
```
    默认在NSDefaultRunLoopMode中执行
```cpp
- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat;
```
    NSDefaultRunLoopMode中默认执行
```cpp
- (unsigned long long)addTimerDelegate:(nonnull id<LJThreadDelegate>)delegate timeInterval:(NSTimeInterval)ti;
```

* 使用block初始化定时器任务

        同delegate
```cpp
- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task
                      timeInterval:(NSTimeInterval)ti
                       runloopMode:(LJTIMERRUNLOOPMODETYPE)loopMode
                              stat:(LJTHREADTIMERSTAT)stat;
```

```cpp
- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti stat:(LJTHREADTIMERSTAT)stat;
```

```cpp
- (unsigned long long)addTimerTask:(nonnull lj_timerThreadTask)task timeInterval:(NSTimeInterval)ti;
```


###### 3: 销毁定时任务(当生命周期结束[exp: dealloc], 调用销毁定时器方法, 防止发生内存问题)
* 通过TimerSourceID(即初始化或添加Timer时获取)关闭TimerSource, 此操作不可恢复
```
- (BOOL)dropTimer:(unsigned long long)timer_source_id;
```

        如果持有timerTaskSourceu对象, 可使用该函数进行管理回收, 此操作不可恢复
```
- (BOOL)dropTimerSource:(LJTimerTaskSource *)timer_source;
```

###### 4: 挂起定时任务
```cpp
- (BOOL)suspendTimer:(unsigned long long)timer_source_id;
```
```cpp
- (BOOL)suspendTimerSource:(LJTimerTaskSource *)timer_source;
```

###### 5: 激活定时任务
```
- (BOOL)activeTimer:(unsigned long long)timer_source_id;
- (BOOL)activeTimerSource:(LJTimerTaskSource *)timer_source;
```

###### 6: 定时任务是否执行
```
- (BOOL)isActive:(unsigned long long)timer_source_id;
```

###### 6: 定时任务批量操作
```cpp
// 启动所有在管理中的定时器
- (void)restartAllTimer;
// 挂起所有r定时器
- (void)suspendAllTimer;
// 清空所有定时器, 该操作不可逆
- (void)cancelAllTimer;
```

#### 二. LJTimerTaskSource
###### 1: 初始化

    原理与初始化一致, delegate与task只能传一个, 函数内部会保存调用方式, 如果都传的话 你可以试试🙃
    stat: 任务添加时的状态, 如果你暂时不想运行该定时器, 可以先设置为LJTHREADTIMERSTAT_SUSPEND挂起, 请不要触碰LJTHREADTIMERSTAT_CANCEL这个属性
```cpp
- (instancetype)initWithDelegate:(nullable id<LJThreadDelegate>)delegate
                            task:(nullable lj_timerThreadTask)task
                    timeInterval:(NSTimeInterval)ti
                     runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode
                            stat:(LJTHREADTIMERSTAT)stat;
```
        默认以激活状态添加
```cpp
- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti
             runLoopMode:(LJTIMERRUNLOOPMODETYPE)runLoopMode;
```

        默认在NSDefaultRunLoopMode中运行
```cpp
- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti
                    stat:(LJTHREADTIMERSTAT)stat;
```

        NSDefaultRunLoopMode&LJTHREADTIMERSTAT_VALID
```cpp
- (instancetype)delegate:(nullable id<LJThreadDelegate>)delegate
                    task:(nullable lj_timerThreadTask)task
            timeInterval:(NSTimeInterval)ti;
```

```cpp
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
```

```cpp
获取TimerSource在何种Mode状态运行
- (NSRunLoopMode)runloopMode_t;
```
