//
//  JSLPopoverFeatureController.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/30.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLPopoverFeatureController.h"

@implementation JSLPopoverFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _setUpChildViews];
}

- (void)_setUpChildViews {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage jsl_bundleImageNamed:@"blurred_background.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Popover" style:UIBarButtonItemStylePlain target:self action:@selector(popView:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)popView:(id)sender {
    
    UIImageView *contentView = [[UIImageView alloc] initWithImage:[UIImage jsl_bundleImageNamed:@"content.jpg"]];
    JSLPopoverView *popView = [[JSLPopoverView alloc] initWithContentView:contentView];
    popView.contentViewSize = CGSizeMake(150, 300);
    popView.adjustContentViewFrameWhenNoContain = YES;
    [popView show:YES];
}

@end
