//
//  NSObject+ClassSwizzle.h
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ClassSwizzle)

- (void)oc_swizzleAllProperties;

- (void)oc_swizzleWithProperties:(NSArray<NSString *> *)properties;

@end

NS_ASSUME_NONNULL_END
