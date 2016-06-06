//
//  TSHUD.m
//  TSImagePickerController
//
//  Created by tunsuy on 30/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSHUD.h"

@interface LoadingView : UIView

@property (nonatomic, copy) NSString *progressText;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonatomic) CGFloat progress;

@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat radius;

@end

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = true;
        
        self.progress = 0.0;
        self.progressText = @"0%";
        
        self.lineWidth = 8.0;
        self.radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.5;
        
        [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGFloat endAngle = self.progress * M_PI * 2 - M_PI_2 + 0.01;
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, self.radius, -M_PI_2, endAngle, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}

#pragma mark - LoadingView getters or setters
- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, (self.bounds.size.height-30.0)*0.5, self.bounds.size.width-20.0, 30.0)];
        _progressLabel.center = self.center;
        _progressLabel.font = [UIFont systemFontOfSize:16.0];
        _progressLabel.textColor = [UIColor whiteColor];
        _progressLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _progressLabel;
}


#pragma mark - LoadingView KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    CGFloat progress = [[object valueForKeyPath:keyPath] floatValue];
    if (progress >= 1.0) {
        [self removeFromSuperview];
    }
    self.progressText = [NSString stringWithFormat:@"%f%%", self.progress * 100];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"progress" context:nil];
}

@end


@interface TSHUD ()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) LoadingView *loadingView;

@end

@implementation TSHUD

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        self.loadingView.progress = 0.01;
        
        [self.loadingView addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - TSHUD getters or setters
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-80.0)*0.5, 0.0, 80.0, 30.0)];
        _messageLabel.font = [UIFont boldSystemFontOfSize:16.0];
        _messageLabel.backgroundColor = [UIColor blackColor];
        _messageLabel.layer.cornerRadius = _messageLabel.bounds.size.height/2;
        _messageLabel.layer.masksToBounds = true;
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (LoadingView *)loadingView {
    if (!_loadingView) {
        _loadingView = [[LoadingView alloc] initWithFrame:CGRectMake((self.bounds.size.width-80.0)*0.5, (self.bounds.size.height-80.0)*0.5, 80.0, 80.0)];
    }
    return _loadingView;
}

- (void)addLoadingView:(NSSet *)objects {
    [self.messageLabel removeFromSuperview];
    [self addSubview:self.loadingView];
}

- (void)showHUDWithText:(NSString *)text autoHide:(BOOL)autoHide afterTime:(CGFloat)time {
    [self.loadingView removeFromSuperview];
    [self addSubview:self.messageLabel];
    self.messageLabel.text = text;
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.messageLabel.font} context:nil].size;
    self.messageLabel.frame = CGRectMake((self.bounds.size.width-textSize.width-16.0)*0.5, (self.bounds.size.height-40.0)*0.5, textSize.width+16.0, 40.0);
    self.messageLabel.layer.cornerRadius = self.messageLabel.bounds.size.height / 2;
    
    if (autoHide) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideHUD];
        });
    }
}

- (void)hideLoadingView {
    [self.loadingView removeFromSuperview];
}

- (void)hideHUD {
    [self removeFromSuperview];
}

- (void)dealloc {
    [self.loadingView removeObserver:self forKeyPath:@"progress" context:nil];
}

@end
