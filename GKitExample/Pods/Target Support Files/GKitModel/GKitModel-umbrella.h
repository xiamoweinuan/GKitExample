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

#import "GDBMangerProtocol.h"
#import "GModel.h"
#import "GModelDBProtocol.h"
#import "GModelManger.h"
#import "GModelProtocol.h"
#import "YIIFMDB.h"
#import "YIIParameters.h"

FOUNDATION_EXPORT double GKitModelVersionNumber;
FOUNDATION_EXPORT const unsigned char GKitModelVersionString[];

