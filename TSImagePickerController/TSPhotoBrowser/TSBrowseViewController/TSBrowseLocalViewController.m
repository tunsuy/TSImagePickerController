//
//  TSBrowseLocalViewController.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseLocalViewController.h"

@implementation TSBrowseLocalViewController

- (void)loadBrowseImageWithBrowseItem:(TSBrowseModel *)browseItem cell:(TSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect {
    cell.loadingView.hidden = YES;
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    if (browseItem.bigImageLocalPath) {
        NSData *imageData = [[NSData alloc] initWithContentsOfFile:browseItem.bigImageLocalPath];
        imageView.image = [UIImage imageWithData:imageData];
    }
    else if (browseItem.bigImage) {
        imageView.image = browseItem.bigImage;
    }
    else if (browseItem.bigImageData) {
        imageView.image = [UIImage imageWithData:browseItem.bigImageData];
    }
    else {
        imageView.image = nil;
    }
    CGRect bigImgRect = [self getBigImageRectIfIsEmptyRect:bigImageRect bigImage:imageView.image];
    if (self.firstOpen) {
        self.firstOpen = NO;
        imageView.frame = [self getFrameInWindow:browseItem.smallImageView];
        [UIView animateWithDuration:0.5
                         animations:^{
                             imageView.frame = bigImgRect;
                         }];
    }
    else {
        imageView.frame = bigImgRect;
    }
}

- (CGRect)getBigImageRectIfIsEmptyRect:(CGRect)rect bigImage:(UIImage *)bigImage {
    if (CGRectIsEmpty(rect)) {
        return [bigImage ts_getBigImageRectWithScreenWidth:self.screenWidth screenHeight:self.screenHeight];
    }
    return rect;
}

@end
