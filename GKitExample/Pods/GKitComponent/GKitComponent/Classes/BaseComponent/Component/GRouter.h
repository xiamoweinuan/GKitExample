//
//  FiserMan.h
//  CCRouter
//
//  Created by Chonghua Yu on 2018/11/8.
//  Copyright © 2018 keruyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GModProtocol.h"
#import "GServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface GRouter : NSObject

@property (nonatomic,strong,readonly)UIViewController *appRootViewController;

+ (instancetype)shard;


/**查找service*/
- (id)findServiceWithName:(NSString *)serviceName;


- (void)applicationDidEnterBackground:(UIApplication *)application;

-(void)addMod:(id)modeObj;

/**查找mod*/
- (id)findModWithName:(NSString *)modeName;

-(void)pushCanvas:(NSString *)modeName;

-(void)pushCanvas:(NSString *)modeName withBlock:(void (^)(UIViewController* vc))block;

-(void)popCanvas;

-(void)popToCanvas:(NSString *)modeName withComplete:(void(^)(UIViewController* vc))comPlete;

-(void)presentCanvas:(NSString *)modeName wihtCompletion: (void (^)(void))completion;
-(void)dismissCanvas:(NSString *)modeName wihtCompletion: (void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
