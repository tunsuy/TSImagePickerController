//
//  TSBrowseZoomScrollView.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseZoomScrollView.h"

@interface TSBrowseZoomScrollView ()<UIScrollViewDelegate>

@property (nonatomic, copy) TSBrowseZoomScrollViewTapBlock tapBlock;
@property (nonatomic) BOOL singleTap;

@end

@implementation TSBrowseZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateZoomScrollView];
    }
    return self;
}

- (void)generateZoomScrollView {
    self.delegate = self;
    self.singleTap = NO;
    self.minimumZoomScale = 1.0f;
    self.maximumZoomScale = 3.0f;
    
    _zoomImageView = [[UIImageView alloc] init];
    _zoomImageView.userInteractionEnabled = YES;
    
    [self addSubview:_zoomImageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomImageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.zoomImageView setTs_X:0];
    [self.zoomImageView setTs_Y:0];
    
    if (self.zoomImageView.ts_Width < self.ts_Width) {
        [self.zoomImageView setTs_X:floorf(self.ts_Width - self.zoomImageView.ts_Width) / 2.0];
    }
    if (self.zoomImageView.ts_Height < self.ts_Height) {
        [self.zoomImageView setTs_Y:floorf(self.ts_Height - self.zoomImageView.ts_Height) / 2.0];
    }
    
}

- (void)tapClick:(TSBrowseZoomScrollViewTapBlock)tapBlock {
    self.tapBlock = tapBlock;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        [self performSelector:@selector(singleTapClick) withObject:nil afterDelay:0.17];
    }
    else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        if (!self.singleTap) {
            CGPoint touchPoint = [touch locationInView:self.zoomImageView];
            [self zoomDoubleTapWithPoint:touchPoint];
        }
    }
}

- (void)singleTapClick {
    self.singleTap = YES;
    if (self.tapBlock) {
        self.tapBlock();
    }
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint {
    if (self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    }
    else {
        CGFloat width = self.ts_Width / self.maximumZoomScale;
        CGFloat height = self.ts_Height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}

@end
