//
// Created by 王健 on 16/5/13.
// Copyright (c) 2016 成都晟堃科技有限责任公司. All rights reserved.
//

#import "YunQiniuUploadData.h"
#import "YunQiniuUploadImageTool.h"
#import "QNResolver.h"
#import "QNDnsManager.h"
#import "QNNetworkInfo.h"
#import "YunQiniuDefine.h"

@implementation YunQiniuUploadImageTool

+ (void)setDelegate:(id)tg {
    YunQiniuUploadData.instance.delegate = tg;
}

+ (void)getQnPara:(getQnParaBlock)rst {
    if (YunQiniuUploadData.instance.delegate &&
        [YunQiniuUploadData.instance.delegate respondsToSelector:@selector(getQnPara:)]) {
        [YunQiniuUploadData.instance.delegate getQnPara:rst];
    }
    else {
        rst(NO, nil, nil);
    }
}

// 上传单张图片
+ (void)uploadImage:(UIImage *)image
           progress:(QNUpProgressHandler)progress
            success:(void (^)(NSString *url))success
            failure:(void (^)(NSError *err))failure {
    [self getQnPara:^(BOOL suc, NSString *token, NSString *cdnUrl) {
        if (!suc) {
            if (failure) {failure([self errWithType:QqHlpErr_errQnPara]);}
        }

        // 压缩
        NSData *data = UIImageJPEGRepresentation(image, YunQiniuUploadData.instance.cmpFactor);

        if (!data) {
            if (failure) {failure([self errWithType:QqHlpErr_errImg]);}

            return;
        }

        QNConfiguration *cfg = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            NSMutableArray *paras = [[NSMutableArray alloc] init];
            [paras addObject:[QNResolver systemResolver]];

            QNDnsManager *dns = [[QNDnsManager alloc] init:paras networkInfo:[QNNetworkInfo normal]];

            // 是否选择  https  上传
            builder.zone = [[QNAutoZone alloc] initWithDns:dns];

            //设置断点续传
            NSError *error;
            builder.recorder = [QNFileRecorder fileRecorderWithFolder:@"QnImgDic" error:&error];
        }];

        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:progress
                                                            params:nil
                                                          checkCrc:NO
                                                cancellationSignal:nil];
        QNUploadManager *upMg = [QNUploadManager sharedInstanceWithConfiguration:cfg];
        [upMg putData:data
                  key:nil
                token:token
             complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                 if (info.statusCode == 200 && resp) {
                     if (success) {
                         success([self getImgUrl:resp baseUrl:cdnUrl]);
                     }
                 }
                 else {
                     if (failure) {failure(info.error);}
                 }
             } option:opt];
    }];
}

//上传多张图片
+ (void)uploadImages:(NSArray<UIImage *> *)imageList
            progress:(void (^)(CGFloat))progress
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure {
    if (imageList == nil || imageList.count == 0) {
        if (success) {success(nil);}
        return;
    }

    NSMutableArray *listUrl = [[NSMutableArray alloc] init];

    __block CGFloat totalPrgs = 0.0f;
    __block CGFloat partPrgs = 1.0f / [imageList count];
    __block NSUInteger curIndex = 0;

    YunQiniuUploadData *upHlp = [YunQiniuUploadData instance];
    __weak typeof(upHlp) weakHlp = upHlp;
    upHlp.failureBlock = ^(NSError *err) {
        if (failure) {failure(err);}
        return;
    };

    upHlp.sucBlock = ^(NSString *url) {
        [listUrl addObject:url];
        curIndex++;

        totalPrgs += partPrgs;
        if (progress) {
            progress(totalPrgs);
        }

        if ([listUrl count] == [imageList count]) {
            success([listUrl copy]);
            return;
        }
        else {
            [YunQiniuUploadImageTool uploadImage:imageList[curIndex]
                                        progress:nil
                                         success:weakHlp.sucBlock
                                         failure:weakHlp.failureBlock];
        }
    };

    [YunQiniuUploadImageTool uploadImage:imageList[0]
                                progress:nil
                                 success:weakHlp.sucBlock
                                 failure:weakHlp.failureBlock];
}

+ (void)uploadImages:(NSArray<UIImage *> *)imageList
            progress:(void (^)(CGFloat))progress
                  tg:(id)tg
             success:(void (^)(NSArray<NSString *> *urlList))success
             failure:(void (^)(NSError *err))failure {
    [self setDelegate:tg];

    [self uploadImages:imageList
              progress:progress
               success:success
               failure:failure];
}

+ (NSString *)getImgUrl:(NSDictionary *)resp baseUrl:(NSString *)baseUrl {
    NSString *url = resp[@"url"];

    return url;
}

+ (NSError *)errWithType:(QiNiuHelperError)type {
    return [NSError errorWithDomain:@"QiNiuHelper"
                               code:type
                           userInfo:nil];
}

@end