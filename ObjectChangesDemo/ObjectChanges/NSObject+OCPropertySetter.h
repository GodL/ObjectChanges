//
//  NSObject+OCPropertySetter.h
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (OCPropertySetter)

@property (nonatomic,copy,readonly,class) NSDictionary<NSString *,NSString *> *oc_allSetterNames;

@end

NS_ASSUME_NONNULL_END
