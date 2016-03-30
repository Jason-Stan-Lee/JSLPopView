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
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    contentView.backgroundColor = [UIColor greenColor];
    UILabel *label = [[UILabel alloc] initWithFrame:contentView.bounds];
    label.text = @"contentView";
    [contentView addSubview:label];
    
    JSLPopoverView *popView = [[JSLPopoverView alloc] initWithContentView:contentView];
    popView.contentViewSize = CGSizeMake(100, 100);
    popView.adjustContentViewFrameWhenNoContain = YES;
    [popView show:YES];
}

@end
