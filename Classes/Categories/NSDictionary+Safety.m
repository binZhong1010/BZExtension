//
//  NSDictionary+Safety.m
//  homework
//
//  Created by panxiang on 14-6-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "NSDictionary+Safety.h"
#import <objc/runtime.h>
#import "NSObject+Help.h"
#import "NBSafetyCommon.h"

@implementation NSDictionary (Safety)

- (void)printNotValidKeyError:(const char *)fuction
{
    [[self class] printNotValidKeyError:fuction];
}

+ (void)printNotValidKeyError:(const char *)fuction
{
    NSLog(@"%s \n key is not confirm NSCopying protocol \n Dictionary:%@",fuction ,self);
}

- (void)printNilKeyError:(const char *)fuction
{
    [[self class] printNilKeyError:fuction];
}

- (void)printNilObjectError:(const char *)fuction
{
    [[self class] printNilObjectError:fuction];
}

+ (void)printNilObjectError:(const char *)fuction
{
    NSLog(@"%s \n object is nil \n Dictionary:%@",fuction ,self);
}

+ (void)printNilKeyError:(const char *)fuction
{
    NSLog(@"%s \n key is nil \n Dictionary:%@",fuction ,self);
}

- (id)valueForKeySafely:(id)aKey
{
    if (!aKey) {
        [self printNilKeyError:__FUNCTION__];
        return nil;
    }
    return [self valueForKey:aKey];
}

- (void)setValue:(id)value forKeySafely:(NSString *)key
{
    if (!key) {
        [self printNilKeyError:__FUNCTION__];
    }
    return [self setValue:value forKey:key];
}


+ (id)sharedKeySetForKeysSafely:(NSArray *)keys
{
    if (!keys) {
        [self printNilKeyError:__FUNCTION__];
        return nil;
    }
    return [self sharedKeySetForKeys:keys];
}

- (id)objectForKeySafely:(id)aKey
{
    if (!aKey) {
        [self printNilKeyError:__FUNCTION__];
        return nil;
    }
    return [self objectForKey:aKey];
}

- (id)objectForKeyedSubscriptSafely:(id)key
{
    if (!key) {
        [self printNilKeyError:__FUNCTION__];
        return nil;
    }
    return [self objectForKeyedSubscript:key];
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarkerSafely:(id)marker
{
    if (!marker) {
        [self printNilObjectError:__FUNCTION__];
        return nil;
    }
    return [self objectsForKeys:keys notFoundMarker:marker];
}

+ (instancetype)dictionaryWithObject:(id)object forKeySafely:(id <NSCopying>)key
{
    if (!object) {
        [self printNilObjectError:__FUNCTION__];
        return [[self class] dictionary];
    }
    if (!key) {
        [self printNilKeyError:__FUNCTION__];
        return [[self class] dictionary];
    }
    return [self dictionaryWithObject:object forKey:key];
}


//
//+ (instancetype)swizzled_m_dictionaryWithObjects:(ConstIDCArray)objects forKeys:(const id [])keys count:(NSUInteger)cnt
//{
//    if (cnt == 0) {
//        return [[self class] dictionary];
//    }
//    
//    if (objects) {
//        if ([self hasNilObject:objects count:cnt]) {
//            [self printNilObjectError:__FUNCTION__];
//            return [[self class] dictionary];
//        }
//    }
//    
//    if (keys) {
//        if ([self hasNilObject:keys count:cnt]) {
//            [self printNilObjectError:__FUNCTION__];
//            return [[self class] dictionary];
//        }
//    }
//    
//    return [self swizzled_m_dictionaryWithObjects:objects forKeys:keys count:cnt];
//}
//
//+ (instancetype)swizzled_i_dictionaryWithObjects:(ConstIDCArray)objects forKeys:(const id [])keys count:(NSUInteger)cnt
//{
//    if (cnt == 0) {
//        return [[self class] dictionary];
//    }
//    
//    if (objects) {
//        if ([self hasNilObject:objects count:cnt]) {
//            [self printNilObjectError:__FUNCTION__];
//            return [[self class] dictionary];
//        }
//    }
//    
//    if (keys) {
//        if ([self hasNilObject:keys count:cnt]) {
//            [self printNilObjectError:__FUNCTION__];
//            return [[self class] dictionary];
//        }
//    }
//    
//    return [self swizzled_i_dictionaryWithObjects:objects forKeys:keys count:cnt];
//}

/*
 
- (instancetype)swizzled_i_initWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt
{
    if (cnt == 0) {
        return [[[self class] alloc] init];
    }
    
    if (objects) {
        if ([self hasNilObject:objects count:cnt]) {
            [self printNilObjectError:__FUNCTION__];
            return [[[self class] alloc] init];
        }
    }
    
    if (objects) {
        if ([self hasNilObject:keys count:cnt]) {
            [self printNilObjectError:__FUNCTION__];
            return [[[self class] alloc] init];
        }
    }
    
    return [self swizzled_i_initWithObjects:objects forKeys:keys count:cnt];
}

- (instancetype)swizzled_m_initWithObjects:(const id [])objects forKeys:(const id [])keys count:(NSUInteger)cnt
{
    if (cnt == 0) {
        return [[[self class] alloc] init];
    }
    
    if (objects) {
        if ([self hasNilObject:objects count:cnt]) {
            [self printNilObjectError:__FUNCTION__];
            return [[[self class] alloc] init];
        }
    }
    
    if (objects) {
        if ([self hasNilObject:keys count:cnt]) {
            [self printNilObjectError:__FUNCTION__];
            return [[[self class] alloc] init];
        }
    }
    
    return [self swizzled_m_initWithObjects:objects forKeys:keys count:cnt];
}

*/

@end


@implementation NSMutableDictionary (Safety)

//+ (instancetype)dictionaryWithObjectsAndKeysSafely:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
//{
//    if (!firstObject) return [NSMutableDictionary dictionary];
//    
//    NSMutableArray *keys = [NSMutableArray array];
//    NSMutableArray *values = [NSMutableArray array];
//    
//    
//	id obj = firstObject;
//    BOOL isKey = YES;
//	va_list objects;
//	va_start(objects, obj);
//	do
//	{
//        if (isKey)
//        {
//            [keys addObjectSafely:obj];
//        }
//        else
//        {
//            [values addObjectSafely:obj];
//        }
//		obj = va_arg(objects, id);
//        isKey = !isKey;
//	} while (obj);
//	va_end(objects);
//    
//    if (keys.count == values.count) {
//        return [NSMutableDictionary dictionaryWithObject:values forKey:keys];
//    }
//    return nil;
//}

- (void)removeObjectForKeySafely:(id)aKey
{

    
    if (!aKey)
    {
        [self printNilKeyError:__FUNCTION__];
        return;
    }
    [self removeObjectForKey:aKey];
}

- (void)setObject:(id)anObject forKeySafely:(id <NSCopying>)aKey
{
    if (!anObject) {
        [self printNilObjectError:__FUNCTION__];
        return;
    }
    
    if (!aKey) {
        [self printNilKeyError:__FUNCTION__];
        return;
    }
    
    [self setObject:anObject forKey:aKey];
}

- (void)setObject:(id)obj forKeyedSubscriptSafely:(id <NSCopying>)key
{
    if (!obj) {
        [self printNilObjectError:__FUNCTION__];
        return;
    }
    
    if (!key) {
        [self printNilKeyError:__FUNCTION__];
        return;
    }
    
    [self setObject:obj forKeyedSubscript:key];
}
@end