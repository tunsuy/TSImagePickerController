//
//  PhotoToolBar.h
//  TSImagePickerController
//
//  Created by tunsuy on 30/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ToolBarPosition) {
    ToolBarPositionUp = 0,
    ToolBarPositionDown
};

typedef struct ToolBarStyle {
    BOOL showSaveBtn;
    BOOL showExtraBtn;
    ToolBarPosition toolBarPosition;
}ToolBarStyle;

@interface PhotoToolBar : UIView

@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *extraBtn;
@property (nonatomic, strong) UILabel *indexLabel;

- (instancetype)initWithFrame:(CGRect)frame toolBarStyle:(ToolBarStyle)toolBarStyle;

@end
