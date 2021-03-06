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
  BOOL isValidRange = range.location <10000 && range.length < 10000 && range.location != NSNotFound && range.location < array.count && range.length <= array.count; //subarray 1000 ??????????????????
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



/* ------runtime??????????????????--------  */
#import <objc/runtime.h>

@implementation NSArray (safe)

+ (void)load {
    //???????????????????????????
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //?????? objectAtIndex
        NSString *tmpStr = @"objectAtIndex:";
        NSString *tmpFirstStr = @"safe_ZeroObjectAtIndex:";
        NSString *tmpThreeStr = @"safe_objectAtIndex:";
        NSString *tmpSecondStr = @"safe_singleObjectAtIndex:";
        
        // ?????? objectAtIndexedSubscript
        
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
 ??????NSArray ???index??? ??? ?????? __NSArrayI
 
 @param index ?????? index
 @return ?????????
 */
- (id)safe_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_objectAtIndex:index];
}


/**
 ??????NSArray ???index??? ??? ?????? __NSSingleObjectArrayI
 
 @param index ?????? index
 @return ?????????
 */
- (id)safe_singleObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_singleObjectAtIndex:index];
}

/**
 ??????NSArray ???index??? ??? ?????? __NSArray0
 
 @param index ?????? index
 @return ?????????
 */
- (id)safe_ZeroObjectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safe_ZeroObjectAtIndex:index];
}

/**
 ??????NSArray ???index??? ??? ?????? __NSArrayI
 
 @param idx ?????? idx
 @return ?????????
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
    //???????????????????????????
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //?????? objectAtIndex:
        NSString *tmpGetStr = @"objectAtIndex:";
        NSString *tmpSafeGetStr = @"safeMutable_objectAtIndex:";
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpGetStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeGetStr)];
        
        //?????? removeObjectsInRange:
        NSString *tmpRemoveStr = @"removeObjectsInRange:";
        NSString *tmpSafeRemoveStr = @"safeMutable_removeObjectsInRange:";
        
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveStr)];
        
        
        //?????? insertObject:atIndex:
        NSString *tmpInsertStr = @"insertObject:atIndex:";
        NSString *tmpSafeInsertStr = @"safeMutable_insertObject:atIndex:";
        
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpInsertStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeInsertStr)];
        
        //?????? removeObject:inRange:
        NSString *tmpRemoveRangeStr = @"removeObject:inRange:";
        NSString *tmpSafeRemoveRangeStr = @"safeMutable_removeObject:inRange:";
        
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpRemoveRangeStr)                                     swizzledSelector:NSSelectorFromString(tmpSafeRemoveRangeStr)];
        
        
        // ?????? objectAtIndexedSubscript
        
        NSString *tmpSubscriptStr = @"objectAtIndexedSubscript:";
        NSString *tmpSecondSubscriptStr = @"safeMutable_objectAtIndexedSubscript:";
        [self exchangeInstanceMethodWithSelfClass:NSClassFromString(@"__NSArrayM")
                                     originalSelector:NSSelectorFromString(tmpSubscriptStr)                                     swizzledSelector:NSSelectorFromString(tmpSecondSubscriptStr)];
    });
    
}

#pragma mark --- implement method

/**
 ??????NSArray ???index??? ???
 
 @param index ?????? index
 @return ?????????
 */
- (id)safeMutable_objectAtIndex:(NSUInteger)index {
    if (index >= self.count){
        return nil;
    }
    return [self safeMutable_objectAtIndex:index];
}

/**
 NSMutableArray ?????? ?????? index ????????? ???
 
 @param range ?????? ??????
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
 ???range???????????? ?????????anObject
 
 @param anObject ?????????anObject
 @param range ??????
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
 NSMutableArray ?????? ?????? ??? ??????index ????????????
 
 @param anObject ??????
 @param index ?????? index
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
 ??????NSArray ???index??? ??? ?????? __NSArrayI
 
 @param idx ?????? idx
 @return ?????????
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
