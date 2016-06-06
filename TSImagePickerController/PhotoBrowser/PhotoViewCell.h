//
//  PhotoViewCell.h
//  TSImagePickerController
//
//  Created by tunsuy on 31/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@interface PhotoViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) PhotoModel *photoModel;

- (void)resetUI;

@end
