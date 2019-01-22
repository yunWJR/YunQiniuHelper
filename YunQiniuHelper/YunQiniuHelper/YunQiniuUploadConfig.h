//
// Created by 王健 on 16/5/13.
// Copyright (c) 2016 成都晟堃科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YunQiniuUploadImageDelegate;
@class YunQiniuFileModel;

@interface YunQiniuUploadConfig : NSObject

@property (nonatomic, weak) id <YunQiniuUploadImageDelegate> delegate;

// 图片压缩比率，默认1.0 不压缩
@property (assign, nonatomic) CGFloat cmpFactor;

@property (copy, nonatomic) void (^sucBlock)(NSString *url);

@property (copy, nonatomic) void (^sucFileBlock)(YunQiniuFileModel *file);

@property (copy, nonatomic) void (^failureBlock)(NSError *err);

+ (YunQiniuUploadConfig *)instance;

@end
