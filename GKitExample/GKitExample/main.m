//
//  main.m
//  GKitExample
//
//  Created by gaoshuang on 2021/12/2.
//

#import <UIKit/UIKit.h>
#import "GAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([GAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
