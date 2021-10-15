//
//  PDLiveBeautyManager.m
//  Pandora
//
//  Created by Albert Lee on 05/01/2018.
//  Copyright © 2018 Albert Lee. All rights reserved.
//

#import "PDLiveBeautyManager.h"
#define PDLiveBeatutySettingCache @"PDLiveBeatutySettingCache"
static PDLiveBeautyManager *shareManager = NULL;
@implementation PDLiveBeautyManager{
  IDPCache *_settingCache;
}

+ (PDLiveBeautyManager *)shareManager{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shareManager = [[PDLiveBeautyManager alloc] init];
  });
  return shareManager;
}

- (instancetype)init{
  if (self = [super init]) {
    _settingCache = [[IDPCache alloc] initWithNameSpace:PDLiveBeatutySettingCache storagePolicy:IDPCacheStorageDisk];
    
    NSNumber *gearLevel     = [_settingCache objectForKey:@"gearLevel"];
    self.gearLevel = gearLevel?[gearLevel integerValue]:1;//
  }
  return self;
}

- (void)setGearLevel:(NSInteger)gearLevel{
  _gearLevel = gearLevel;
  [_settingCache setObj:@(gearLevel) forKey:@"gearLevel"];
}
@end
