//
//  UIAlertController+YDUtility.h
//  XSB
//
//  Created by Albert Lee on 02/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <ALButtonItem.h>
@interface UIAlertController (ALUtility)
+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                                style:(UIAlertControllerStyle)style
                     cancelButtonItem:(ALButtonItem *)inCancelButtonItem
                destructiveButtonItem:(ALButtonItem *)inDestructiveItem
                     otherButtonItems:(ALButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;
- (void)show;
- (void)show:(BOOL)animated;

@end

@interface UIAlertController (Private)

@property (nonatomic, strong) UIWindow *alertWindow;

@end
