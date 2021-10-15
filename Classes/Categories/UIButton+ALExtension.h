//
//  UIButton+ALExtension.h
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ALExtension)
@property (nonatomic, strong)NSString *tagString;
@property (nonatomic, strong)UIImageView *customImageView;
@property (nonatomic, strong)UILabel *lblCustom;
@property (nonatomic, strong)UILabel *lblCustom2;

- (void)setCubeEnlargeWith:(CGFloat)length;
- (void)setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap;
- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap left:(CGFloat)left;
- (void)setImage:(UIImage *)image
            text:(NSString *)text
    textColorHex:(UInt32)textColorHex
        fontSize:(NSInteger)fontSize
             gap:(CGFloat)gap;
- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize;
@end
