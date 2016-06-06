//
//  TSBrowseZoomScrollView.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TSBrowseZoomScrollViewTapBlock)(void);

@interface TSBrowseZoomScrollView : UIScrollView

@property (nonatomic, strong) UIImageView *zoomImageView;

- (void)tapClick:(TSBrowseZoomScrollViewTapBlock)tapBlock;

@end
