//
// Created by yun on 2017/8/14.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import "YunQnImgHelper.h"
#import "YunQiniuUploadImageTool.h"
#import "YunErrorHelper.h"
#import "BdFamilyHomeModel.h"
#import "YunImgData.h"
#import "YunLogHelper.h"
#import <YunKits/YunGlobalDefine.h>
#import <YunImgView/YunImgData.h>

@interface YunQnImgHelper () <QnUploadImageToolDelegate> {
}

@end

@implementation YunQnImgHelper

+ (YunQnImgHelper *)instance {
    static YunQnImgHelper *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)uploadImages:(NSArray<UIImage *> *)imageArray
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray<NSString *> *))success
             failure:(void (^)(void))failure {
    [YunQiniuUploadImageTool uploadImages:imageArray
                           progress:progress
                            success:success
                            failure:failure];
}

- (void)upImgDataList:(NSArray<YunImgData *> *)imgDataList
              success:(void (^)(NSArray *urlStrList))success
              failure:(void (^)(YunErrorHelper *error))failure {
    // 帅选出不需要上传的图片
    __block NSMutableArray *urlImgList = [NSMutableArray new];
    NSMutableArray *srcImgList = [NSMutableArray new];

    if (imgDataList) {
        for (int i = 0; i < imgDataList.count; ++i) {
            YunImgData *imgInfo = imgDataList[i];
            if (imgInfo.type == YunImgURLStr) {
                [urlImgList addObject:imgInfo.data];
            }
            else if (imgInfo.type == YunImgImage) {
                [srcImgList addObject:imgInfo.data];
            }
        }
    }

    // 上传图片
    [YunQiniuUploadImageTool uploadImages:srcImgList progress:^(CGFloat progress) {
         [YunLogHelper logMsg:FORMAT(@"qin niu --%f", progress)];
     }                      success:^(NSArray<NSString *> *array) {
         NSMutableArray *urlStrList = urlImgList;

         if (array) {
             urlStrList = [[urlStrList arrayByAddingObjectsFromArray:array] mutableCopy];
         }

         success(urlStrList);
     }
                            failure:^{
                                failure([YunErrorHelper upImgError]);
                            }];
}

- (void)upImgList:(NSArray<UIImage *> *)imgList
          success:(void (^)(NSArray *urlStrList))success
          failure:(void (^)(YunErrorHelper *error))failure {

    // 上传图片
    [YunQiniuUploadImageTool uploadImages:imgList progress:^(CGFloat progress) {
         [YunLogHelper logMsg:FORMAT(@"qin niu --%f", progress)];
     }                      success:^(NSArray<NSString *> *array) {
         success(array);
     }
                            failure:^{
                                failure([YunErrorHelper upImgError]);
                            }];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [YunQiniuUploadImageTool setDelegate:self];
    }

    return self;
}

#pragma mark - QnUploadImageToolDelegate

- (void)getQnPara:(void (^)(BOOL suc, NSString *token, NSString *cdnUrl))rst {

}

@end
