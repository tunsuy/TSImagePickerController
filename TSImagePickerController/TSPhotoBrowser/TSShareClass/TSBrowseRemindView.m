//
//  TSBrowseRemindView.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseRemindView.h"

@interface TSBrowseRemindView ()

@property (nonatomic, strong) UILabel *remindLabel;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation TSBrowseRemindView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self generateRemindView];
    }
    return self;
}

- (void)generateRemindView {
    self.alpha = 0;
    
    _maskView = [[UIView alloc] init];
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5f;
    _maskView.layer.cornerRadius = 5.0f;
    _maskView.layer.masksToBounds = YES;
    [self addSubview:_maskView];
    
    _remindLabel = [[UILabel alloc] init];
    _remindLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _remindLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    _remindLabel.textColor = [UIColor whiteColor];
    [self addSubview:_remindLabel];
}

- (void)showRemindViewWithText:(NSString *)text {
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.remindLabel.font} context:nil].size;
    [self.maskView ts_setFrameInSuperViewCenterWithSize:CGSizeMake(textSize.width + 20, textSize.height + 40)];
    [self.remindLabel ts_setFrameInSuperViewCenterWithSize:CGSizeMake(textSize.width, textSize.height)];
    
    self.remindLabel.text = text;
    
    self.alpha = 0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 1.0;
                     }];
}

- (void)hideRemindView {
    self.alpha = 1.0;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.alpha = 0;
                     }];
}

@end
