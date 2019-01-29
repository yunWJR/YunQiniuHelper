//
// Created by yun on 2019-01-22.
// Copyright (c) 2019 skkj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Qiniu/QiniuSDK.h>
#import <CoreGraphics/CoreGraphics.h>

@class YunQiniuFileModel;

@interface YunQiniuUploadHelper : NSObject

+ (void)uploadFile:(id)file
           fileKey:(NSString *)fileKey
          progress:(QNUpProgressHandler)progress
           success:(void (^)(YunQiniuFileModel *file))success
           failure:(void (^)(NSError *err))failure;

/// file 为 NSData 或 UIImage
+ (void)uploadFile:(id)file
          progress:(QNUpProgressHandler)progress
           success:(void (^)(YunQiniuFileModel *file))success
           failure:(void (^)(NSError *err))failure;

+ (void)uploadFiles:(NSArray *)files
           fileKeys:(NSArray<NSString *> *)fileKeys
           progress:(void (^)(CGFloat))progress
            success:(void (^)(NSArray<YunQiniuFileModel *> *files))success
            failure:(void (^)(NSError *err))failure;

/// file 为 NSData 或 UIImage
+ (void)uploadFiles:(NSArray *)files
           progress:(void (^)(CGFloat))progress
            success:(void (^)(NSArray<YunQiniuFileModel *> *files))success
            failure:(void (^)(NSError *err))failure;

@end