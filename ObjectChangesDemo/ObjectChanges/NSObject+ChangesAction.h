//
//  NSObject+ChangesAction.h
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ChangeAction;

@interface NSObject (ChangesAction)

@property (nonatomic,strong,readonly) NSMutableSet<ChangeAction *> *oc_changeActions;

- (void)oc_addChangeAction:(ChangeAction *)action;

- (void)oc_removeChangeAction:(ChangeAction *)action;

@end

NS_ASSUME_NONNULL_END
