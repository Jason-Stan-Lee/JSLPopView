//
//  JSLPopoverView.h
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/25.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLBlurredView.h"

@class JSLPopoverView;
@protocol  JSLPopoverViewDelegate <NSObject>

@optional
//  将要点击隐藏, 返回yes确定, 返回no取消
- (BOOL)popoverViewWillTapHidden:(JSLPopoverView *)popoverView;
- (void)popoverViewDidTapHiden:(JSLPopoverView *)popoverView;

@end

@interface JSLPopoverView : JSLBlurredView

//  内容视图
@property (nonatomic, strong) UIView *contentView;
//  内容视图的锚点,默认是(0.5, 0.5) 中心
@property (nonatomic, assign) CGPoint contentViewAnchorPoint;
//  定位的锚点,默认是(0.5, 0.5) 中心
@property (nonatomic, assign) CGPoint locationAnchorPoint;

//  一下两个属性决定内容视图的大小,优先级为contentViewSize > congtentViewSizeScale

//  如果两者都为CGSizeZero, 会调用视图的sizeThatFits方法获取大小

//  内容视图的大小,默认是CGSizeZero
@property (nonatomic, assign) CGSize contentViewSize;
@property (nonatomic, assign) CGSize contentViewSizeScale;

//  是否当视图不能完全显示的时候调节内容视图的frame, 默认为NO
@property (nonatomic, assign) BOOL adjustContentViewFrameWhenNoContain;
//  是否在显示
@property (nonatomic, readonly, getter=isShowing) BOOL isShowing;

//  是否允许点击内容视图的外围隐藏区域, 默认为YES
@property (nonatomic, getter=isTapHiddenEnabled) BOOL tapHiddenEnable;
@property (nonatomic, weak) id <JSLPopoverViewDelegate> delegate;

- (instancetype)initWithContentView:(UIView *)contentView;

- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view animated:(BOOL)animated completedBlock:(void(^)())complatedBlock;
- (void)hide:(BOOL)animated completedBlock:(void(^)())complatedBlock;

@end

@interface UIView (JSLPopoverView)

@property (nonatomic, strong, readonly) JSLPopoverView *popoverView;

//  是否需要观察键盘改变位置, 避免遮挡, 默认为No
- (BOOL)needObserverKeyBoardChangePosition;

//  以下方法由popoverView调用
- (BOOL)popoverViewWillTapHiddenAtPoint:(CGPoint)point;
- (BOOL)popoverViewTapHidenNeedAnimated;
- (void)popoverViewDidTapHiden;

//  自定义动画, 没有实现返回NO来实现自定义动画
- (BOOL)customAnimationForPopoverView:(JSLPopoverView *)popoverView
                                 show:(BOOL)show
                       animationBlock:(void(^)())animationBlock
                       completedBlock:(void(^)())complatedBlock;
//  开始显示时调用
- (void)startPopoverViewShow:(BOOL)show animated:(BOOL)animated;
//  结束显示时调用
- (void)endPopoverViewShow:(BOOL)show animated:(BOOL)animated;

@end
