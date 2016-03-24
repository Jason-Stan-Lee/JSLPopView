//
//  JSLBurredBackgroundProtocol.h
//  PopAlertView
//
//  Created by Jason_Lee on 16/3/22.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AvailabilityInternal.h>

#ifndef __JSLBurredBackgroundProtocol_h
#define __JSLBurredBackgroundProtocol_h

typedef NS_ENUM(NSInteger, JSLBurredBackgroundType) {
    JSLBurredBackgroundTypeNone,    //  无
    JSLBurredBackgroundTypeStatic   //  静态
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0 //  低版本的编译器不会报错,但是运行在低版本的设备上,会崩溃, 用来debug的
    ,JSLBurredBackgroundTypeDynamic //  动态
#endif
};

typedef UIImage *(^JSLApplyBurredEffectBlock)(UIImage *image);

@protocol JSLBurredBackgroundProtocol

//  毛玻璃背景类型
@property (nonatomic) JSLBurredBackgroundType blurredBackgroundType;
//  添加毛玻璃效果的block,对于静态毛玻璃效果有效
@property (nonatomic, copy) JSLApplyBurredEffectBlock applyBlurredEffectBlock;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0

//  对于动态毛玻璃有效
@property (nonatomic) UIBlurEffectStyle blureEffectStyle;
//  毛玻璃透明度
@property (nonatomic) CGFloat blureEffectAlpha;

#endif

@end

#endif