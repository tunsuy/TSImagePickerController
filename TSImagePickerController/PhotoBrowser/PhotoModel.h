//
//  PhotoModel.h
//  TSImagePickerController
//
//  Created by tunsuy on 31/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

@property (nonatomic, copy) NSString *imageUrlStr;
@property (nonatomic, strong) UIImage *localImage;
@property (nonatomic, strong) UIImageView *sourceImageView;

@end
