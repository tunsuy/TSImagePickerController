//
//  TSSDWebImageOperator.h
//  TSImagePickerController
//
//  Created by tunsuy on 4/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface TSSDWebImageOperator : NSObject

+ (BOOL)diskImageExistsWithKey:(NSString *)key;
+ (UIImage *)imageFromDiskCacheForKey:(NSString *)key;

+ (void)setImageForImageView:(UIImageView *)imageView WithURL:(NSURL *)url;
+ (void)setImageForImageView:(UIImageView *)imageView
                     withURL:(NSURL *)url
            placeholderImage:(UIImage *)placeholder
                   completed:(SDWebImageCompletionBlock)completedBlock;

+ (void)cancelCurrentImageLoadForImageView:(UIImageView *)imageView;

+ (void)clearMemory;
+ (void)clearDiskOnCompletion:(SDWebImageNoParamsBlock)completion;

@end
