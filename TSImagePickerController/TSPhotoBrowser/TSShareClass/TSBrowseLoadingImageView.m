//
//  TSBrowseLoadingImageView.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseLoadingImageView.h"

@interface TSBrowseLoadingImageView ()

@property (nonatomic, strong) CABasicAnimation *rotationAnimation;

@end

@implementation TSBrowseLoadingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateImageView];
    }
    return self;
}

- (void)generateImageView {
    self.image = [UIImage imageNamed:@"loadingView.png"];
    _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    _rotationAnimation.duration= 0.5f;
    _rotationAnimation.repeatCount = MAXFLOAT;
}

#pragma mark - public method
- (void)startAnimation {
    self.hidden = NO;
    [self.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopAnimation {
    self.hidden = YES;
    [self.layer removeAnimationForKey:@"rotaionAnimation"];
}

@end
