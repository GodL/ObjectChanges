//
//  ChangeDemo.h
//  ObjectChangesDemo
//
//  Created by 李浩 on 2019/9/1.
//  Copyright © 2019年 GodL. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangeDemo : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic,assign) NSInteger age;

@property (nonatomic,copy,readonly) NSString *gender;

@end

NS_ASSUME_NONNULL_END
