//
//  HUDView.m
//  TSImagePickerController
//
//  Created by tunsuy on 30/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "HUDView.h"

@interface HUDView ()

@property (nonatomic, strong) UIView *HUDContainer;
@property (nonatomic, strong) UIActivityIndicatorView *HUDIndicatorView;
@property (nonatomic, strong) UILabel *HUDLable;

@end

@implementation HUDView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _HUDContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 90)];
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);

        _HUDLable = [[UILabel alloc] init];
        _HUDLable.frame = CGRectMake(0,40, 120, 50);
        _HUDLable.textAlignment = NSTextAlignmentCenter;
        _HUDLable.text = @"处理中...";
        _HUDLable.font = [UIFont systemFontOfSize:15];
        _HUDLable.textColor = [UIColor whiteColor];

        [_HUDContainer addSubview:_HUDLable];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [self addSubview:_HUDContainer];
        
    }
    return self;
}

- (void)showAnimation {
    [self.HUDIndicatorView startAnimating];
}

@end
