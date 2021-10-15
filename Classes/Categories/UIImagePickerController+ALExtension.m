//
//  UIImagePickerController+ALExtension.m
//  test
//
//  Created by Albert Lee on 2018/11/6.
//  Copyright © 2018 Baobao. All rights reserved.
//

#import "UIImagePickerController+ALExtension.h"
#import <objc/runtime.h>
#import <Photos/Photos.h>
static char UIImagePickerControllerDelegate_AL;
@implementation UIImagePickerController (ALExtension)
@dynamic al_delegate;
+ (UIImagePickerController *)libraryPickerWithEditingEnabled:(BOOL)enabled{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.allowsEditing = enabled;
  if (@available(iOS 11.0, *)) {
    picker.imageExportPreset = UIImagePickerControllerImageURLExportPresetCurrent;
  } else {
    // Fallback on earlier versions
  }
  return picker;
}

-(void)setAl_delegate:(id<UIImagePickerControllerDelegate_AL>)al_delegate{
  objc_setAssociatedObject(self, &UIImagePickerControllerDelegate_AL, al_delegate, OBJC_ASSOCIATION_ASSIGN);
}

-(id<UIImagePickerControllerDelegate_AL>)al_delegate{
  return objc_getAssociatedObject(self, &UIImagePickerControllerDelegate_AL);
}

- (void)al_imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
  __weak typeof(self)wSelf = self;
  UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
  BOOL allowEditing = picker.allowsEditing;
  if (@available(iOS 11.0, *)) {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
      [[PHImageManager defaultManager] requestImageDataForAsset:[info objectForKey:UIImagePickerControllerPHAsset] options:nil
                                                  resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                                                    if ([dataUTI isEqualToString:AVFileTypeHEIF] || [dataUTI isEqualToString:AVFileTypeHEIC]) {
                                                      if (allowEditing) {
                                                        NSData *jpgEditedData = UIImageJPEGRepresentation(editedImage, 1.0);
                                                        if (wSelf.al_delegate && [wSelf.al_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
                                                          [wSelf.al_delegate imagePickerController:picker didFinishPickingMediaWithImage:[UIImage imageWithData:jpgEditedData]];
                                                        }
                                                      }else{
                                                        CIImage *ciImage = [CIImage imageWithData:imageData];
                                                        CIContext *context = [CIContext context];
                                                        NSData *jpgData = [context JPEGRepresentationOfImage:ciImage colorSpace:ciImage.colorSpace options:@{}];
                                                        if (wSelf.al_delegate && [wSelf.al_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
                                                          [wSelf.al_delegate imagePickerController:picker didFinishPickingMediaWithImage:[UIImage imageWithData:jpgData]];
                                                        }
                                                      }
                                                    } else {
                                                      if (wSelf.al_delegate && [wSelf.al_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
                                                        [wSelf.al_delegate imagePickerController:picker didFinishPickingMediaWithImage:allowEditing?editedImage:originalImage];
                                                      }
                                                    }
                                                  }];
    }else{
      if (self.al_delegate && [self.al_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
        [self.al_delegate imagePickerController:picker didFinishPickingMediaWithImage:allowEditing?editedImage:originalImage];
      }
    }
  }else {
    if (self.al_delegate && [self.al_delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithImage:)]) {
      [self.al_delegate imagePickerController:picker didFinishPickingMediaWithImage:allowEditing?editedImage:originalImage];
    }
  }
}


@end
