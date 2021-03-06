//
//  NSObject+swizzle.h
//  OneStore
//
//  Created by Aimy on 14-1-2.
//  Copyright (c) 2014年 OneStore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (swizzle)

+ (BOOL)overrideMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)overrideClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;
+ (BOOL)swizzingMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)swizzingClassMethod:(SEL)origSel withClassMethod:(SEL)altSel;

@end
