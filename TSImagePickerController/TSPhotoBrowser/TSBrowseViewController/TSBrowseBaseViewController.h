//
//  TSBrowseBaseViewController.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSBrowseModel.h"
#import "TSBrowseCollectionViewCell.h"

@interface TSBrowseBaseViewController : UIViewController

@property (nonatomic) BOOL equalRatio; //大小图是否等比（默认等比）

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) BOOL firstOpen;
@property (nonatomic) CGFloat screenWidth;
@property (nonatomic) CGFloat screenHeight;

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex;
- (void)showBrowseViewController;

/** 子类需要重写该方法 */
- (void)loadBrowseImageWithBrowseItem:(TSBrowseModel *)browseItem cell:(TSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect;

- (void)showBrowseRemindViewWithText:(NSString *)text;
- (CGRect)getFrameInWindow:(UIView *)view; //获取指定视图在window中的位置

@end
