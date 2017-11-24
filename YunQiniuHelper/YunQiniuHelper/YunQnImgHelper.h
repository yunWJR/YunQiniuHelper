//
// Created by yun on 2017/8/14.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YunErrorHelper;
@class YunImgData;

@interface YunQnImgHelper : NSObject

+ (YunQnImgHelper *)instance;

- (void)uploadImages:(NSArray<UIImage *> *)imageArray
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray<NSString *> *))success
             failure:(void (^)(void))failure;

- (void)upImgDataList:(NSArray<YunImgData *> *)imgDataList
              success:(void (^)(NSArray *urlStrList))success
              failure:(void (^)(YunErrorHelper *error))failure;

- (void)upImgList:(NSArray<UIImage *> *)imgList
          success:(void (^)(NSArray *urlStrList))success
          failure:(void (^)(YunErrorHelper *error))failure;

- (void)getQnPara:(void (^)(BOOL suc, NSString *token, NSString *cdnUrl))rst;

@end
