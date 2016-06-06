//
//  TSSDWebImageOperator.m
//  TSImagePickerController
//
//  Created by tunsuy on 4/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSSDWebImageOperator.h"

@implementation TSSDWebImageOperator

+ (BOOL)diskImageExistsWithKey:(NSString *)key {
    return [[SDImageCache sharedImageCache] diskImageExistsWithKey:key];
}

+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key {
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
}

+ (void)setImageForImageView:(UIImageView *)imageView WithURL:(NSURL *)url {
    [imageView sd_setImageWithURL:url];
}

+ (void)setImageForImageView:(UIImageView *)imageView withURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [imageView sd_setImageWithURL:url placeholderImage:placeholder completed:completedBlock];
}

+ (void)cancelCurrentImageLoadForImageView:(UIImageView *)imageView {
    [imageView sd_cancelCurrentImageLoad];
}

+ (void)clearMemory {
    [[SDImageCache sharedImageCache]clearMemory];
}

+ (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion {
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:completion];
}

@end
