//
//  UIView+TSLayout.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TSLayout)

- (CGFloat) ts_MinX;
- (CGFloat) ts_MaxX;
- (CGFloat) ts_MinY;
- (CGFloat) ts_MaxY;
- (CGFloat) ts_Width;
- (CGFloat) ts_Height;

- (void)setTs_X:(CGFloat)tsX;
- (void)setTs_Y:(CGFloat)tsY;
- (void)setTs_Width:(CGFloat)tsWidth;
- (void)setTs_Height:(CGFloat)tsHeight;

- (void)ts_setFrameInSuperViewCenterWithSize:(CGSize)size;

@end
