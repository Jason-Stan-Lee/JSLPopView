//
//  UIView+Screenshot.m
//  PopAlertView
//
//  Created by Jason_Lee on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIView+Screenshot.h"

@implementation UIView (Screenshot)

- (UIImage *)convertViewToImage {
    return [self convertViewToImageWithRetina:YES];
}

- (UIImage *)convertViewToImageWithRetina:(BOOL)retina {
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, retina ? 0.f : 1.f);
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= IPHONE_7_0
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
#else
    [self.layer renderInContext:(UIGraphicsGetCurrentContext())];
#endif
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
