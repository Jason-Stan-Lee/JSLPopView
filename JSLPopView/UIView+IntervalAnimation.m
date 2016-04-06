//
//  UIView+IntervalAnimation.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/29.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIView+IntervalAnimation.h"
#import <objc/runtime.h>

static char intervalAnimationOnlyAnimatedSelfKey;

@implementation UIView (IntervalAnimation)

- (void)setOnlyAnimatedSelf:(BOOL)onlyAnimatedSelf {
    objc_setAssociatedObject(self, &intervalAnimationOnlyAnimatedSelfKey, onlyAnimatedSelf ? @(YES) : nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)onlyAnimatedSelf {
    return [objc_getAssociatedObject(self, &intervalAnimationOnlyAnimatedSelfKey) boolValue];
}

- (NSArray *)needAnimatedViewsForShow:(BOOL)show context:(id)context {
    if (self.onlyAnimatedSelf) {
        return @[self];
    } else if ([self isKindOfClass:[UITableView class]]) {
        return [(UITableView *)self visibleCells];
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        return [[(UICollectionView *)self visibleCells] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSIndexPath *indexPath1 = [(UICollectionView *)self indexPathForCell:obj1];
            NSIndexPath *indexPath2 = [(UICollectionView *)self indexPathForCell:obj2];
            return (indexPath1.item + indexPath1.section) > (indexPath2.section + indexPath2.item) ? NSOrderedDescending : NSOrderedAscending;
        }];
    } else if (self.subviews.count == 0 || ![self isMemberOfClass:[UIView class]]) {
        return @[self];
    }
    
    return self.subviews;
}

- (NSArray *)needAnimatedViewsWithDirection:(MoveAnimtedDirection)moveAnimatedDirection forShow:(BOOL)show context:(id)context {
    return [self needAnimatedViewsForShow:show context:context];
}

@end
