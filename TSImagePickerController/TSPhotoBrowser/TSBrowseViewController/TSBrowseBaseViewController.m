//
//  TSBrowseBaseViewController.m
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "TSBrowseBaseViewController.h"
#import "TSBrowseActionSheet.h"
#import "TSBrowseRemindView.h"
#import "TSSDWebImageOperator.h"

static NSString *cellReuseIdentifier = @"TSBrowseCell";

@interface TSBrowseBaseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSArray *browseItemArray;
@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) BOOL isRotate; //是否切换横竖屏
@property (nonatomic, strong) UILabel *countLabel; //当前图片位置
@property (nonatomic, strong) UIView *snapshotView;
@property (nonatomic, strong) NSMutableArray *verticalBigRectArray;
@property (nonatomic, strong) NSMutableArray *horizontalBigRectArray;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic) UIDeviceOrientation currentOrientation;
@property (nonatomic, strong) TSBrowseActionSheet *browseActionSheet;
@property (nonatomic, strong) TSBrowseRemindView *browseRemindView;

@property (nonatomic, copy) NSArray *actionSheetTitleArray;
@property (nonatomic, copy) NSString *actionSheetCancelTitle;

@end

@implementation TSBrowseBaseViewController

- (instancetype)initWithBrowseItemArray:(NSArray *)browseItemArray currentIndex:(NSInteger)currentIndex {
    if (self = [super init]) {
        self.browseItemArray = browseItemArray;
        self.currentIndex = currentIndex;
        
        self.equalRatio = YES;
        self.firstOpen = YES;
        
        self.screenWidth = TS_SCREEN_WIDTH;
        self.screenHeight = TS_SCREEN_HEIGHT;
        
        self.currentOrientation = UIDeviceOrientationPortrait;
        
        self.verticalBigRectArray = [[NSMutableArray alloc] init];
        self.horizontalBigRectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initData];
    [self generateBrowseView];
    
}

- (void)initData {
    for (TSBrowseModel *browseItem in self.browseItemArray) {
        CGRect verticalRect = CGRectZero;
        CGRect horizontalRect = CGRectZero;
        
        if (self.equalRatio) {
            if (browseItem.smallImageView) {
                verticalRect = [browseItem.smallImageView.image ts_getBigImageRectWithScreenWidth:TS_SCREEN_WIDTH screenHeight:TS_SCREEN_HEIGHT];
                horizontalRect = [browseItem.smallImageView.image ts_getBigImageRectWithScreenWidth:TS_SCREEN_HEIGHT screenHeight:TS_SCREEN_WIDTH];
            }
        }
        
        NSValue *verticalValue = [NSValue valueWithCGRect:verticalRect];
        [self.verticalBigRectArray addObject:verticalValue];
        NSValue *horizontalValue = [NSValue valueWithCGRect:horizontalRect];
        [self.horizontalBigRectArray addObject:horizontalValue];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    /** browseActionSheet UIData init */
    _actionSheetTitleArray = @[@"保存图片", @"复制图片地址"];
    _actionSheetCancelTitle = @"取消";
}

- (void)generateBrowseView {
    if (self.snapshotView) {
        self.snapshotView.hidden  =YES;
        [self.view addSubview:self.snapshotView];
    }
    
    _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    _bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgView];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _screenWidth+kBrowseSpace, _screenHeight) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[TSBrowseCollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    _collectionView.contentOffset = CGPointMake(_currentIndex * (_screenWidth + kBrowseSpace), 0);
    [_bgView addSubview:_collectionView];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.textColor  =[UIColor whiteColor];
    _countLabel.frame = CGRectMake(0, _screenHeight - 50, _screenWidth, 50);
    _countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)_currentIndex+1, (long)_browseItemArray.count];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_bgView addSubview:_countLabel];
    
    _browseRemindView = [[TSBrowseRemindView alloc] initWithFrame:_bgView.bounds];
    [_bgView addSubview:_browseRemindView];
}

