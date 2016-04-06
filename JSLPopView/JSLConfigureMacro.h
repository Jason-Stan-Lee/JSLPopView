//
//  JSLConfigureMacro.h
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#ifndef JSLConfigureMacro_h
#define JSLConfigureMacro_h

//  颜色创建
#define ColorWithRGBA(int_r,int_g,int_b,int_a)  \
[UIColor colorWithRed:(int_r)/255.0 green:(int_g)/255.0 blue:(int_b)/255.0 alpha:(int_a)/255.0]
#define ColorWithWhite(int_w,int_a) ColorWithRGBA(int_w,int_w,int_w,int_a)

//  通过数字初始化颜色
#define ColorWithNumberRGB(_hex)  \
ColorWithRGBA(((_hex)>>16)&0xFF,((_hex)>>8)&0xFF,(_hex)&0xFF,255)

#define ColorWithNumberRGBA(_hex) \
ColorWithRGBA(((_hex)>>24)&0xFF,((_hex)>>16)&0xFF,((_hex)>>8)&0xFF,(_hex)&0xFF)

//  指定透明度的黑色
#define BlackColorWithAlpha(_alpha) [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:_alpha]

//  移动方向
typedef NS_ENUM(NSInteger, MoveAnimtedDirection) {
    MoveAnimtedDirectionUp,
    MoveAnimtedDirectionDown,
    MoveAnimtedDirectionLeft,
    MoveAnimtedDirectionRight
};

#endif /* JSLConfigureMacro_h */
