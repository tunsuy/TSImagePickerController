//
//  UIView+TSLayout.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "UIView+TSLayout.h"

@implementation UIView (TSLayout)

- (CGFloat)ts_MinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)ts_MaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)ts_MinY {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)ts_MaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)ts_Width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)ts_Height {
    return CGRectGetHeight(self.frame);
}

- (void)setTs_X:(CGFloat)tsX {
    CGRect frame = self.frame;
    frame.origin.x = tsX;
    self.frame = frame;
}

- (void)setTs_Y:(CGFloat)tsY {
    CGRect frame = self.frame;
    frame.origin.y = tsY;
    self.frame = frame;
}

- (void)setTs_Width:(CGFloat)tsWidth {
    CGRect frame = self.frame;
    frame.size.width = tsWidth;
    self.frame = frame;
}

- (void)setTs_Height:(CGFloat)tsHeight {
    CGRect frame = self.frame;
    frame.size.height = tsHeight;
    self.frame = frame;
}

- (void)ts_setFrameInSuperViewCenterWithSize:(CGSize)size {
    self.frame = CGRectMake((self.superview.ts_Width - size.width) / 2, (self.superview.ts_Height - size.height) / 2, size.width, size.height);
}

@end
