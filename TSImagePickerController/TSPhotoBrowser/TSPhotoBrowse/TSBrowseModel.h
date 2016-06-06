//
//  TSBrowseModel.h
//  TSImagePickerController
//
//  Created by tunsuy on 3/6/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSBrowseModel : NSObject

@property (nonatomic, copy) NSString *bigImageUrl; //加载网络大图url地址

/** 加载本地图片（下面三个属性传一个即可） */
@property (nonatomic, copy) NSString *bigImageLocalPath; //本地图片路径
@property (nonatomic, strong) NSData *bigImageData;
@property (nonatomic, strong) UIImage *bigImage;

@property (nonatomic,strong) UIImageView *smallImageView;

@end
