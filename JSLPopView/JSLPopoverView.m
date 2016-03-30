//
//  JSLPopoverView.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLPopoverView.h"
#import "UIView+Screenshot.h"
#import "UIImage+ImageEffects.h"
#import "JSLConfigureMacro.h"

@interface JSLPopoverView ()

@property (nonatomic, strong) UIWindow *w_window;
@property (nonatomic, assign) CGRect keyboardFrame;

@property (nonatomic, readonly) BOOL isAnimating;
@property (nonatomic, strong, readonly) NSMutableArray *actionsArray;

@end

@implementation JSLPopoverView

@synthesize actionsArray = _actionsArray;

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithContentView:nil];
}

- (instancetype)initWithContentView:(UIView *)contentView {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        super.hidden            = YES;
        self.backgroundColor    = BlackColorWithAlpha(0.5f);
        _tapHiddenEnable        = YES;
        _contentViewAnchorPoint = CGPointMake(0.5f, 0.5f);
        _locationAnchorPoint    = CGPointMake(0.5f, 0.5f);
        self.contentView        = contentView;
        [self _registerKVO];
    }
    return self;
}

- (void)dealloc {
    [self _unregisterKVO];
}

#pragma mark - KVO

- (NSArray *)_observerKeyPaths {
    return @[@"contentViewAnchorPoint",
             @"locationAnchorPoint",
             @"contentViewSizeScale",
             @"adjustContntViewFrameWhenNoContain"];
}

