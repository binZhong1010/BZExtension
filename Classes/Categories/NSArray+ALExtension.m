//
//  NSArray+Plist.m
//  KKShopping
//
//  Created by Albert Lee on 6/8/13.
//  Copyright (c) 2013 KiDulty. All rights reserved.
//

#import "NSArray+ALExtension.h"

@implementation NSArray(ALExtension)
-(BOOL)writeToPlistFileSync:(NSString*)filename{
  if (self==nil||(
                  (![self isKindOfClass:[NSArray class]])&&
                  (![self isKindOfClass:[NSMutableArray class]]))||
      [self count]==0) {
    return NO;
  }
  BOOL didWriteSuccessfull = NO;
  NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  didWriteSuccessfull = [data writeToFile:path atomically:YES];
  return didWriteSuccessfull;
}

+(NSArray*)readFromPlistFile:(NSString*)filename{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  NSData * data = [NSData dataWithContentsOfFile:path];
  if(!data){
    return @[];
  }
  else{
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
}

+(void)removePlistFile:(NSString*)filename
{
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString * documentsDirectory = [paths objectAtIndex:0];
  NSString * path = [[documentsDirectory stringByAppendingPathComponent:@"Caches"] stringByAppendingPathComponent:filename];
  BOOL result = [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
  NSLog(@"%@",result?@"sucess":@"fail");
}

- (id)safeObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if (![self isKindOfClass:[NSArray class]] || index >= self.count)
      return nil;
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:[NSObject class]]) {
      return obj;
    }else{
      return nil;
    }
  }
}

- (id)safeObjectAtIndex:(NSUInteger)index class:(Class)aClsss{
  @synchronized(self) {
    if (![self isKindOfClass:[NSArray class]] || index >= self.count || !self)
      return [[aClsss alloc] init];
    
    if ([[self objectAtIndex:index] isKindOfClass:aClsss]) {
      return [self objectAtIndex:index];
    }else{
      return [[aClsss alloc] init];
    }
  }
}

- (NSArray *)subarrayWithRangeSafely:(NSRange)range
{
  if (![self isRightWithRange:range forArray:self onFunction:__FUNCTION__]){
    return nil;
  }
  return [self subarrayWithRange:range];
}

- (BOOL)isRightWithRange:(NSRange)range forArray:(NSArray *)array onFunction:(const char *)function
{
  BOOL isRight = array.count >= range.location + range.length;
  BOOL isValidRange = range.location <10000 && range.length < 10000 && range.location != NSNotFound && range.location < array.count && range.length <= array.count; //subarray 1000 个应该足够了
  isRight = isRight && isValidRange;
  if (!isRight) {
    [[self class] printRangeError:range forArray:array onFunction:function];
  }
  return isRight;
}

+ (void)printRangeError:(NSRange)range forArray:(NSArray *)array onFunction:(const char *)function
{
#if PDLogEnable
  NSLog(@"*************error******************\n %s:\n range.location %d range.length %d beyond array count %d",function ,range.location,range.length ,array.count);
  NSLog(@"array data : \n %@",array);
  NSLog(@"*************error stack****************** \n%@",ThreadCallStackSymbols);
#else
#endif
  
}

- (id)safeDicObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count ||!self || ![self isKindOfClass:[NSArray class]])
      return [NSDictionary dictionary];
    id obj = [self objectAtIndex:index];
    if ([obj isKindOfClass:[NSDictionary class]]) {
      return obj;
    }
    else{
      return [NSDictionary dictionary];
    }
  }
}

- (NSArray *)safeArrayObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return [NSArray array];
    
    if ([[self objectAtIndex:index] isKindOfClass:[NSArray class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return [NSArray array];
    }
  }
}

- (id)safeNumberObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return @0;
    
    if ([[self objectAtIndex:index] isKindOfClass:[NSNumber class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return @0;
    }
  }
}

- (id)safeStringObjectAtIndex:(NSUInteger)index{
  @synchronized(self) {
    if ( index >= self.count || ![self isKindOfClass:[NSArray class]])
      return @"";
    if ([[self objectAtIndex:index] isKindOfClass:[NSString class]]) {
      return [self objectAtIndex:index];
    }
    else{
      return @"";
    }
  }
}

