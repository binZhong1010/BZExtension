//
//  UIImagePickerController+ALExtension.h
//  test
//
//  Created by Albert Lee on 2018/11/6.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol UIImagePickerControllerDelegate_AL;
@interface UIImagePickerController (ALExtension)
@property(nonatomic, weak)id<UIImagePickerControllerDelegate_AL>al_delegate;
+ (UIImagePickerController *)libraryPickerWithEditingEnabled:(BOOL)enabled;
- (void)al_imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;
@end


@protocol UIImagePickerControllerDelegate_AL <NSObject>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithImage:(UIImage *)image;
@end


NS_ASSUME_NONNULL_END
