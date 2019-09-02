//
//  NSObject+OCPropertySetter.m
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import "NSObject+OCPropertySetter.h"
#import <objc/runtime.h>

@implementation NSObject (OCPropertySetter)

- (NSArray<NSString *> *)oc_properties {
    NSMutableArray *properties = objc_getAssociatedObject(self, _cmd);
    if (!properties) {
        properties = NSMutableArray.array;
        unsigned int count = 0;
        objc_property_t *property_t = class_copyPropertyList([self class], &count);
        for (int i=0; i<count; i++) {
            objc_property_t property = property_t[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            if (propertyName) [properties addObject:propertyName];
        }
        free(property_t);
        objc_setAssociatedObject(self, _cmd, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [properties copy];
}

@end
