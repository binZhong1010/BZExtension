//
//  NBSafetyCommon.h
//  homework
//
//  Created by panxiang on 14-6-25.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//


#define kError_nil_object                           @"failed because object is nil"
#define ThreadCallStackSymbols                      [NSThread callStackSymbols]

#if TARGET_OS_WIN32
#define ConstIDCArray const id []
#else
#define ConstIDCArray const id <NSCopying> []
#endif


