//
//  PhotoModel.m
//  TSImagePickerController
//
//  Created by tunsuy on 31/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "PhotoModel.h"

@interface PhotoModel ()

@end

@implementation PhotoModel

- (instancetype)initWithLocalImage:(UIImage *)localImage sourceImageView:(UIImageView *)sourceImageView {
    if (self = [super init]) {
        self.localImage = localImage;
        self.sourceImageView = sourceImageView;
    }
    return self;
}

- (instancetype)initWithImageUrlStr:(NSString *)imageUrlStr sourceImageView:(UIImageView *)sourceImageView {
    if (self = [super init]) {
        self.imageUrlStr = imageUrlStr;
        self.sourceImageView = sourceImageView;
    }
    return self;
}

@end
