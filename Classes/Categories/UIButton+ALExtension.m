//
//  UIButton+ALExtension.m
//  ALExtension
//
//  Created by Albert Lee on 8/25/14.
//  Copyright (c) 2014 Albert Lee. All rights reserved.
//

#import "UIButton+ALExtension.h"
#import <objc/runtime.h>
#import "UIView+ALExtension.h"
#import "UIColor+ALExtension.h"
#import "UILabel+ALExtension.h"
static char UIButtonALExtensionTagString;
static char UIButtonALExtensionCustomImageView;
static char UIButtonALExtensionCustomTitleLabel;
static char UIButtonALExtensionCustomTitleLabel2;
@implementation UIButton (ALExtension)
@dynamic tagString,lblCustom,lblCustom2;
-(void)setTagString:(NSString *)tagString
{
  objc_setAssociatedObject(self, &UIButtonALExtensionTagString, tagString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSString *)tagString
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionTagString);
}

-(void)setCustomImageView:(UIImageView *)customImageView
{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomImageView, customImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIImageView *)customImageView
{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomImageView);
}

- (void)setLblCustom:(UILabel *)lblCustom{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel, lblCustom, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLblCustom2:(UILabel *)lblCustom2{
  objc_setAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel2, lblCustom2, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)lblCustom{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel);
}

- (UILabel *)lblCustom2{
  return objc_getAssociatedObject(self, &UIButtonALExtensionCustomTitleLabel2);
}

static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setCubeEnlargeWith:(CGFloat)length{
  [self setEnlargeEdgeWithTop:length left:length bottom:length right:length];
}
 
- (void)setEnlargeEdge:(CGFloat)size{
  objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:size], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
 
- (void)setEnlargeEdgeWithTop:(CGFloat) top left:(CGFloat) left bottom:(CGFloat) bottom right:(CGFloat) right ;{
  objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
  objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
 
- (CGRect) enlargedRect{
  
  if (self.hidden) {
    return CGRectZero;
  }
  NSNumber* topEdge = objc_getAssociatedObject(self, &topNameKey);
  NSNumber* rightEdge = objc_getAssociatedObject(self, &rightNameKey);
  NSNumber* bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
  NSNumber* leftEdge = objc_getAssociatedObject(self, &leftNameKey);
  if (topEdge && rightEdge && bottomEdge && leftEdge){
      return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                        self.bounds.origin.y - topEdge.floatValue,
                        self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                        self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
  } else {
    return self.bounds;
  }
}
 
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
  if (self.hidden) {
    return nil;
  }
  CGRect rect = [self enlargedRect];
  if (CGRectEqualToRect(rect, self.bounds)){
    return [super hitTest:point withEvent:event];
  }
  return CGRectContainsPoint(rect, point) ? self : nil;
}

- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap{
  [self.customImageView sizeToFit];
  [self.lblCustom sizeToFit];
  if (self.width == 0) {
    self.width = self.customImageView.width + gap + self.lblCustom.width;
  }
  self.customImageView.left = (self.width-self.customImageView.width-gap-self.lblCustom.width)/2.0;
  self.customImageView.top = (self.height-self.customImageView.height)/2.0;
  self.lblCustom.left = self.customImageView.right+gap;
  self.lblCustom.top = (self.height-self.lblCustom.height)/2.0;
}

- (void)arrangeCustomSubviewToCenterWithGap:(CGFloat)gap left:(CGFloat)left{
  [self.customImageView sizeToFit];
  [self.lblCustom sizeToFit];
  self.width = left*2+self.lblCustom.width + self.customImageView.width+gap;
  self.customImageView.left = left;
  self.customImageView.top = (self.height-self.customImageView.height)/2.0;
  self.lblCustom.left = self.customImageView.right+gap;
  self.lblCustom.top = (self.height-self.lblCustom.height)/2.0;
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize gap:(CGFloat)gap{
  [self.customImageView removeFromSuperview];
  [self.lblCustom removeFromSuperview];
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:fontSize]];
  [self addSubview:self.lblCustom];
  [self arrangeCustomSubviewToCenterWithGap:gap];
}

- (void)setImage:(UIImage *)image text:(NSString *)text textColorHex:(UInt32)textColorHex fontSize:(NSInteger)fontSize{
  [self.customImageView removeFromSuperview];
  [self.lblCustom removeFromSuperview];
  self.customImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
  self.customImageView.image = image;
  [self addSubview:self.customImageView];
  [self.customImageView sizeToFit];
  self.lblCustom = [UILabel initWithFrame:CGRectZero
                                  bgColor:[UIColor clearColor]
                                textColor:[UIColor colorWithRGBHex:textColorHex]
                                     text:text
                            textAlignment:NSTextAlignmentLeft
                                     font:[UIFont systemFontOfSize:fontSize]];
  [self addSubview:self.lblCustom];
  [self.lblCustom sizeToFit];
}
@end
