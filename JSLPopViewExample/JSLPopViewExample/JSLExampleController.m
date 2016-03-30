//
//  JSLExampleController.m
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "JSLExampleController.h"
#import "JSLBlurredFeatureController.h"
#import "JSLPopoverFeatureController.h"

@implementation JSLExampleModel

+ (instancetype)exampleModeWithControllerName:(NSString *)controllerName title:(NSString *)title {
    
    JSLExampleModel *model = [[JSLExampleModel alloc] init];
    model.controllerName = controllerName;
    model.title = title;
    
    return model;
}

@end

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
    return self.features.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    JSLExampleModel *model = self.features[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JSLExampleModel *model = self.features[indexPath.row];
    id controller = [[NSClassFromString(model.controllerName) alloc] init];
    if ([controller isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

#pragma mark --

- (NSArray *)features {
    if (!_features) {
        _features = @[[JSLExampleModel exampleModeWithControllerName:@"JSLBlurredFeatureController" title:@"BlurredFeature"], [JSLExampleModel exampleModeWithControllerName:@"JSLPopoverFeatureController" title:@"PopoverFeaturer"]];
    }
    return _features;
}

@end
