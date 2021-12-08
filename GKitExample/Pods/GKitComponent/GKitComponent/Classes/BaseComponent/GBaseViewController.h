//
//  DRBaseViewController.h
//  DRLive
//
//  Created by tg on 2020/9/11.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GModProtocol.h"
NS_ASSUME_NONNULL_BEGIN


@interface GBaseViewController : UIViewController<GModProtocol>
/**
 通用返回按钮 点击自动返回上一级
 */
-(void)setNavBackItemWithBlock:(void  (^)( void ))block;

@end

NS_ASSUME_NONNULL_END
