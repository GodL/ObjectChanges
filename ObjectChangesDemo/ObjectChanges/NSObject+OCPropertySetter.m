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

+ (NSDictionary<NSString *,NSString *> *)oc_allSetterNames {
    NSMutableDictionary *names = objc_getAssociatedObject(self, _cmd);
    if (!names) {
        names = [NSMutableDictionary dictionary];
        unsigned int count = 0;
        objc_property_t *properties = class_copyPropertyList(self, &count);
        for (int i=0; i<count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
            NSString *setterName = [NSString stringWithFormat:@"set%@%@:",[[propertyName substringToIndex:1] uppercaseString],[propertyName substringFromIndex:1]];
            if (propertyName && setterName) names[setterName] = propertyName;
        }
        free(properties);
        objc_setAssociatedObject(names, _cmd, names, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return (NSDictionary *)names;
}

@end
