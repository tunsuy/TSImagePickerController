//
//  PhotoToolBar.m
//  TSImagePickerController
//
//  Created by tunsuy on 30/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "PhotoToolBar.h"

#define kIndeLabelFont 20.0

@interface PhotoToolBar ()

@property (nonatomic) ToolBarStyle toolBarStyle;

@end

@implementation PhotoToolBar

- (instancetype)initWithFrame:(CGRect)frame toolBarStyle:(ToolBarStyle)toolBarStyle {
    self = [super initWithFrame:frame];
    if (self) {
        self.toolBarStyle = toolBarStyle;
        [self addSubview:self.saveBtn];
        [self addSubview:self.extraBtn];
        [self addSubview:self.indexLabel];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    ToolBarStyle toolBarStyleDefault = {YES, YES, ToolBarPositionDown};
    return [self initWithFrame:frame toolBarStyle:toolBarStyleDefault];
}

#pragma mark - getters or setters
- (UIButton *)saveBtn {
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc] init];
        [_saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveBtn.backgroundColor = [UIColor clearColor];
        [_saveBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton *)extraBtn {
    if (!_extraBtn) {
        _extraBtn = [[UIButton alloc] init];
        [_extraBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _extraBtn.backgroundColor = [UIColor clearColor];
        [_extraBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_extraBtn addTarget:self action:@selector(extraBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extraBtn;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.backgroundColor = [UIColor clearColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.font = [UIFont systemFontOfSize:kIndeLabelFont];
    }
    return _indexLabel;
}

#pragma mark - event response
- (void)saveBtnOnClick:(UIButton *)sender {
    
}

- (void)extraBtnOnClick:(UIButton *)sender {
    
}

#pragma mark - life cycle
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}

@end
