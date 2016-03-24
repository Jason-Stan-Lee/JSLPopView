//
//  JSLBlurredView.m
//  PopAlertView
//
//  Created by Jason_Lee on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLBlurredView.h"
#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"

//获取内容矩形，单位量，0~1
#define __ContentsRectForRect_IMP__(_contentRect,_rect,L) \
({ \
    CGRect __NSX_PASTE__(__rect,L) = _rect; \
    CGRect __NSX_PASTE__(__contentRect,L) = _contentRect; \
    CGFloat __NSX_PASTE__(__width,L) = CGRectGetWidth(__NSX_PASTE__(__rect,L));  \
    CGFloat __NSX_PASTE__(__height,L) = CGRectGetHeight(__NSX_PASTE__(__rect,L)); \
    CGRectMake(__NSX_PASTE__(__width,L)  ? CGRectGetMinX(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__width,L) : 0.f,    \
    __NSX_PASTE__(__height,L) ? CGRectGetMinY(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__height,L) : 0.f,   \
    __NSX_PASTE__(__width,L)  ? CGRectGetWidth(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__width,L) : 0.f,   \
    __NSX_PASTE__(__height,L) ? CGRectGetHeight(__NSX_PASTE__(__contentRect,L)) / __NSX_PASTE__(__height,L) : 0.f);\
})

#define ContentsRectForRect(_contentRect,_rect) __ContentsRectForRect_IMP__(_contentRect,_rect,__COUNTER__)

@interface JSLBlurredView ()

@property (nonatomic, strong) UIView *blurredEffectView;
@property (nonatomic, strong) UIColor *tmpBgColor;

//  是否显示l毛玻璃视图
@property (nonatomic, readonly) BOOL hadShowBlurredView;

@end

@implementation JSLBlurredView 

@synthesize blurredBackgroundType = _blurredBackgroundType;
@synthesize applyBlurredEffectBlock = _applyBlurredEffectBlock;

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
@synthesize blureEffectAlpha = _blureEffectAlpha;
@synthesize blureEffectStyle = _blureEffectStyle;
#endif

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _setUpBlurredView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _setUpBlurredView];
    }
    return self;
}

- (void)_setUpBlurredView {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    self.blureEffectAlpha = 1.0f;
#endif
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (self.hadShowBlurredView) {
        self.tmpBgColor = backgroundColor;
    } else {
        super.backgroundColor = backgroundColor;    // warning : super
    }
}

#pragma mark --

- (void)_updateBlurredEffectViewFrame {
    if (_blurredEffectView) {
        _blurredEffectView.frame = self.bounds;
        
        //如果是静态毛病玻璃效果,就设置其内容范围
        if ([_blurredEffectView isMemberOfClass:[UIView class]] && self.window) {
            CGRect rect = [self convertRect:self.bounds toView:self.window];
            _blurredEffectView.layer.contentsRect = ContentsRectForRect(rect, self.window.bounds);
        }
    }
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
    if (self.window) {
        [self _updateBlurredEffectViewFrame];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self _updateBlurredEffectViewFrame];
}

#pragma mark --

- (BOOL)hadShowBlurredView {
    return _blurredEffectView != nil;
}

- (void)updateBlurred {
    [self updateBlurredWithWindow:nil];
}

- (void)updateBlurredWithWindow:(UIWindow *)window {
    [self clearBlurred];    //  清除毛玻璃效果
    
    window = window?:self.window;
    
    //  获取应该显示的毛玻璃类型
    JSLBurredBackgroundType currentBlurredBackgroundType = JSLBurredBackgroundTypeNone;
    if (self.blurredBackgroundType == JSLBurredBackgroundTypeStatic) {
        if (window) {
            currentBlurredBackgroundType = JSLBurredBackgroundTypeStatic;
        } else {
            NSLog(@"%@当前没有参照window或添加到window中,无法添加静态毛玻璃效果,已取消显示",NSStringFromClass([self class]));
        }
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    else if (self.blurredBackgroundType == JSLBurredBackgroundTypeDynamic) {
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.f) {
            currentBlurredBackgroundType = JSLBurredBackgroundTypeDynamic;
        } else {
            NSLog(@"IOS 8 一下的版本不支持动态毛玻璃效果效果, 以转为静态毛玻璃效果");
            if (window) {
                currentBlurredBackgroundType = JSLBurredBackgroundTypeStatic;
            } else {
                NSLog(@"%@当前没有参照window或添加到window,无法添加静态毛玻璃效果,已取消",NSStringFromClass([self class]));
            }
        }
        
    }
#endif
    
    //  设置毛玻璃效果
    if (currentBlurredBackgroundType == JSLBurredBackgroundTypeStatic) {
        //  截屏
        UIImage *blurredImage = [window convertViewToImageWithRetina:NO];
        if (self.applyBlurredEffectBlock) {
            blurredImage = self.applyBlurredEffectBlock(blurredImage);
        } else {
            blurredImage = [blurredImage applyDarkEffect];
        }
        _blurredEffectView = [[UIView alloc] initWithFrame:self.bounds];
        _blurredEffectView.clipsToBounds = YES;
        _blurredEffectView.layer.contents = (id)blurredImage.CGImage;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    else if (currentBlurredBackgroundType == JSLBurredBackgroundTypeDynamic) {
        UIVisualEffectView *blurredEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:self.blureEffectStyle]];
        _blurredEffectView = blurredEffectView;
        _blurredEffectView.alpha = self.blureEffectAlpha;
    }
#endif
    
    if (_blurredEffectView) {
        //  记录背景并清空背景
        self.tmpBgColor = self.backgroundColor;
        super.backgroundColor = [UIColor clearColor];
        
        //插入毛玻璃效果
        [self insertSubview:_blurredEffectView atIndex:0];
        [self setNeedsLayout];
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_8_0

- (UIView *)blurredContentView {
    if ([_blurredEffectView isKindOfClass:[UIVisualEffectView class]]) {
        return [(UIVisualEffectView *)_blurredEffectView contentView];
    }
    return nil;
}

#endif

- (void)clearBlurred {
    if (self.hadShowBlurredView) {
        //移除毛玻璃视图
        [_blurredEffectView removeFromSuperview];
        _blurredEffectView = nil;
        
        //恢复原来的颜色
        super.backgroundColor = self.tmpBgColor;
    }
}

@end
