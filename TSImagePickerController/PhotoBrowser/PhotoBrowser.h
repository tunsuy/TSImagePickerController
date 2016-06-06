//
//  PhotoBrowserViewController.h
//  TSImagePickerController
//
//  Created by tunsuy on 30/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserDelegate <NSObject>

- (UIImageView *)sourceImageViewForCurrentIndex:(NSInteger)index;
- (void)photoBrowserDidDisplayPage:(NSInteger)currentPage totalPages:(NSInteger)totalPages;
- (void)photoBrowserWillDisplay:(NSInteger)beginPage;
- (void)photoBrowserWillEndDisplay:(NSInteger)endPage;
- (void)photoBrowserDidEndDisplay:(NSInteger)endPage;

@end

//extern CGFloat contentMargin;
@interface PhotoBrowser : UIViewController

@property (nonatomic, strong) UIButton *extraBtn;
@property (nonatomic) CGFloat contentMargin;

@property (nonatomic, weak) id<PhotoBrowserDelegate> photoBrowserDelegate;

@end
