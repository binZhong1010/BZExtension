//
//  NSDictionary+Safety.h
//  homework
//
//  Created by panxiang on 14-6-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safety)
- (id)valueForKeySafely:(id)aKey;
- (void)setValue:(id)value forKeySafely:(NSString *)key;
+ (id)sharedKeySetForKeysSafely:(NSArray *)keys;
- (id)objectForKeySafely:(id)aKey;
- (id)objectForKeyedSubscriptSafely:(id)key;
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarkerSafely:(id)marker;
+ (instancetype)dictionaryWithObject:(id)object forKeySafely:(id <NSCopying>)key;
@end

@interface NSMutableDictionary (Safety)
//+ (instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (void)removeObjectForKeySafely:(id)aKey;
- (void)setObject:(id)anObject forKeySafely:(id <NSCopying>)aKey;
- (void)setObject:(id)obj forKeyedSubscriptSafely:(id <NSCopying>)key;
@end