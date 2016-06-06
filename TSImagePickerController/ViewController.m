//
//  ViewController.m
//  TSImagePickerController
//
//  Created by tunsuy on 30/4/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ViewController.h"
#import "TSPhotoListCollectionViewCell.h"
#import "TSSDWebImageOperator.h"
#import "TSBrowseModel.h"
#import "TSBrowseNetworkViewController.h"
#import "TSBrowseLocalViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// 照片原图路径
#define KOriginalPhotoImagePath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"OriginalPhotoImages"]

// 视频URL路径
#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"VideoURL"]

// caches路径
#define KCachesPath   \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *smallImageUrlArray;
@property (nonatomic, strong) NSMutableArray *bigImageUrlArray;

@property (nonatomic, strong) NSMutableArray *photoGroupArrays;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    self.smallImageUrlArray = [[NSMutableArray alloc] init];
    self.bigImageUrlArray = [[NSMutableArray alloc] init];
    self.photoGroupArrays = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *clearDataBtn = [[UIBarButtonItem alloc] initWithTitle:@"清空缓存" style:UIBarButtonItemStylePlain target:self action:@selector(clearDataBtnClick:)];
    UIBarButtonItem *netImageBtn = [[UIBarButtonItem alloc] initWithTitle:@"网络图片" style:UIBarButtonItemStylePlain target:self action:@selector(netImageBtnClick:)];
    UIBarButtonItem *localImageBtn = [[UIBarButtonItem alloc] initWithTitle:@"本地图片" style:UIBarButtonItemStylePlain target:self action:@selector(localImageBtnClick:)];
    self.navigationItem.leftBarButtonItem = clearDataBtn;
    self.navigationItem.rightBarButtonItems = @[netImageBtn, localImageBtn];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.minimumLineSpacing = 10;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, TS_SCREEN_WIDTH, TS_SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[TSPhotoListCollectionViewCell class] forCellWithReuseIdentifier:@"TSPhotoListCollectionViewCell"];
    [self.view addSubview:_collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.smallImageUrlArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TSPhotoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TSPhotoListCollectionViewCell" forIndexPath:indexPath];
    if (cell) {
        
//        加载网络图片
//        [TSSDWebImageOperator setImageForImageView:cell.imageView WithURL:[NSURL URLWithString:_smallImageUrlArray[indexPath.row]]];
        
//        加载本地图片
        cell.imageView.image = self.smallImageUrlArray[indexPath.row];
        
        cell.imageView.tag = indexPath.row + 100;
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 加载网络图片
//    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
//    for(NSInteger i = 0;i < [_smallImageUrlArray count];i++)
//    {
//        UIImageView *imageView = [self.view viewWithTag:i + 100];
//        TSBrowseModel *browseItem = [[TSBrowseModel alloc]init];
//        browseItem.bigImageUrl = _bigImageUrlArray[i];// 加载网络图片大图地址
//        browseItem.smallImageView = imageView;// 小图
//        [browseItemArray addObject:browseItem];
//    }
//    TSPhotoListCollectionViewCell *cell = (TSPhotoListCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
//    TSBrowseNetworkViewController *bvc = [[TSBrowseNetworkViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
//    //    bvc.isEqualRatio = NO;// 大图小图不等比时需要设置这个属性（建议等比）
//    [bvc showBrowseViewController];
    
        // 加载本地图片
        NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
        for(NSInteger i = 0;i < [_smallImageUrlArray count];i++)
        {
            UIImageView *imageView = [self.view viewWithTag:i + 100];
            TSBrowseModel *browseItem = [[TSBrowseModel alloc]init];
    //        browseItem.bigImageLocalPath 建议传本地图片的路径来减少内存使用
            browseItem.bigImage = self.bigImageUrlArray[i];// 大图赋值
            browseItem.smallImageView = imageView;// 小图
            [browseItemArray addObject:browseItem];
        }
        TSPhotoListCollectionViewCell *cell = (TSPhotoListCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
        TSBrowseLocalViewController *bvc = [[TSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:cell.imageView.tag - 100];
        [bvc showBrowseViewController];
}


- (void)clearDataBtnClick:(UIBarButtonItem *)sender {
    [TSSDWebImageOperator clearMemory];
    [TSSDWebImageOperator clearDiskOnCompletion:^{
        [self.collectionView reloadData];
    }];
}

- (void)netImageBtnClick:(UIBarButtonItem *)sender {
    [self initNetworkImagesData];
    [self.collectionView reloadData];
}

- (void)localImageBtnClick:(UIBarButtonItem *)sender {
    [self initLocalImageData];
    [self.collectionView reloadData];
}

- (void)initNetworkImagesData {
    NSArray *smallImageUrlArr = @[@"http://7xjtvh.com1.z0.glb.clouddn.com/browse01_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse02_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse03_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse04_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse05_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse06_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse07_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse08_s.jpg",
                       @"http://7xjtvh.com1.z0.glb.clouddn.com/browse09_s.jpg"];
    
    NSArray *bigImageUrlArr = @[@"http://7xjtvh.com1.z0.glb.clouddn.com/browse01.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse02.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse03.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse04.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse05.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse06.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse07.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse08.jpg",
                          @"http://7xjtvh.com1.z0.glb.clouddn.com/browse09.jpg"];
    
    [self.smallImageUrlArray removeAllObjects];
    [self.smallImageUrlArray addObjectsFromArray:smallImageUrlArr];
    
    [self.bigImageUrlArray removeAllObjects];
    [self.bigImageUrlArray addObjectsFromArray:bigImageUrlArr];
}

- (void)initLocalImageData {
    [self.smallImageUrlArray removeAllObjects];
    [self.bigImageUrlArray removeAllObjects];
    
    __block CGFloat maxVisibleHeight = 0.0;
    
    __weak typeof(self) weakself = self;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [weakself.photoGroupArrays addObject:group];
            } else {
                [weakself.photoGroupArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [obj enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                        if ([result thumbnail] != nil) {
                            // 照片
                            if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]){
                                
                                UIImage *image = [UIImage imageWithCGImage:[result thumbnail]];
                                UIImage *fullScreenImage = [UIImage imageWithCGImage:[[result defaultRepresentation] fullScreenImage]];
                                
                                if ((idx + 1) % 3 == 0) {
                                    maxVisibleHeight += [[result defaultRepresentation] dimensions].height;
                                }
                                if (maxVisibleHeight > TS_SCREEN_HEIGHT) {
                                    *stop = YES;
                                }
                                
                                [self.smallImageUrlArray addObject:image];
                                [self.bigImageUrlArray addObject:fullScreenImage];
                                
                            }
                            // 视频
                            else if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo] ){
                                
                                // 和图片方法类似
                            }
                        }
                    }];
                }];
                
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
        {
            
            NSString *errorMessage = nil;
            
            switch ([error code]) {
                case ALAssetsLibraryAccessUserDeniedError:
                case ALAssetsLibraryAccessGloballyDeniedError:
                    errorMessage = @"用户拒绝访问相册,请在<隐私>中开启";
                    break;
                    
                default:
                    errorMessage = @"Reason unknown.";
                    break;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"错误,无法访问!"
                                                                   message:errorMessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil, nil];
                [alertView show];
            });
        };
        
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc]  init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                     usingBlock:listGroupBlock failureBlock:failureBlock];
//    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
