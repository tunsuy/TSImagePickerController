//
//  PhotoBrowserViewController.m
//  TSImagePickerController
//
//  Created by tunsuy on 30/5/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "PhotoBrowser.h"
#import "PhotoModel.h"
#import "PhotoToolBar.h"
#import "PhotoViewCell.h"

static NSString *const collectionViewCellID = @"collectionViewCellID";

@interface PhotoBrowser ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, copy) NSArray<PhotoModel *> *photoModels;
@property (nonatomic, strong) PhotoToolBar *toolBar;

@property (nonatomic) NSInteger currentIndex;

@property (nonatomic, strong) UIViewController *parentVC;

@end

@implementation PhotoBrowser

@synthesize currentIndex;

- (instancetype)initWithPhotoModels:(NSArray<PhotoModel *> *)photoModels toolBar:(PhotoToolBar *)toolBar {
    if (self = [super init]) {
        self.photoModels = photoModels;
        self.toolBar = toolBar;
        
        [self.view addSubview:self.collectionView];
        [self.view addSubview:self.toolBar];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    currentIndex = -1;
    
    [self addObserver:self forKeyPath:@"currentIndex" options:NSKeyValueObservingOptionNew context:nil];
    
}

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupFrame];
    [self animateZoomIn];
}

#pragma mark - private method
- (void)setupFrame {
    
}

- (void)animateZoomIn {
    PhotoModel *currentModel = self.photoModels[currentIndex];
    UIImageView *sourceImageView = [self getCurrentSourceImageView:currentIndex];
    if (sourceImageView) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        CGRect beginFrame = [window convertRect:sourceImageView.frame fromView:sourceImageView];
        UIView *sourceViewSnap = [self snapView:sourceImageView];
        sourceViewSnap.frame = beginFrame;
        
        CGRect endFrame = CGRectZero;
        UIImage *localImage = currentModel.localImage;
        if (localImage) {
            CGFloat width = localImage.size.width < self.view.bounds.size.width ? localImage.size.width :self.view.bounds.size.width;
            CGFloat height = localImage.size.height *(width / localImage.size.width);
            
            if (height > self.view.bounds.size.height) {
                endFrame = CGRectMake(0, 0, width, height);
            }
            else {
                endFrame = CGRectMake((self.view.bounds.size.width-width)/2, (self.view.bounds.size.height-height)/2, width, height);
            }
        }
        else {
            UIImage *placeholderImage = sourceImageView.image;
            if (placeholderImage) {
                CGFloat width = placeholderImage.size.width < self.view.bounds.size.width ? placeholderImage.size.width : self.view.bounds.size.width;
                CGFloat height = placeholderImage.size.height * (width/placeholderImage.size.width);
                if (height > self.view.bounds.size.height) {
                    endFrame = CGRectMake(0, 0, width, height);
                }
                else {
                    endFrame = CGRectMake((self.view.bounds.size.width-width)/2, (self.view.bounds.size.height-height)/2, width, height);
                }
            }
        }
        [window addSubview:sourceViewSnap];
        self.view.alpha = 1.0;
        self.collectionView.hidden = YES;
        self.toolBar.hidden = YES;
        
        if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(photoBrowserWillDisplay:)]) {
            [self.photoBrowserDelegate photoBrowserWillDisplay:currentIndex];
        }
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             sourceViewSnap.frame = endFrame;
                         }
                         completion:^(BOOL finished){
                             [sourceViewSnap removeFromSuperview];
                             weakself.collectionView.hidden = NO;
                             weakself.toolBar.hidden = NO;
                         }];
    }
    else {
        self.view.alpha = 0.0;
        
        if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(photoBrowserWillDisplay:)]) {
            [self.photoBrowserDelegate photoBrowserWillDisplay:currentIndex];
        }
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             weakself.view.alpha = 1.0;
                         }
                         completion:nil];
    }
}

