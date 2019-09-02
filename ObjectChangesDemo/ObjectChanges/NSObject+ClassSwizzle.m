//
//  NSObject+ClassSwizzle.m
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import "NSObject+ClassSwizzle.h"
#import "NSObject+ChangesAction.h"
#import "NSObject+OCPropertySetter.h"
#import "ChangeAction.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString * const OCForSelectorAliasPrefix = @"oc_alias_";
static NSString * const OCSubclassSuffix = @"_OCChangesSub";
static void *OCSubclassAssociationKey = &OCSubclassAssociationKey;

@implementation NSObject (ClassSwizzle)

static NSMutableSet *swizzleClasses(){
    static NSMutableSet *classes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        classes = [NSMutableSet set];
    });
    return classes;
}

static SEL OCAliasForSelector(SEL originalSelector) {
    return NSSelectorFromString([OCForSelectorAliasPrefix stringByAppendingString:NSStringFromSelector(originalSelector)]);
}

static BOOL OCForwardInvocation(NSObject *self,NSInvocation *invocation) {
    NSString *setterName = NSStringFromSelector(invocation.selector);
    SEL aliasSelector = OCAliasForSelector(invocation.selector);
    Class baseClass = object_getClass(self);
    BOOL responseToAlias = [baseClass instancesRespondToSelector:aliasSelector];
    if (responseToAlias) {
        invocation.selector = aliasSelector;
        [invocation invoke];
    }
    NSDictionary *properties = [[self class] oc_allSetterNames];
    NSString *propertyName = properties[setterName];
    if (propertyName == nil) return NO;
    NSMutableSet<ChangeAction *> *changeActions = self.oc_changeActions;
    [changeActions enumerateObjectsUsingBlock:^(ChangeAction * _Nonnull obj, BOOL * _Nonnull stop) {
        if (![obj.ingoreProperties containsObject:propertyName]) {
            obj.callback(obj,propertyName);
        }
    }];
    return YES;
}

static void OCSwizzleForwardInvocation(Class cls) {
    SEL sel = @selector(forwardInvocation:);
    Method method = class_getInstanceMethod(cls, sel);
    void (*originalForwardInvocation)(id,SEL,NSInvocation *) = NULL;
    
    if (method != NULL) {
        originalForwardInvocation = (__typeof__(originalForwardInvocation))method_getImplementation(method);
    }
    IMP newForwardInvocation = imp_implementationWithBlock(^(id self,NSInvocation *invocation) {
        BOOL matched = OCForwardInvocation(self, invocation);
        if (matched) return ;
        if (originalForwardInvocation == NULL) {
            [self doesNotRecognizeSelector:sel];
        }else {
            originalForwardInvocation(self,sel,invocation);
        }
    });
    class_replaceMethod(cls, sel, newForwardInvocation, method_getTypeEncoding(method));
}

static void OCSwizzleGetClass(Class base,Class stated) {
    SEL sel = @selector(class);
    Method method = class_getInstanceMethod(base, sel);
    IMP new = imp_implementationWithBlock(^ (id self) {
        return stated;
    });
    class_replaceMethod(base, sel, new, method_getTypeEncoding(method));
}

static Class OCSwizzleClass(NSObject *self) {
    Class baseClass = object_getClass(self);
    Class statedClass = self.class;
    Class dynamicSubClass = objc_getAssociatedObject(self, OCSubclassAssociationKey);
    if (dynamicSubClass) return dynamicSubClass;
    
    NSString *className = NSStringFromClass(baseClass);
    if (baseClass != statedClass) {
        @synchronized (swizzleClasses()) {
            if (![swizzleClasses() containsObject:className]) {
                OCSwizzleForwardInvocation(baseClass);
                OCSwizzleGetClass(baseClass,statedClass);
                [swizzleClasses() addObject:className];
            }
        }
        return baseClass;
    }
    
    const char *subClassName = [NSStringFromClass(baseClass) stringByAppendingString:OCSubclassSuffix].UTF8String;
    Class subClass = objc_getClass(subClassName);
    if (subClass == nil) {
        subClass = objc_allocateClassPair(baseClass, subClassName, 0);
        if (subClass == nil) return nil;
        OCSwizzleForwardInvocation(subClass);
        OCSwizzleGetClass(subClass,statedClass);
        objc_registerClassPair(subClass);
    }
    object_setClass(self, subClass);
    objc_setAssociatedObject(self, OCSubclassAssociationKey, subClass, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return subClass;
}

static void OCSelectorSwizzleToMsgForward(Class cls,SEL selector) {
    Method method = class_getInstanceMethod(cls, selector);
    if (method == NULL) {
        return;
    }else if (method_getImplementation(method) != _objc_msgForward) {
        const char *typeEncoding = method_getTypeEncoding(method);
        class_addMethod(cls, OCAliasForSelector(selector), method_getImplementation(method), typeEncoding);
        class_replaceMethod(cls, selector, _objc_msgForward, typeEncoding);
    }
}

- (void)oc_swizzleAllProperties {
    [self oc_swizzleWithProperties:[self.class oc_allSetterNames].allValues];
}

- (void)oc_swizzleWithProperties:(NSArray<NSString *> *)properties {
    Class baseClass = OCSwizzleClass(self);
    [properties enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *setterName = [NSString stringWithFormat:@"set%@%@:",[obj substringToIndex:1].uppercaseString,[obj substringFromIndex:1]];
        OCSelectorSwizzleToMsgForward(baseClass, sel_registerName(setterName.UTF8String));
    }];
}



@end
