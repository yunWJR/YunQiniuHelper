//
// Created by yun on 2017/11/24.
// Copyright (c) 2017 skkj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    QqHlpErr_errQnPara,
    QqHlpErr_errImg,
} QiNiuHelperError;

typedef void(^getQnParaBlock)(BOOL suc, NSString *token, NSString *cdnUrl);

@protocol YunQiniuUploadImageDelegate <NSObject>

@required
- (void)getQnPara:(getQnParaBlock)rst;

@end