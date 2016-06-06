//
//  TSBrowseCollectionViewCell.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseCollectionViewCell.h"

@interface TSBrowseCollectionViewCell ()

@property (nonatomic, copy) TSBrowseCollectionViewCellTapBlock tapBlock;
@property (nonatomic, copy) TSBrowseCollectionViewCellLongPressBlock longPressBlock;

@end

@implementation TSBrowseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateCell];
    }
    return  self;
}

- (void)generateCell {
    _zoomScrollView = [[TSBrowseZoomScrollView alloc] init];
    __weak typeof(self) weakself = self;
    [_zoomScrollView tapClick:^{
        __strong typeof(weakself) strongself = weakself;
        strongself.tapBlock(strongself);
    }];
    
    [self.contentView addSubview:_zoomScrollView];
    
    _loadingView = [[TSBrowseLoadingImageView alloc] init];
    [_zoomScrollView addSubview:_loadingView];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.contentView addGestureRecognizer:longPressGesture];
}

#pragma mark - event response
- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture {
    if (self.longPressBlock) {
        if (longPressGesture.state == UIGestureRecognizerStateBegan) {
            self.longPressBlock(self);
        }
    }
}

#pragma mark - public method
- (void)tapClick:(TSBrowseCollectionViewCellTapBlock)tapBlock {
    self.tapBlock = tapBlock;
}

- (void)longPress:(TSBrowseCollectionViewCellLongPressBlock)longPressBlock {
    self.longPressBlock = longPressBlock;
}

@end
