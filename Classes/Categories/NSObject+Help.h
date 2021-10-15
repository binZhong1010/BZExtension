//
//  NSObject+RealClass.h
//  homework
//
//  Created by panxiang on 14-6-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NBSafetyCommon.h>

@interface NSObject (Help)
+ (Class)realClass:(Class)className;
+ (void)swizzledClass:(Class)aclass
     originalSelector:(SEL)originalSelector
          altSelector:(SEL)altSelector
        isClassMethod:(BOOL)isClassMethod;
- (BOOL)hasNilObject:(ConstIDCArray)objects count:(NSInteger)cnt;
+ (BOOL)hasNilObject:(ConstIDCArray)objects count:(NSInteger)cnt;
@end
