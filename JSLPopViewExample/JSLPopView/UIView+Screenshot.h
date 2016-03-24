//
//  UIView+Screenshot.h
//  PopAlertView
//
//  Created by Jason_Lee on 16/3/23.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

- (UIImage *)convertViewToImage;

- (UIImage *)convertViewToImageWithRetina:(BOOL)retina;

@end
