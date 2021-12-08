//
//  _KJINLINE.h
//  KJEmitterView
//
//  Created by 杨科军 on 2019/10/10.
//  Copyright © 2019 杨科军. All rights reserved.
//

#ifndef _KJINLINE_h
#define _KJINLINE_h

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/message.h>

/** 这里只适合放简单的函数 */
NS_ASSUME_NONNULL_BEGIN

#pragma clang diagnostic push


#pragma clang diagnostic ignored "-Wdeprecated-declarations"

NS_INLINE UIImage* kImageName(NSString*str){
    return [UIImage imageNamed:str];
}
NS_INLINE UIImage* kImageFile(NSString* str){
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:str ofType:nil]];

}
NS_INLINE NSURL* kUrl(NSString* str){
    return [NSURL URLWithString:str];
}
NS_INLINE BOOL kISEmpty(NSObject *obj){
    
    if (obj==nil) {
        return YES;
    }
    if (obj==NULL) {
        return YES;
    }
    if (obj==[NSNull new]) {
        return YES;
    }
    if ([obj isKindOfClass:[NSString class]]) {
        if ([(NSString*)obj length]==0 ) {
            return YES;
        }
        if ([[(NSString*)obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            return YES;
        }
        if([(NSString*)obj isEqualToString:@"(null)"]){
            return YES;
        }
        if ([(NSString*)obj isEqualToString:@"nullnull"]) {
            return YES;
        }
        NSString* objString = (NSString*)obj;
        
        if ([objString respondsToSelector:@selector(length)]) {
            return  objString.length <=0;
        }
    }
    if ([obj isKindOfClass:[NSData class]]) {
        return [((NSData *)obj) length]<=0;
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)obj) count]<=0;
    }
    if ([obj isKindOfClass:[NSArray class]]) {
        return [((NSArray *)obj) count]<=0;
    }
    if ([obj isKindOfClass:[NSSet class]]) {
        return [((NSSet *)obj) count]<=0;
    }
    return NO;
}
NS_INLINE NSString* kStringSafe(NSObject* obj){
    if (!kISEmpty(obj)) {
        if ([(NSString*)obj isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@", obj];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
           return [formatter stringFromNumber:(NSNumber*)obj];
        }
    }
    return @"";
    
}
NS_INLINE UIViewController* kGetCurrentVCFrom(UIViewController *rootVC){
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC =kGetCurrentVCFrom([(UITabBarController *)rootVC selectedViewController]);
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC =kGetCurrentVCFrom([(UINavigationController *)rootVC visibleViewController])
        ;
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

/** 自定提醒窗口 */
NS_INLINE UIAlertView * kAlertView(NSString *title, NSString *message, id delegate, NSString *cancelTitle, NSString *otherTitle){
    __block UIAlertView *alerView;
    dispatch_async(dispatch_get_main_queue(), ^{
        alerView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
        [alerView show];
    });
    return alerView;
}

/** 自定提醒窗口，自动消失 */
NS_INLINE void kAlertViewAutoDismiss(NSString *message, CGFloat delay){
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alerView show];
        [alerView performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@0, @1] afterDelay:delay];
    });
}

/** 校正ScrollView在iOS11上的偏移问题 */
NS_INLINE void kAdjustsScrollViewInsetNever(UIViewController *viewController, __kindof UIScrollView *tableView) {
#if __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        viewController.automaticallyAdjustsScrollViewInsets = false;
    }
#else
    viewController.automaticallyAdjustsScrollViewInsets = false;
#endif
}

// 字符串转换为非空
NS_INLINE NSString * kStringChangeNotNil(NSString *string){
    return (string ?: @"");
}

/// 随机颜色
NS_INLINE UIColor * kRandomColor(){
    return [UIColor colorWithRed:((float)arc4random_uniform(256)/255.0) green:((float)arc4random_uniform(256)/255.0) blue:((float)arc4random_uniform(256)/255.0) alpha:1.0];
}

/// 随机颜色

NS_INLINE UIColor* kColorStringHexA(NSString*color,float a){
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:a];
}
NS_INLINE UIColor* kColorStringHex(NSString*color){
    return kColorStringHexA(color, 1);
}
NS_INLINE UIColor* kColorHex(long long int hex){
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 \
    green:((float)((hex & 0xFF00) >> 8)) / 255.0 \
                             blue:((float)(hex & 0xFF)) / 255.0 alpha:1.0];
}

NS_INLINE UIColor* kColorRGB(NSInteger r,NSInteger g,NSInteger b){
    return [UIColor colorWithRed:(r) / 255.0  \
                           green:(g) / 255.0  \
                           blue:(b) / 255.0  \
                           alpha:1];
}
NS_INLINE UIColor* kColorRGBA(NSInteger r,NSInteger g,NSInteger b,float a){
    return [UIColor colorWithRed:(r) / 255.0  \
    green:(g) / 255.0  \
    blue:(b) / 255.0  \
                           alpha:(a)];
}


/** 系统加载动效 */
NS_INLINE void kNetworkActivityIndicatorVisible(BOOL visible) {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}

/** 通过xib名称加载cell */
NS_INLINE id kLoadNibWithName(NSString *name, id owner){
   return [[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil].firstObject;
}

// 加载xib
NS_INLINE id kLoadNib(NSString *nibName){
    return [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
}

/* 根据当前view 找所在tableview 里的 indexpath */
NS_INLINE NSIndexPath * kIndexpathSubviewTableview(UIView *subview, UITableView *tableview){
    CGRect subviewFrame = [subview convertRect:subview.bounds toView:tableview];
    return [tableview indexPathForRowAtPoint:subviewFrame.origin];
}

/* 根据当前view 找所在collectionview 里的 indexpath */
NS_INLINE NSIndexPath * kIndexpathSubviewCollectionview(UIView *subview, UICollectionView *collectionview){
    CGRect subviewFrame = [subview convertRect:subview.bounds toView:collectionview];
    return [collectionview indexPathForItemAtPoint:subviewFrame.origin];
}

/* 根据当前view 找所在tableview 里的 tableviewcell */
NS_INLINE UITableViewCell * kCellSubviewTableview(UIView *subview, UITableView *tableview){
    CGRect subviewFrame = [subview convertRect:subview.bounds toView:tableview];
    NSIndexPath *indexPath = [tableview indexPathForRowAtPoint:subviewFrame.origin];
    return [tableview cellForRowAtIndexPath:indexPath];
}

/** 主线程do */
NS_INLINE void KJ_GCD_main(dispatch_block_t block) {
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), block);
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
/** 交换方法的实现 */
NS_INLINE void KJ_method_swizzling(Class clazz, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clazz, swizzledSelector);
    if (class_addMethod(clazz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(clazz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


#pragma clang diagnostic pop

NS_ASSUME_NONNULL_END
#endif

#endif /* _KJINLINE_h */
