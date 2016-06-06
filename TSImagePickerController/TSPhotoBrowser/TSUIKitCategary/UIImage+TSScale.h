//
//  UIImage+TSScale.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TSScale)

- (CGRect)ts_getBigImageRectWithScreenWidth:(CGFloat)screenWidth screenHeight:(CGFloat)screenHeight;

@end
