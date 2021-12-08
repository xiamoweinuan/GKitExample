//
//  DRTabBarItem.h
//  DRLive
//
//  Created by tg on 2020/9/10.
//  Copyright © 2020 DRLive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTabBarItem : UIView
/** 标题 */
@property (nonatomic, strong) UILabel *titleLbl;
/** 图片 */
@property (nonatomic, strong) UIImageView *imgView;
/** 选中的图片 */
@property (nonatomic, strong) UIImageView *selectedImgView;
/** 选中的图片 */
@property (nonatomic, strong) UIImageView *animateImgView;
/** 角标 */
@property (nonatomic, strong) UILabel *badgeLbl;
@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END
