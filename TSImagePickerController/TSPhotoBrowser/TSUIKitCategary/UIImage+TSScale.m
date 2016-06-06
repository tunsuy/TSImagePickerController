//
//  UIImage+TSScale.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "UIImage+TSScale.h"

@implementation UIImage (TSScale)

- (CGRect)ts_getBigImageRectWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight {
    CGFloat widthRatio = screenWidth / self.size.width;
    CGFloat heightRatio = screenHeight / self.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    
    CGFloat width = scale * self.size.width;
    CGFloat height = scale * self.size.height;
    
    return CGRectMake((screenWidth - width) / 2, (screenHeight - height) / 2, width, height);
}

@end
