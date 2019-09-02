//
//  NSObject+ChangesAction.m
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import "NSObject+ChangesAction.h"
#import "NSObject+ClassSwizzle.h"
#import <objc/runtime.h>
@implementation NSObject (ChangesAction)

- (NSMutableSet<ChangeAction *> *)oc_changeActions {
    NSMutableSet<ChangeAction *> *actions = objc_getAssociatedObject(self, _cmd);
    if (!actions) {
        @synchronized (self) {
            if (actions) return actions;
            actions = [NSMutableSet set];
            objc_setAssociatedObject(self, _cmd, actions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    return actions;
}

- (void)oc_addChangeAction:(ChangeAction *)action{
    [self.oc_changeActions addObject:action];
}

- (void)oc_removeChangeAction:(ChangeAction *)action {
    [self.oc_changeActions removeObject:action];
}

@end
