//
//  BATTabBarButton.h
//  NormalProject
//
//  Created by lf on 16/10/10.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, BATTabBarBtnBadgeType) {
    BATTabBarBtnBadgeTypeNone = -1,
    BATTabBarBtnBadgeTypeNumber = 0,
    BATTabBarBtnBadgeTypePoint,
    BATTabBarBtnBadgeTypeDefault = BATTabBarBtnBadgeTypeNumber,
};
@interface BATTabBarButton : UIButton
- (id)initWithTitle:(NSString *)title
      selectedTitle:(NSString *)sTitle
              image:(UIImage  *)image
      selectedImage:(UIImage  *)sImage;

/** 所在tabBar上的index */
@property (nonatomic, assign) NSInteger itemIndex;
/** 右上角的数字 */
@property (nonatomic, copy)   NSString *badgeValue;
/** badge显示类型 默认number */
@property (nonatomic, assign) BATTabBarBtnBadgeType badgeType;
@end
