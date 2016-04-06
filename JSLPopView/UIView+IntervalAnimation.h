//
//  UIView+IntervalAnimation.h
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSLConfigureMacro.h"

@interface UIView (IntervalAnimation)

- (NSArray *)needAnimatedViewsForShow:(BOOL)show context:(id)context;
- (NSArray *)needAnimatedViewsWithDirection:(MoveAnimtedDirection)moveAnimatedDirection forShow:(BOOL)show context:(id)context;

@end
