//
// Created by yun on 2017/8/14.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunQiniuDefine.h"

@interface YunQiniuImgHelper : NSObject

+ (YunQiniuImgHelper *)instance;

- (void)setDelegate:(id)tg;

- (void)uploadImages:(NSArray<UIImage *> *)imgList
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure;

- (void)uploadImages:(NSArray<UIImage *> *)imgList
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure;

@end
