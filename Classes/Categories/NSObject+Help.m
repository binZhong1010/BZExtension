//
//  NSObject+RealClass.m
//  homework
//
//  Created by panxiang on 14-6-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "NSObject+Help.h"
#import <objc/runtime.h>


@implementation NSObject (RealClass)

- (BOOL)hasNilObject:(ConstIDCArray)objects count:(NSInteger)cnt
{
    return [self hasNilObject:objects count:cnt];
}

+ (BOOL)hasNilObject:(ConstIDCArray)objects count:(NSInteger)cnt
{
    if (objects) {
        BOOL hasNilObject = NO;
        for (int index = 0; index <= cnt - 1; index++) {
            if (!objects[index]) {
                hasNilObject = YES;
                break;
            }
        }
        return hasNilObject;
    }
    return YES;
}

+ (Class)realClass:(Class)className
{
    return NSClassFromString([NSString stringWithUTF8String:class_getName([[[className alloc] init] class])]);
}

+ (void)swizzledClass:(Class)aclass originalSelector:(SEL)originalSelector altSelector:(SEL)altSelector isClassMethod:(BOOL)isClassMethod
{
    Method originalMethod = nil;
    Method altMetthod = nil;
    
    if (isClassMethod)
    {
        originalMethod = class_getClassMethod(aclass, originalSelector);
        altMetthod = class_getClassMethod(self, altSelector);
    }
    else
    {
        originalMethod = class_getInstanceMethod(aclass, originalSelector);
        altMetthod = class_getInstanceMethod(self, altSelector);
    }
    
    if (originalMethod && altMetthod)
    {
        method_exchangeImplementations(originalMethod, altMetthod);
    }
}

@end
