//
//  JSLExampleController.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLExampleController.h"

NSString *const cellId = @"cell";

@interface JSLExampleController ()

@property (nonatomic, strong) NSArray *features;

@end

@implementation JSLExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

#pragma mark - TableviewDelegate, DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _features.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id controller = [[NSClassFromString(self.features[indexPath.row]) alloc] init];
    if ([controller isKindOfClass:controller]) {
        
    }
    
}

#pragma mark --

- (NSArray *)features {
    if (!_features) {
        _features = @[@"JSLBlurredFeatureController"];
    }
    return _features;
}

@end
