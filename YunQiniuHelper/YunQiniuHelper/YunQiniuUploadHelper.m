//
// Created by yun on 2019-01-22.
// Copyright (c) 2019 skkj. All rights reserved.
//

#import "YunQiniuUploadHelper.h"
#import "YunQiniuUploadConfig.h"
#import "QNResolver.h"
#import "YunQiniuDefine.h"
#import "YunQiniuFileModel.h"

@implementation YunQiniuUploadHelper

+ (void)getQnPara:(getQnParaBlock)rst {
    if (YunQiniuUploadConfig.instance.delegate &&
        [YunQiniuUploadConfig.instance.delegate respondsToSelector:@selector(getQnPara:)]) {
        [YunQiniuUploadConfig.instance.delegate getQnPara:rst];
    }
    else {
        rst(NO, nil, nil);
    }
}

+ (void)uploadFile:(id)file
          progress:(QNUpProgressHandler)progress
           success:(void (^)(YunQiniuFileModel *file))success
           failure:(void (^)(NSError *err))failure {
    [self getQnPara:^(BOOL suc, NSString *token, NSString *cdnUrl) {
        if (!suc) {
            if (failure) {failure([self errWithType:QqHlpErr_errQnPara]);}
        }

        // 压缩
        NSData *data = nil;
        if ([file isKindOfClass:UIImage.class]) {
            data = UIImageJPEGRepresentation(file, YunQiniuUploadConfig.instance.cmpFactor);
        }
        else if ([file isKindOfClass:NSData.class]) {
            data = file;
        }
        else {
            if (failure) {failure([self errWithType:QqHlpErr_errImg]);}

            return;
        }

        if (!data) {
            if (failure) {failure([self errWithType:QqHlpErr_errImg]);}

            return;
        }

        QNConfiguration *cfg = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
            NSMutableArray *paras = [[NSMutableArray alloc] init];
            [paras addObject:[QNResolver systemResolver]];

            //QNDnsManager *dns = [[QNDnsManager alloc] init:paras networkInfo:[QNNetworkInfo normal]];

            //builder.zone = [[QNAutoZone alloc] initWithDns:dns]; // 7.2.5 废除
            //builder.dns = dns;

            //是否选择 https 上传
            //builder.useHttps = YES;

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
                         NSString *url = [self getFileUrl:resp baseUrl:cdnUrl];
                         YunQiniuFileModel *fileData = [YunQiniuFileModel modelWithFileUrl:url
                                                                                      resp:resp
                                                                                       key:key];

                         success(fileData);
                     }
                 }
                 else {
                     if (failure) {failure(info.error);}
                 }
             } option:opt];
    }];
}

+ (void)uploadFiles:(NSArray *)files
           progress:(void (^)(CGFloat))progress
            success:(void (^)(NSArray<YunQiniuFileModel *> *files))success
            failure:(void (^)(NSError *err))failure {
    if (files == nil || files.count == 0) {
        if (success) {success(nil);}
        return;
    }

    NSMutableArray <YunQiniuFileModel *> *fileList = [[NSMutableArray alloc] init];

    __block CGFloat totalPrgs = 0.0f;
    __block CGFloat partPrgs = 1.0f / [files count];
    __block NSUInteger curIndex = 0;

    YunQiniuUploadConfig *upHlp = [YunQiniuUploadConfig instance];
    __weak typeof(upHlp) weakHlp = upHlp;
    upHlp.failureBlock = ^(NSError *err) {
        if (failure) {failure(err);}
        return;
    };

    upHlp.sucFileBlock = ^(YunQiniuFileModel *url) {
        [fileList addObject:url];
        curIndex++;

        totalPrgs += partPrgs;
        if (progress) {
            progress(totalPrgs);
        }

        if ([fileList count] == [files count]) {
            success([fileList copy]);
            return;
        }
        else {
            [YunQiniuUploadHelper uploadFile:files[curIndex]
                                        progress:nil
                                         success:weakHlp.sucFileBlock
                                         failure:weakHlp.failureBlock];
        }
    };

    [YunQiniuUploadHelper uploadFile:files[0]
                                progress:nil
                                 success:weakHlp.sucFileBlock
                                 failure:weakHlp.failureBlock];
}

+ (NSString *)getFileUrl:(NSDictionary *)resp baseUrl:(NSString *)baseUrl {
    if (YunQiniuUploadConfig.instance.delegate) {
        if ([YunQiniuUploadConfig.instance.delegate respondsToSelector:@selector(getFileUrlByResp:)]) {
            NSString *fileUrl = [YunQiniuUploadConfig.instance.delegate getFileUrlByResp:resp];

            return fileUrl;
        }
    }

    NSString *url = resp[@"url"];

    return url;
}

+ (NSError *)errWithType:(QiNiuHelperError)type {
    return [NSError errorWithDomain:@"QiNiuHelper"
                               code:type
                           userInfo:nil];
}

@end