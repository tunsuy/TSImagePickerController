//
//  TSImagePickerController.h
//  TSImagePickerController
//
//  Created by tunsuy on 30/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TSImagePickerController : UINavigationController

@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;
@property (nonatomic, assign) BOOL allowPickingVideo;
@property (nonatomic, assign) BOOL allowPickingImage;

@end
