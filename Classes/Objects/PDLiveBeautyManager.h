//
//  PDLiveBeautyManager.h
//  Pandora
//
//  Created by Albert Lee on 05/01/2018.
//  Copyright © 2018 Albert Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDLiveBeautyManager : NSObject
+ (PDLiveBeautyManager *)shareManager;
@property (nonatomic, assign)               NSInteger gearLevel;        /**美颜等级*/
@end
