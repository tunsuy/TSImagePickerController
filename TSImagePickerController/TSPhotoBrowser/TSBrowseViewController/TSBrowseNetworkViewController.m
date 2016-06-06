//
//  TSBrowseNetworkViewController.m
//  TSImagePickerController
//
//  Created by tunsuy on 4/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseNetworkViewController.h"
#import "TSSDWebImageOperator.h"

@implementation TSBrowseNetworkViewController

- (void)loadBrowseImageWithBrowseItem:(TSBrowseModel *)browseItem cell:(TSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect {
    [cell.loadingView stopAnimation];
    
    if ([TSSDWebImageOperator diskImageExistsWithKey:browseItem.bigImageUrl]) {
        [self showBigImage:cell.zoomScrollView.zoomImageView browseItem:browseItem rect:bigImageRect];
    }
    else {
        self.firstOpen = NO;
        [self loadBigImageWithBrowseItem:browseItem cell:cell rect:bigImageRect];
    }
}

- (void)showBigImage:(UIImageView *)imageView browseItem:(TSBrowseModel *)browseItem rect:(CGRect)rect {
    [TSSDWebImageOperator cancelCurrentImageLoadForImageView:imageView];
    
    imageView.image = [TSSDWebImageOperator imageFromDiskCacheForKey:browseItem.bigImageUrl];
    CGRect bigImgRect = [self getBigImageRectIfIsEmptyRect:rect bigImage:imageView.image];
    
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

- (void)loadBigImageWithBrowseItem:(TSBrowseModel *)browseItem cell:(TSBrowseCollectionViewCell *)cell rect:(CGRect)rect {
    UIImageView *imageView = cell.zoomScrollView.zoomImageView;
    [cell.loadingView startAnimation];
    [imageView ts_setFrameInSuperViewCenterWithSize:CGSizeMake(browseItem.smallImageView.ts_Width, browseItem.smallImageView.ts_Height)];
    [TSSDWebImageOperator setImageForImageView:imageView
                                       withURL:[NSURL URLWithString:browseItem.bigImageUrl]
                              placeholderImage:browseItem.smallImageView.image
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (self.collectionView.userInteractionEnabled) {
                                             [cell.loadingView stopAnimation];
                                             
                                             if (error) {
                                                 [self showBrowseRemindViewWithText:@"图片加载失败"];
                                             }
                                             else {
                                                 CGRect bigImgRect = [self getBigImageRectIfIsEmptyRect:rect bigImage:image];
                                                 [UIView animateWithDuration:0.5
                                                                  animations:^{
                                                                      imageView.frame = bigImgRect;
                                                                  }];
                                            }
                                         }
                                     }];
}

- (CGRect)getBigImageRectIfIsEmptyRect:(CGRect)rect bigImage:(UIImage *)bigImage {
    if (CGRectIsEmpty(rect)) {
        return [bigImage ts_getBigImageRectWithScreenWidth:self.screenWidth screenHeight:self.screenHeight];
    }
    return rect;
}

@end
