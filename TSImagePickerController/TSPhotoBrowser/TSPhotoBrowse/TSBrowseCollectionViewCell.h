//
//  TSBrowseCollectionViewCell.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSBrowseLoadingImageView.h"
#import "TSBrowseZoomScrollView.h"

@class TSBrowseCollectionViewCell;

typedef void (^TSBrowseCollectionViewCellTapBlock)(TSBrowseCollectionViewCell *browseCell);
typedef void (^TSBrowseCollectionViewCellLongPressBlock)(TSBrowseCollectionViewCell *browseCell);

@interface TSBrowseCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) TSBrowseLoadingImageView *loadingView;
@property (nonatomic, strong) TSBrowseZoomScrollView *zoomScrollView;

- (void)tapClick:(TSBrowseCollectionViewCellTapBlock)tapBlock;
- (void)longPress:(TSBrowseCollectionViewCellLongPressBlock)longPressBlock;

@end
