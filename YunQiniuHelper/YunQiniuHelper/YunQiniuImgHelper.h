//
// Created by yun on 2017/8/14.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunQiniuDefine.h"

@interface YunQiniuImgHelper : NSObject <YunQiniuUploadImageDelegate>

+ (YunQiniuImgHelper *)instance;

- (void)setDelegate:(id)tg
__deprecated_msg("已过期, 请使用YunQiniuUploadHelper");

// item =image/data(image)
- (void)uploadImages:(NSArray *)imgList
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure
__deprecated_msg("已过期, 请使用YunQiniuUploadHelper");

// item =image/data(image)
- (void)uploadImages:(NSArray *)imgList
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure
__deprecated_msg("已过期, 请使用YunQiniuUploadHelper");

// 需要实现
- (void)getQnPara:(getQnParaBlock)rst
__deprecated_msg("已过期, 请使用YunQiniuUploadHelper");

@end