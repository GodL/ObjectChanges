//
//  ViewController.m
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import "ViewController.h"
#import "ChangeDemo.h"
#import "ObjectChanges.h"

@interface ViewController ()

@end

@implementation ViewController {
    ChangeDemo *_demo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _demo = [ChangeDemo new];
    
    [_demo oc_swizzleAllProperties];
    
    ChangeAction *action1 = [ChangeAction new];
    action1.callback = ^(ChangeAction * _Nonnull action, NSString * _Nonnull invokeProperty) {
        NSLog(@"action1 = %@ property = %@",action,invokeProperty);

    };
    action1.ingoreProperties = @[@"age"];
    
    ChangeAction *action2 = [ChangeAction new];
    action2.callback = ^(ChangeAction * _Nonnull action, NSString * _Nonnull invokeProperty) {
        NSLog(@"action2 = %@ property = %@",action,invokeProperty);
    };
    action2.ingoreProperties = @[@"name"];
    
    [_demo oc_addChangeAction:action1];
    [_demo oc_addChangeAction:action2];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _demo.name = @"adadad";
        _demo.age = 11;
    });
    // Do any additional setup after loading the view, typically from a nib.
}


@end