- (void)_registerKVO {
    for (NSString *keyPath in [self _observerKeyPaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
}

- (void)_unregisterKVO {
    for (NSString *keyPath in [self _observerKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)_updateUIForKeyPath:(NSString *)keyPath {
    [self setNeedsLayout];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (self == object && ![change[@"old"] isEqual:change[@"new"]]) {
        
        //update UI
        if ([NSThread isMainThread]) {
            [self _updateUIForKeyPath:keyPath];
        } else {
            [self performSelector:@selector(_updateUIForKeyPath:) withObject:keyPath afterDelay:NO];
        }
    }
}

#pragma mark - contentView

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    
    if (_contentView) {
        [self addSubview:_contentView];
    }
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isShowing) {
        [self _updateContentViewFrame];
    }
}

- (void)_updateContentViewFrame {
    if (self.contentView) {
        
        CGFloat boundsWidth = CGRectGetWidth(self.bounds);
        CGFloat boundsHeight = CGRectGetHeight(self.bounds);
        CGSize contentViewSize = self.contentViewSize;
        
        if (!CGSizeEqualToSize(contentViewSize, CGSizeZero)) {
            
            if (!CGSizeEqualToSize(self.contentViewSizeScale, CGSizeZero)) {
                contentViewSize.width = boundsWidth * self.contentViewSizeScale.width;
                contentViewSize.height = boundsHeight * self.contentViewSizeScale.height;
            } else {
                contentViewSize = [self.contentView sizeThatFits:self.bounds.size];
            }
        }
        
        CGRect contentViewFrame = CGRectMake(boundsWidth * self.locationAnchorPoint.x - contentViewSize.width * self.contentViewAnchorPoint.x,
                                             boundsHeight * self.locationAnchorPoint.y - contentViewSize.height * self.contentViewAnchorPoint.y,
                                             contentViewSize.width, contentViewSize.height);
        
        //  不能完全显示调节
        if (self.adjustContentViewFrameWhenNoContain && !CGRectContainsRect(self.bounds, contentViewFrame)) {
            //  水平不能完全显示
            if (CGRectGetMinX(contentViewFrame) < 0 || CGRectGetMaxX(contentViewFrame) > boundsWidth) {
                if (CGRectGetMaxX(contentViewFrame) > boundsWidth) {
                    contentViewFrame.origin.x = boundsWidth - CGRectGetWidth(contentViewFrame);
                }
                
                if (CGRectGetMinX(contentViewFrame) < 0) {
                    contentViewFrame.origin.x = 0.f;
                }
                
                contentViewFrame.size.width = MIN(boundsWidth, CGRectGetWidth(contentViewFrame));
            }
            
            //  竖直不能完全显示
            if (CGRectGetMinY(contentViewFrame) < 0 || CGRectGetMaxY(contentViewFrame) > boundsHeight) {
                if (CGRectGetMaxY(contentViewFrame) > boundsHeight) {
                    contentViewFrame.origin.y = boundsHeight - CGRectGetHeight(contentViewFrame);
                }
                
                if (CGRectGetMinX(contentViewFrame) < 0) {
                    contentViewFrame.origin.y = 0.f;
                }
                
                contentViewFrame.size.height = MIN(boundsHeight, CGRectGetHeight(contentViewFrame));
            }
        }
        
        if ([self.contentView needObserverKeyBoardChangePosition] && !CGRectEqualToRect(self.keyboardFrame, CGRectZero)) {
            
            CGFloat offset = CGRectGetMaxY(contentViewFrame) - CGRectGetMinY(self.keyboardFrame);
            
            if (offset > 0) {
                contentViewFrame.origin.y -= offset;
            }
        }
        self.contentView.frame = contentViewFrame;
    }
}

#pragma mark - observer keyboard change

- (void)didMoveToWindow {
    [super didMoveToWindow];
    
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
}

- (void)_keyboardWillChangeFrameNotification:(NSNotification *)notification {
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.keyboardFrame = [self convertRect:self.keyboardFrame fromView:self.window];
    if (self.keyboardFrame.origin.y >= CGRectGetHeight(self.window.bounds)) {
        self.keyboardFrame = CGRectZero;
    }
    
    if ([self.contentView needObserverKeyBoardChangePosition]) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
        
        [self _updateContentViewFrame];
        [UIView commitAnimations];
    }
}

#pragma mark - show / hide

- (void)show:(BOOL)animated {
    [self showInView:nil animated:animated completedBlock:nil];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated completedBlock:(void (^)())complatedBlock {
    
    if (view && ![view isKindOfClass:[UIWindow class]] && !view.window) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"JSLPopoverview必须加入window" userInfo:nil];
    }
    
    //  正在显示则隐藏
    if (_isShowing) {
        [self hide:NO completedBlock:nil];
    }
    
    //  如果正在动画中则加入动作block, 等待动画完毕后执行
    if (self.isAnimating) {
        typeof(self) __weak weak_self = self;
        [self _addActionBlock:^{
            [weak_self hide:animated completedBlock:complatedBlock];
        }];
        return;
    }
    
    _isShowing = YES;
    
    // 更新毛玻璃效果
    UIWindow *basedWindow = [view isKindOfClass:[UIWindow class]]
    ? (UIWindow *)view : (view.window ?: [UIApplication sharedApplication].keyWindow);
    [self updateBlurredWithWindow:basedWindow];
    
    self.w_window = nil;
    if (!view) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        window.windowLevel = basedWindow.windowLevel + 1;
        [window makeKeyAndVisible];
        self.w_window = window;
        view = window;
    }
    
    //  设置frame和可见性
    super.hidden = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.frame = view.bounds;
    [view addSubview:self];
    
    //  更新内容的大小
    [self _updateContentViewFrame];
    
    //  开始显示回调
    [self.contentView startPopoverViewShow:YES animated:animated];
    
    if (animated) {
        void (^_complatedBlock)() = ^{
            [self.contentView endPopoverViewShow:YES animated:animated];
            if (complatedBlock) {
                complatedBlock();
            }
            
            _isAnimating = NO;
            [self _commitAction];
        };
        
        //  执行自定义动画
        if (![self.contentView
              customAnimationForPopoverView:self
              show:YES
              animationBlock:^{
            _isAnimating = YES;
        }
              completedBlock:_complatedBlock]) {
            //  无自定义动画则使用默认动画
            self.alpha = 0.f;
            [UIView animateWithDuration:0.5
                                  delay:0.0
                 usingSpringWithDamping:2.f
                  initialSpringVelocity:1.f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 _isAnimating = YES;
                                 self.alpha = 1.f;
                             }
                             completion:^(BOOL finished) {
                                 _complatedBlock();
                             }];
        }
    } else {
        [self.contentView endPopoverViewShow:YES animated:animated];
        if (complatedBlock) {
            complatedBlock();
        }
    }
}

