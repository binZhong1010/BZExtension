//
//  UIAlertController+YDUtility.m
//  XSB
//
//  Created by Albert Lee on 02/03/2018.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import "UIAlertController+ALExtension.h"
@implementation UIAlertController (Private)
@dynamic alertWindow;
- (void)setAlertWindow:(UIWindow *)alertWindow {
  objc_setAssociatedObject(self, @selector(alertWindow), alertWindow, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIWindow *)alertWindow {
  return objc_getAssociatedObject(self, @selector(alertWindow));
}

@end
@implementation UIAlertController (ALUtility)

+ (UIAlertController *)alertWithTitle:(NSString *)title
                                  msg:(NSString *)msg
                                style:(UIAlertControllerStyle)style
                     cancelButtonItem:(ALButtonItem *)inCancelButtonItem
                destructiveButtonItem:(ALButtonItem *)inDestructiveItem
                     otherButtonItems:(ALButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION{
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                 message:msg
                                                          preferredStyle:style];
  
  NSMutableArray *buttonsArray = [NSMutableArray array];
  
  ALButtonItem *eachItem;
  va_list argumentList;
  if (inOtherButtonItems){
    [buttonsArray addObject: inOtherButtonItems];
    va_start(argumentList, inOtherButtonItems);
    while((eachItem = va_arg(argumentList, ALButtonItem *))){
      [buttonsArray addObject: eachItem];
    }
    va_end(argumentList);
  }
  alert.view.tintColor = [UIColor colorWithRGBHex:0x2a2a30];
  BOOL isButtonAdded = NO;
  for(ALButtonItem *item in buttonsArray){
    if (item.label.length) {
      UIAlertAction *action = [UIAlertAction actionWithTitle:item.label
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (item.action) {
          item.action();
        }
      }];
      isButtonAdded = YES;
      [alert addAction:action];
    }
  }
  
  if(inDestructiveItem)
  {
    UIAlertAction *action = [UIAlertAction actionWithTitle:inDestructiveItem.label
                                                     style:UIAlertActionStyleDestructive
                                                   handler:^(UIAlertAction * _Nonnull action) {
      if (inDestructiveItem.action) {
        inDestructiveItem.action();
      }
    }];
    [alert addAction:action];
  }
  
  if(inCancelButtonItem){
    UIAlertAction *action = [UIAlertAction actionWithTitle:inCancelButtonItem.label.length?inCancelButtonItem.label:(isButtonAdded?@"取消":@"确定")
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
      if (inCancelButtonItem.action) {
        inCancelButtonItem.action();
      }
    }];
    [alert addAction:action];
  }else if(!isButtonAdded){
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
  }
  return alert;
}

- (void)show {
  [self show:YES];
}

- (void)show:(BOOL)animated {
  self.alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.alertWindow.rootViewController = [[UIViewController alloc] init];
  
  id<UIApplicationDelegate> delegate = [UIApplication sharedApplication].delegate;
  // Applications that does not load with UIMainStoryboardFile might not have a window property:
  if ([delegate respondsToSelector:@selector(window)]) {
    // we inherit the main window's tintColor
    self.alertWindow.tintColor = delegate.window.tintColor;
  }
  
  // window level is above the top window (this makes the alert, if it's a sheet, show over the keyboard)
  UIWindow *topWindow = [UIApplication sharedApplication].windows.lastObject;
  self.alertWindow.windowLevel = topWindow.windowLevel + 1;
  
  [self.alertWindow makeKeyAndVisible];
  [self.alertWindow.rootViewController presentViewController:self animated:animated completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  // precaution to insure window gets destroyed
  self.alertWindow.hidden = YES;
  self.alertWindow = nil;
}

@end