- (void)animateZoomOut {

    UIImageView *sourceImageView = [self getCurrentSourceImageView:currentIndex];
    if (sourceImageView) {
        PhotoViewCell *currentCell = (PhotoViewCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
        UIView *currentImageView;
        
        if (currentCell.imageView.bounds.size.height > self.view.bounds.size.height) {
            currentImageView = currentCell.contentView;
        }
        else {
            currentImageView = currentCell.imageView;
        }
        
        UIView *currentImageSnap = [self snapView:currentImageView];
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:currentImageSnap];
        
        currentImageSnap.frame = currentImageView.frame;
        
        CGRect endFrame = [sourceImageView convertRect:sourceImageView.frame toView:window];
        
        if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(photoBrowserWillEndDisplay:)]) {
            [self.photoBrowserDelegate photoBrowserWillEndDisplay:currentIndex];
        }
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             currentImageSnap.frame = endFrame;
                             weakself.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (weakself.photoBrowserDelegate && [weakself.photoBrowserDelegate respondsToSelector:@selector(photoBrowserDidEndDisplay:)]) {
                                 [weakself.photoBrowserDelegate photoBrowserDidEndDisplay:currentIndex];
                             }
                             [currentImageSnap removeFromSuperview];
                             
                             [self willMoveToParentViewController:nil];
                             [self.view removeFromSuperview];
                             [self removeFromParentViewController];
                         }];
        
    }
    else {
        
        if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(photoBrowserWillDisplay:)]) {
            [self.photoBrowserDelegate photoBrowserWillDisplay:currentIndex];
        }
        
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.5
                         animations:^{
                             weakself.view.alpha = 0.0;
                         }
                         completion:^(BOOL finished){
                             if (weakself.photoBrowserDelegate && [weakself.photoBrowserDelegate respondsToSelector:@selector(photoBrowserDidEndDisplay:)]) {
                                 [weakself.photoBrowserDelegate photoBrowserDidEndDisplay:currentIndex];
                             }
                             [self willMoveToParentViewController:nil];
                             [self.view removeFromSuperview];
                             [self removeFromParentViewController];
                         }];
    }
}

- (UIImageView *)getCurrentSourceImageView:(NSUInteger)index {
    PhotoModel *currentModel = self.photoModels[index];
    if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(sourceImageViewForCurrentIndex:)]) {
        return [self.photoBrowserDelegate sourceImageViewForCurrentIndex:index];
    }
    else {
        return currentModel.sourceImageView;
    }
    return nil;
}

- (UIView *)snapView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

- (void)showInVC:(UIViewController *)parentVC beginPage:(NSInteger)beginPage {
    self.currentIndex = beginPage;
    self.parentVC = parentVC;
    self.view.frame = [UIScreen mainScreen].bounds;
    [self.parentVC.view addSubview:self.view];
    [self.parentVC addChildViewController:self];
    [self didMoveToParentViewController:self.parentVC];
}

- (void)currentPageIndex:(NSInteger)currentPageIndex animated:(BOOL)animated {
    NSAssert(currentPageIndex >=0 && currentPageIndex < [self.photoModels count], @"设置的下标有误");
    if (currentPageIndex < 0 || currentPageIndex >= [self.photoModels count]) {
        return;
    }
    self.currentIndex = currentPageIndex;
    [self.collectionView setContentOffset:CGPointMake(currentPageIndex * self.collectionView.bounds.size.width, 0) animated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"currentIndex"]) {
        NSInteger oldValue = [[change objectForKey:@"old"] integerValue];
        NSInteger newValue = [[change objectForKey:@"new"] integerValue];
        if (oldValue == newValue) {
            return;
        }
        self.toolBar.indexLabel.text = [NSString stringWithFormat:@"%lu",(newValue+1)/[self.photoModels count]];
        
        if (self.photoBrowserDelegate && [self.photoBrowserDelegate respondsToSelector:@selector(photoBrowserDidDisplayPage:totalPages:)]) {
            [self.photoBrowserDelegate photoBrowserDidDisplayPage:newValue totalPages:[self.photoModels count]];
        }
    }
}

#pragma mark - getter or setter
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(self.view.bounds.size.width+self.contentMargin, self.view.bounds.size.height);
        _flowLayout.minimumLineSpacing = 0.0;
        _flowLayout.minimumInteritemSpacing = 0.0;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+self.contentMargin, self.view.bounds.size.height) collectionViewLayout:self.flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[self class] forCellWithReuseIdentifier:collectionViewCellID];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.showsHorizontalScrollIndicator = false;
    }
    return _collectionView;
}

- (PhotoToolBar *)toolBar {
    if (!_toolBar) {
        ToolBarStyle toolBarStyle = {YES, YES, ToolBarPositionDown};
        _toolBar = [[PhotoToolBar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44.0, self.view.bounds.size.width, 44.0) toolBarStyle:toolBarStyle];
        _toolBar.backgroundColor = [UIColor clearColor];
    }
    return _toolBar;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoModels count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"photoViewCell";
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell resetUI];
    
    PhotoModel *currentModel = self.photoModels[indexPath.row];
    currentModel.sourceImageView = [self getCurrentSourceImageView:indexPath.row];
    cell.photoModel = currentModel;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
}

- (void)singleTapAnimateZoomOut {
    [self animateZoomOut];
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
