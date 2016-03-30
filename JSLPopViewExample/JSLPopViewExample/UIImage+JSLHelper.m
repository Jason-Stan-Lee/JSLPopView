//
//  UIImage+JSLHelp.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "UIImage+JSLHelper.h"

@implementation UIImage (JSLHelper)

+ (UIImage *)jsl_bundleImageNamed:(NSString *)name {
    NSString *bundleImageName = [NSString stringWithFormat:@"Resource.bundle/%@",name];
    return [UIImage imageNamed:bundleImageName];
}

@end
