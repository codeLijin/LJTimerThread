//
//  FirstViewController.h
//  ThreadDemo
//
//  Created by lijin743 on 2019/9/21.
//  Copyright © 2019 lijin743. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LJTimerThread.h"
NS_ASSUME_NONNULL_BEGIN

@interface PushedViewController : UIViewController
@property (nonatomic, readwrite, strong) LJTimerThread *thread;
@end

NS_ASSUME_NONNULL_END