#pragma mark - UIColectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TSBrowseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (!cell) {
        return nil;
    }
    TSBrowseModel *browseItem = [self.browseItemArray objectAtIndex:indexPath.row];
    cell.zoomScrollView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
    cell.zoomScrollView.zoomScale = 1.0f;
    cell.zoomScrollView.contentSize = CGSizeMake(self.screenWidth, self.screenHeight);
    cell.zoomScrollView.zoomImageView.contentMode = browseItem.smallImageView.contentMode;
    cell.zoomScrollView.zoomImageView.clipsToBounds = browseItem.smallImageView.clipsToBounds;
    [cell.loadingView ts_setFrameInSuperViewCenterWithSize:CGSizeMake(30, 30)];
    CGRect bigImageRect = [self.verticalBigRectArray[indexPath.row] CGRectValue];
    if (self.currentOrientation != UIDeviceOrientationPortrait) {
        bigImageRect = [self.horizontalBigRectArray[indexPath.row] CGRectValue];
    }
    [self loadBrowseImageWithBrowseItem:browseItem cell:cell bigImageRect:bigImageRect];
    
    __weak typeof(self) weakself = self;
    [cell tapClick:^(TSBrowseCollectionViewCell *browseCell) {
        __strong typeof(weakself) strongself = weakself;
        [strongself tap:browseCell];
    }];
    [cell longPress:^(TSBrowseCollectionViewCell *browseCell) {
        __strong typeof(weakself) strongself = weakself;
        if ([TSSDWebImageOperator diskImageExistsWithKey:browseItem.bigImageUrl]) {
            [strongself longPress:browseCell];
        }
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.browseItemArray count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.screenWidth + kBrowseSpace, self.screenHeight);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!self.isRotate) {
        self.currentIndex = scrollView.contentOffset.x / (self.screenWidth + kBrowseSpace);
        self.countLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)(self.currentIndex + 1), (long)[self.browseItemArray count]];
    }
    self.isRotate = NO;
}

#pragma mark - private method
#pragma mark - touch event
- (void)tap:(TSBrowseCollectionViewCell *)browseCell {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    if (self.snapshotView) {
        self.snapshotView.hidden = NO;
    }
    else {
        self.view.backgroundColor = [UIColor clearColor];
    }
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.userInteractionEnabled = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSArray *visibleCellArray = self.collectionView.visibleCells;
    for (TSBrowseCollectionViewCell *cell in visibleCellArray) {
        [cell.loadingView stopAnimation];
    }
    [self.countLabel removeFromSuperview];
    self.countLabel = nil;
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:browseCell];
    browseCell.zoomScrollView.zoomScale = 1.0f;
    TSBrowseModel *browseItem = self.browseItemArray[indexPath.row];
    
    if (browseItem.smallImageView) {
        CGRect rect = [self getFrameInWindow:browseItem.smallImageView];
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        if (self.currentOrientation == UIDeviceOrientationLandscapeLeft) {
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            rect = CGRectMake(rect.origin.y, TS_SCREEN_WIDTH -rect.size.width - rect.origin.x, rect.size.height, rect.size.width);
        }
        else if (self.currentOrientation == UIDeviceOrientationLandscapeRight) {
            transform = CGAffineTransformMakeRotation(M_PI_2);
            rect = CGRectMake(TS_SCREEN_HEIGHT - rect.size.height - rect.origin.y, rect.origin.x, rect.size.height, rect.size.width);
        }
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             browseCell.zoomScrollView.zoomImageView.transform = transform;
                             browseCell.zoomScrollView.zoomImageView.frame = rect;
                         }
                         completion:^(BOOL finished){
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }];
    }
    else {
        [UIView animateWithDuration:0.1
                         animations:^{
                             self.view.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [self dismissViewControllerAnimated:NO completion:nil];
                         }];
    }
}

