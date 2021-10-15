//
//  NSObject+NSObject_Singleton.m
//  Zhidao
//
//  Created by aggie on 4/16/13.
//  Copyright (c) 2013 Baidu. All rights reserved.
//

#import "NSObject+Singleton.h"
#import "NSDictionary+Safety.h"

@implementation NSObject (Singleton)

NSMutableDictionary *_instanceDict;

+ (instancetype)getInstance
{
    return nil;
}

//命名
+ (instancetype)shared {
    id _instance;
    @synchronized(self)
    {
        if (_instanceDict == nil) {
            _instanceDict = [[NSMutableDictionary alloc] initWithCapacity:10];
        }
        NSString*_className = NSStringFromClass([self class]);
        if (_className) {
            _instance =[_instanceDict objectForKeySafely:_className];
            if (_instance == nil) {
                _instance = [self getInstance];
                if (_instance && _instanceDict && _className) {
                    [_instanceDict setValue:_instance forKeySafely:_className];
                }
            }
            if (_instance == nil) {
                _instance = [[self.class alloc] init];
                if (_instance && _instanceDict && _className) {
                    [_instanceDict setValue:_instance forKeySafely:_className];
                }
            }
        }
        
        return _instance;
    }
}

+ (void)destorySharedInstance
{
    if (_instanceDict == nil) {
        return;
    }

    NSString *_className = NSStringFromClass([self class]);
    if ([_instanceDict objectForKeySafely:_className]) {
        [_instanceDict removeObjectForKeySafely:_className];
    }
}


@end
