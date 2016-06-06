//
//  TSPhotoListCollectionViewCell.m
//  TSImagePickerController
//
//  Created by tunsuy on 4/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSPhotoListCollectionViewCell.h"

@implementation TSPhotoListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateCell];
    }
    return self;
}

- (void)generateCell {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:_imageView];
}

@end
