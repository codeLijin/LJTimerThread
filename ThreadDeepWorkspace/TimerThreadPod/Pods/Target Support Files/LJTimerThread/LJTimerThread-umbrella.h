#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LJTaskSourceInfo.h"
#import "LJTimerEnum.h"
#import "LJTimerProtocol.h"
#import "LJTimerTaskSource.h"
#import "LJTimerThread.h"

FOUNDATION_EXPORT double LJTimerThreadVersionNumber;
FOUNDATION_EXPORT const unsigned char LJTimerThreadVersionString[];

