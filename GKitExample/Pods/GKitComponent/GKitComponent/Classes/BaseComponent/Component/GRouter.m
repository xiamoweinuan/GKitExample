//
//  FiserMan.m
//  CCRouter
//
//  Created by Chonghua Yu on 2018/11/8.
//  Copyright © 2018 keruyun. All rights reserved.
//

#import "GRouter.h"
#import "GHeader.h"
#define   KEY_Delegate @"Delegate"
#define   KEY_Service @"Service"
@interface GRouter ()

@property (nonatomic,strong)UIViewController *appRootViewController;

@end

@implementation GRouter
{
    NSDictionary *_map;
    NSArray *_registerModules;
    NSArray *_registerServices;
    NSMutableDictionary *_runingModules;
    NSMutableDictionary *_runingServices;

}


+ (instancetype)shard
{
    static dispatch_once_t onceToken;
    static GRouter *man = nil;
    dispatch_once(&onceToken, ^{
        man = [[GRouter alloc] init];
    });
    return man;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _runingModules = @{}.mutableCopy;
        _runingServices = @{}.mutableCopy;
    }
    return self;
}
//将注册的第一个组件的根视图控制器作为app的根视图控制器
//- (UIViewController *)appRootViewController
//{
//
//    id<GModProtocol> module =[self findModWithname:FitstVC];
//    if (module) {
//        [module modInitWithBlock:nil];
//        [_runingModules addObject:module];
//        UIViewController *firstModVC = [module rootViewControllerForMod];
//        _rootVC = [[FSMNavigationController alloc] initWithRootViewController:firstModVC];
//    }
//
//    return _rootVC;
//}
-(void)addMod:(id)modeObj{
    [_runingModules setObject:modeObj forKey:NSStringFromClass([modeObj class])];

}

//查找mod
-(id)findModWithName:(NSString*)modeName{
    return  [self findWithName:modeName];
    
}
-(id)findWithName:(NSString *)modeName{
    
    
    if ([[_runingModules allKeys]containsObject:modeName]) {
        return _runingModules[modeName];
    }
 
    if (NSStringFromClass(NSClassFromString(modeName)).length==0) {
        NSLog(@"查找的组件未注册[%@]",modeName);
        return nil;
    }
 
    Class class = NSClassFromString(modeName);
    if (NSStringFromClass(class).length==0) {
        return nil;
    }
    id mod  = [[class alloc] init];
    
    if (![mod conformsToProtocol:@protocol(GModProtocol)]) {
        NSLog(@"代理[%@]必须遵守GModProtocol协议",modeName);
        return nil;
    }
    
    [_runingModules setObject:mod forKey:modeName];

    return mod;
  
}
//查找服务
- (id)findServiceWithName:(NSString *)serviceName
{
    return  [self findWithName:serviceName withQueryString:KEY_Service];
}
-(id)findWithName:(NSString *)serviceName withQueryString:(NSString*)string{
    
    
    if ([[_runingServices allKeys]containsObject:serviceName]) {
        return _runingServices[serviceName];
    }
 
    if (NSStringFromClass(NSClassFromString(serviceName)).length==0) {
        NSLog(@"查找的组件未注册[%@]",serviceName);
        return nil;
    }
    NSString* serviceImpName =[serviceName stringByAppendingString: string];

    Class class = NSClassFromString(serviceImpName);
    if (NSStringFromClass(class).length==0) {
        NSLog(@"查找的组件%@未注册[%@]",KEY_Service, serviceImpName);
        return nil;
    }
    id mod = nil;
    if ([string isEqualToString:KEY_Delegate]) {
        mod = [[class alloc] init];
        if (![mod conformsToProtocol:@protocol(GModProtocol)]) {
            NSLog(@"代理[%@]必须遵守GModProtocol协议",serviceImpName);
            return nil;
        }
    }else{
        mod = [[class alloc] init];
        if (![mod conformsToProtocol:@protocol(GServiceProtocol)]) {
            NSLog(@"服务[%@]必须遵守GModProtocol协议",serviceImpName);
            return nil;
        }
    }
    return  mod;
}
#pragma mark -Appdelegate
//将app事件分发到各个运行中的组件

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    for (id<GModProtocol> mod in _runingModules) {
        [mod modDidEnterBackground];
    }
}
-(void)removeModeWith:(NSString*)modeName{
    if ([[_runingModules allKeys]containsObject:modeName]) {
        [_runingModules removeObjectForKey:modeName];
    }
 
}

-(void)pushCanvas:(NSString *)modeName{
    UIViewController* vc = [self findModWithName:modeName];
    [_runingModules setObject:vc forKey:modeName];

    [kGetCurrentVC.navigationController pushViewController:vc animated:YES];
}

-(void)pushCanvas:(NSString *)modeName withBlock:(void (^)(UIViewController* vc))block{
    UIViewController* vc = [self findModWithName:modeName];
    if (block) {
        block(vc);
    }
    [_runingModules setObject:vc forKey:modeName];

    [kGetCurrentVC.navigationController pushViewController:vc animated:YES];
}

-(void)popCanvas{
    NSInteger vcCount = [kGetCurrentVC.navigationController.viewControllers count];

    if (vcCount >=2) {
        [_runingModules removeObjectForKey:[_runingModules allKeys].firstObject];

        [kGetCurrentVC.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(void)popToCanvas:(NSString *)modeName withComplete:(void(^)(UIViewController* vc))comPlete{
    if (modeName == nil) {
        [self popCanvas];
    }else{
        
        UIViewController* vc = [self findModWithName:modeName];
        
     

        for (UIViewController* canvasController in kGetCurrentVC.navigationController.viewControllers) {
            
            if (canvasController &&[canvasController isKindOfClass:[vc class]]) {
                
                if (comPlete) {
                    
                    comPlete(canvasController);
                }
                [_runingModules removeObjectForKey:modeName];
                [kGetCurrentVC.navigationController popToViewController:canvasController animated:YES];
                
                
                
            }
        }
        
    }
}
-(void)presentCanvas:(NSString *)modeName wihtCompletion: (void (^)(void))completion{
    UIViewController* vc = [self findModWithName:modeName];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [_runingModules setObject:vc forKey:modeName];
    [kGetCurrentVC presentViewController:vc animated:YES completion:completion];
}
-(void)dismissCanvas:(NSString *)modeName wihtCompletion: (void (^)(void))completion{
    UIViewController* vc = [self findModWithName:modeName];

    [_runingModules removeObjectForKey:modeName];
    [vc dismissViewControllerAnimated:YES completion:completion];

}
@end
