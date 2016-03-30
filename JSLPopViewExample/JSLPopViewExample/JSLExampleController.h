//
//  JSLExampleController.h
//  JSLPopViewExample
//
//  Created by Jason_Lee on 16/3/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSLExampleModel : NSObject

@property (nonatomic, copy) NSString *controllerName;
@property (nonatomic, copy) NSString *title;

+ (instancetype)exampleModeWithControllerName:(NSString *)controllerName title:(NSString *)title;

@end

@interface JSLExampleController : UITableViewController


@end

