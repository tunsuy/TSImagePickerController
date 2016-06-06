//
//  TSBrowseActionSheet.h
//  TSImagePickerController
//
//  Created by tunsuy on 2/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TSBrowseActionSheetDidSelectedAtIndexBlock)(NSInteger index);

@interface TSBrowseActionSheet : UIView

- (instancetype)initWithTitleArray:(NSArray *)titleArray
                 cancelButtonTitle:(NSString *)cancelTitle
                  didSelectedBlock:(TSBrowseActionSheetDidSelectedAtIndexBlock)selectedBlock;

- (void)showInView:(UIView *)view;

/** transform时更新frame */
- (void)updateFrame;

@end
