//
//  ChangeAction.h
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeAction : NSObject

@property (nonatomic,copy) void (^callback)(ChangeAction *action,NSString *invokeProperty);

@property (nonatomic,copy) NSArray<NSString *> *ingoreProperties;

@end

NS_ASSUME_NONNULL_END