- (void)longPress:(TSBrowseCollectionViewCell *)browseCell {
    [self.browseActionSheet removeFromSuperview];
    self.browseActionSheet = nil;
    
    __weak typeof(self) weakself = self;
    self.browseActionSheet = [[TSBrowseActionSheet alloc] initWithTitleArray:self.actionSheetTitleArray
                                                           cancelButtonTitle:self.actionSheetCancelTitle
                                                            didSelectedBlock:^(NSInteger index) {
                                                                __strong typeof(weakself) strongself = weakself;
                                                                [strongself browseActionSheetDidSelectedAtIndex:index currentCell:browseCell];
                                                            }];
    [self.browseActionSheet showInView:self.bgView];
}

- (void)browseActionSheetDidSelectedAtIndex:(NSInteger)index currentCell:(TSBrowseCollectionViewCell *)currentCell {
    if (index == 0) {
        UIImageWriteToSavedPhotosAlbum(currentCell.zoomScrollView.zoomImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else if (index == 1) {
        TSBrowseModel *currentBrowseItem = self.browseItemArray[self.currentIndex];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = currentBrowseItem.bigImageUrl;
        [self showBrowseRemindViewWithText:@"复制图片地址成功"];
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *text = nil;
    if (error) {
        text = @"保存图片失败";
    }
    else {
        text = @"保存图片成功";
    }
    [self showBrowseRemindViewWithText:text];
}

#pragma mark - statusBar method
- (BOOL)prefersStatusBarHidden {
    if (!self.collectionView.userInteractionEnabled) {
        return NO;
    }
    return YES;
}

#pragma mark - deviceOrientationDidChange notification
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        self.isRotate = YES;
        self.currentOrientation = orientation;
        if (self.currentOrientation == UIDeviceOrientationPortrait) {
            self.screenWidth = TS_SCREEN_WIDTH;
            self.screenHeight = TS_SCREEN_HEIGHT;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.bgView.transform = CGAffineTransformMakeRotation(0);
                             }];
        }
        else{
            self.screenWidth = TS_SCREEN_HEIGHT;
            self.screenHeight = TS_SCREEN_WIDTH;
            if (self.currentOrientation == UIDeviceOrientationLandscapeLeft) {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     self.bgView.transform = CGAffineTransformMakeRotation(M_PI_2);
                                 }];
            }
            else {
                [UIView animateWithDuration:0.5
                                 animations:^{
                                     self.bgView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                                 }];
            }
        }
        self.bgView.frame = CGRectMake(0, 0, TS_SCREEN_WIDTH, TS_SCREEN_HEIGHT);
        self.browseRemindView.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight);
        if (self.browseActionSheet) {
            [self.browseActionSheet updateFrame];
        }
        self.countLabel.frame = CGRectMake(0, self.screenHeight - 50, self.screenWidth, 50);
        [self.collectionView.collectionViewLayout invalidateLayout];
        self.collectionView.frame = CGRectMake(0, 0, self.screenWidth + kBrowseSpace, self.screenHeight);
        self.collectionView.contentOffset = CGPointMake((self.screenWidth + kBrowseSpace) * self.currentIndex, 0);
        [self.collectionView reloadData];
    }
}

#pragma mark - public method
//子类重写该方法
- (void)loadBrowseImageWithBrowseItem:(TSBrowseModel *)browseItem cell:(TSBrowseCollectionViewCell *)cell bigImageRect:(CGRect)bigImageRect {
    
}

- (CGRect)getFrameInWindow:(UIView *)view {
    return [view.superview convertRect:view.frame toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)showBrowseViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else {
        self.snapshotView = [rootViewController.view snapshotViewAfterScreenUpdates:NO];
    }
    [rootViewController presentViewController:self animated:NO completion:nil];
}

- (void)showBrowseRemindViewWithText:(NSString *)text {
    [self.browseRemindView showRemindViewWithText:text];
    self.bgView.userInteractionEnabled = NO;
    [self performSelector:@selector(hideRemindView) withObject:nil afterDelay:0.7];
}

- (void)hideRemindView {
    [self.browseRemindView hideRemindView];
    self.bgView.userInteractionEnabled = YES;
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
