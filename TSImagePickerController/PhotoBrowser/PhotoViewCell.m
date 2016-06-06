//
//  PhotoViewCell.m
//  TSImagePickerController
//
//  Created by tunsuy on 31/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "PhotoViewCell.h"
#import "PhotoBrowser.h"
#import "TSHUD.h"

@interface PhotoViewCell ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) TSHUD *hud;

@property (nonatomic, strong) UIImage *image;

@end

@implementation PhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpScrollView];
        [self addGestures];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.contentView.bounds.size.width-20.0, self.contentView.bounds.size.height);
    [self setUpImageViewFrame];
}

#pragma mark - getters or setters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width-20.0, self.contentView.bounds.size.height)];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.clipsToBounds = YES;
        
        _scrollView.maximumZoomScale = 2.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (TSHUD *)hud {
    if (!_hud) {
        _hud = [[TSHUD alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height-80.0)/0.5, self.bounds.size.width, 80.0)];
        
    }
    return _hud;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        _imageView.backgroundColor = [UIColor blackColor];
    }
    return _imageView;
}

#pragma mark - private method
- (void)setUpScrollView {
    [self.scrollView addSubview:self.imageView];
    [self.contentView addSubview:self.scrollView];
}

- (void)setUpImage {
    /** 本地图片处理 todo */
    
    /** 网络图片处理 todo */
}

- (void)setUpImageViewFrame {
    if (self.image) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
        self.imageView.image = self.image;
        
        CGFloat width = self.image.size.width < self.scrollView.bounds.size.width ? self.image.size.width : self.scrollView.bounds.size.width;
        CGFloat height = self.image.size.height * (width / self.image.size.width);
        
        if (height > self.scrollView.bounds.size.height) {
            self.imageView.frame = CGRectMake((self.scrollView.bounds.size.width-width)/2, 0, width, height);
            self.scrollView.contentSize = self.imageView.bounds.size;
            self.scrollView.contentOffset = CGPointZero;
        }
        else {
            self.imageView.frame = CGRectMake((self.scrollView.bounds.size.width-width)/2, (self.scrollView.bounds.size.height-height)/2, width, height);
        }
        self.scrollView.maximumZoomScale = self.scrollView.bounds.size.height / height + 1.0;
    }
}

- (void)resetUI {
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    self.imageView.image = nil;
    [self.hud hideHUD];
}

- (void)addGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
}

#pragma mark - event response
- (void)handleSingleTap:(UITapGestureRecognizer *)tapGesture {
    if (self.scrollView.zoomScale != self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
    }
    
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGesture {
    if (!self.imageView.image) {
        return;
    }
    if (self.scrollView.zoomScale <= self.scrollView.minimumZoomScale) {
        CGPoint location = [tapGesture locationInView:self.scrollView];
        CGFloat width = self.scrollView.bounds.size.width / self.scrollView.maximumZoomScale;
        CGFloat height = self.scrollView.bounds.size.height / self.scrollView.maximumZoomScale;
        
        CGRect rect = CGRectMake(location.x*(1-1/self.scrollView.maximumZoomScale), location.y*(1-1/self.scrollView.maximumZoomScale), width, height);
        [self.scrollView zoomToRect:rect animated:YES];
    }
    else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.scrollView.bounds.size.width>self.scrollView.contentSize.width) ? (self.scrollView.bounds.size.width-self.scrollView.contentSize.width)/2 : 0.0;
    CGFloat offseetY = (self.scrollView.bounds.size.height>self.scrollView.contentSize.height) ? (self.scrollView.bounds.size.height-self.scrollView.contentSize.height)/2 : 0.0;
    
    self.imageView.center = CGPointMake(self.scrollView.contentSize.width/2+offsetX, self.scrollView.contentSize.height/2+offseetY);
}



@end
