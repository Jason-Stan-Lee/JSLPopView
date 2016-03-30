//
//  JSLBlurredFeatureController.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLBlurredFeatureController.h"
#import "JSLPopView.h"

@interface JSLBlurredFeatureController ()

@property (nonatomic, weak) UIImageView *backgroundView;

@end

@implementation JSLBlurredFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setUpChildViews];
}

- (void)_setUpChildViews {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage jsl_bundleImageNamed:@"blurred_background.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Blurred" style:UIBarButtonItemStylePlain target:self action:@selector(blurredAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)blurredAction:(UIButton *)sender {
    JSLBlurredView *blurredView = [[JSLBlurredView alloc] initWithFrame:self.view.bounds];
        blurredView.alpha = 0.5;
        blurredView.backgroundColor = [UIColor greenColor];
    blurredView.blureEffectStyle = UIBlurEffectStyleDark;
    blurredView.blurredBackgroundType = JSLBlurredBackgroundTypeStatic;
    blurredView.blureEffectAlpha = 0.7;
    blurredView.applyBlurredEffectBlock = ^(UIImage *image){
        return [image applyBlurWithRadius:56.2 tintColor:[UIColor clearColor] saturationDeltaFactor:34.3 maskImage:nil];
    };
    [blurredView updateBlurred];
    [self.view addSubview:blurredView];
}

@end