-(NSData*)data
{
  NSData* data = [NSKeyedArchiver archivedDataWithRootObject:self];
  return data;
}
@end

@implementation NSMutableArray (ALExtension)
- (void)safeAddObject:(id)anObject
{
  @synchronized(self){
    if (anObject) {
      [self addObject:anObject];
    }
  }
}
-(bool)safeInsertObject:(id)anObject atIndex:(NSUInteger)index
{
  @synchronized(self){
    if ( index >= self.count && index != 0)
    {
      return NO;
    }
    [self insertObject:anObject atIndex:index];
  }
  return YES;
}

-(bool)safeRemoveObjectAtIndex:(NSUInteger)index
{
  @synchronized(self){
    if ( index >= self.count )
    {
      return NO;
    }
    [self removeObjectAtIndex:index];
  }
  return YES;
  
}
-(bool)safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
  @synchronized(self){
    if ( index >= self.count )
    {
      return NO;
    }
    [self replaceObjectAtIndex:index withObject:anObject];
  }
  return YES;
}
@end



/* ------runtime防止数组越界--------  */
#import <objc/runtime.h>

@implementation NSArray (safe)

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        
        // 替换 objectAtIndexedSubscript
        
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safe_objectAtIndexedSubscript:";
        
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArray0")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpFirstStr)];
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSSingleObjectArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondStr)];
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpStr)                                     swizzledSelector:NSSelectorFromString(tmpThreeStr)];
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayI")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
        
    });
    
}


#pragma mark --- implement method

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSSingleObjectArrayI
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArray0
 
 @param index 索引 index
 @return 返回值
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:idx];
}


+ (void)exchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(selfClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSelector);
    BOOL didAddMethod = class_addMethod(selfClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(selfClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@end




@implementation NSMutableArray (Safe)

#pragma mark --- init method

+ (void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //替换 objectAtIndex:
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"safeMutable_objectAtIndex:";
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpGetStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeGetStr)];
        
        //替换 removeObjectsInRange:
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectsInRange:";
        
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
        
        //替换 insertObject:atIndex:
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"safeMutable_insertObject:atIndex:";
        
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpInsertStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeInsertStr)];
        
        //替换 removeObject:inRange:
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"safeMutable_removeObject:inRange:";
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveRangeStr)];
        
        
        // 替换 objectAtIndexedSubscript
        
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safeMutable_objectAtIndexedSubscript:";
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    });
    
}

#pragma mark --- implement method

/**
 取出NSArray 第index个 值
 
 @param index 索引 index
 @return 返回值
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray 移除 索引 index 对应的 值
 
 @param range 移除 范围
 */
- (void)safeMutable_removeObjectsInRange:(NSRange)range {
    
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    return [self safeMutable_removeObjectsInRange:range];
}


/**
 在range范围内， 移除掉anObject
 
 @param anObject 移除的anObject
 @param range 范围
 */
- (void)safeMutable_removeObject:(id)anObject inRange:(NSRange)range {
    if (range.location > self.count) {
        return;
    }
    
    if (range.length > self.count) {
        return;
    }
    
    if ((range.location + range.length) > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    
    return [self safeMutable_removeObject:anObject inRange:range];
    
}

/**
 NSMutableArray 插入 新值 到 索引index 指定位置
 
 @param anObject 新值
 @param index 索引 index
 */
- (void)safeMutable_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (index > self.count) {
        return;
    }
    
    if (!anObject){
        return;
    }
    
    [self safeMutable_insertObject:anObject atIndex:index];
}


/**
 取出NSArray 第index个 值 对应 __NSArrayI
 
 @param idx 索引 idx
 @return 返回值
 */
- (id)safeMutable_objectAtIndexedSubscript:(NSUInteger)idx {
    if (idx >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndexedSubscript:idx];
}


+ (void)exchangeInstanceMethodWithSelfClass:(Class)selfClass
                           originalSelector:(SEL)originalSelector
                           swizzledSelector:(SEL)swizzledSelector {
    
    Method originalMethod = class_getInstanceMethod(selfClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(selfClass, swizzledSelector);
    BOOL didAddMethod = class_addMethod(selfClass,
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(selfClass,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