- (void)hide:(BOOL)animated completedBlock:(void (^)())complatedBlock {
    
    if (_isShowing) {
        //  如果正在动画则加入动作block,等待动画完毕后执行
        if (self.isAnimating) {
            typeof(self) __weak weak_self = self;
            [self _addActionBlock:^{
                [weak_self hide:animated completedBlock:complatedBlock];
            }];
            return;
        }
        
        //  通知开始显示
        _isShowing = NO;
        [self.contentView startPopoverViewShow:NO animated:animated];
        
        //  完成block
        void(^_complateBlock)() = ^{
            [self removeFromSuperview];
            self.w_window.hidden = YES;
            self.w_window = nil;
            [self clearBlurred];
            [self.contentView endPopoverViewShow:NO animated:animated];
            super.hidden = YES;
            if (complatedBlock) {
                complatedBlock();
            }
        };
        
        if (animated) {
            void(^__complateBlock)() = ^{
                _complateBlock();
                _isAnimating = NO;
                [self _commitAction];
            };
            if (![self.contentView customAnimationForPopoverView:self
                                                            show:NO
                                                  animationBlock:^{
                                                      _isAnimating = YES;
                                                  }
                                                  completedBlock:__complateBlock]) {
                [UIView animateWithDuration:0.5f
                                      delay:0.0
                     usingSpringWithDamping:2.f
                      initialSpringVelocity:1.f
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{
                                     _isAnimating = YES;
                                     self.alpha = 0.f;
                                 } completion:^(BOOL finished) {
                                     __complateBlock();
                                 }];
            } else {
                _complateBlock();
            }
        }
    }
}

#pragma mark - touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.isTapHiddenEnabled) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        
        //  触摸了以外的区域
        if (!self.contentView || !CGRectContainsPoint(self.contentView.frame, point)) {
            BOOL bRet = YES;
            if (self.contentView) {
                bRet = [self.contentView popoverViewWillTapHiddenAtPoint:point];
            }
            
            if (bRet) {
                if ([self.delegate respondsToSelector:@selector(popoverViewWillTapHidden:)]) {
                    bRet = [self.delegate popoverViewWillTapHidden:self];
                }
                
                if (bRet) {
                    BOOL animated = YES;
                    if (self.contentView) {
                        animated = [self.contentView popoverViewTapHidenNeedAnimated];
                    }
                    
                    //  隐藏
                    [self hide:animated completedBlock:nil];
                    
                    //  发送消息
                    [self.contentView popoverViewDidTapHiden];
                    if ([self.delegate respondsToSelector:@selector(popoverViewDidTapHiden:)]) {
                        [self.delegate popoverViewDidTapHiden:self];
                    }
                }
            }
            
            if (!bRet) {
                [super touchesBegan:touches withEvent:event];
            }
        }
    }
}

#pragma mark - 

- (NSMutableArray *)actionsArray {
    if (!_actionsArray) {
        _actionsArray = [NSMutableArray array];
    }
    return _actionsArray;
}

- (void)_addActionBlock:(void(^)())block {
    [self.actionsArray addObject:[block copy]];
}

- (void)_commitAction {
    if (self.actionsArray.count) {
        void(^actionBlock)() = self.actionsArray.firstObject;
        [self.actionsArray removeObjectAtIndex:0];
        actionBlock();
    }
}

- (NSArray *)needAnimatedViewsForShow:(BOOL)show context:(id)context {
    return @[self.contentView];
}

@end

@implementation UIView (JSLPopoverView)

- (JSLPopoverView *)popoverView {
    if ([self isKindOfClass:[JSLPopoverView class]]) {
        return (JSLPopoverView *)self;
    } else {
        return [self.superview popoverView];
    }
}

- (BOOL)needObserverKeyBoardChangePosition {
    return NO;
}

- (BOOL)popoverViewWillTapHiddenAtPoint:(CGPoint)point {
    return YES;
}

- (BOOL)popoverViewTapHidenNeedAnimated {
    return YES;
}

- (void)popoverViewDidTapHiden {
    //  do nothing;
}

- (BOOL)customAnimationForPopoverView:(JSLPopoverView *)popoverView show:(BOOL)show animationBlock:(void (^)())animationBlock completedBlock:(void (^)())complatedBlock {
    return NO;
}

- (void)startPopoverViewShow:(BOOL)show animated:(BOOL)animated {
    //  do nothing
}

- (void)endPopoverViewShow:(BOOL)show animated:(BOOL)animated {
    //  do nothing
}

@end
