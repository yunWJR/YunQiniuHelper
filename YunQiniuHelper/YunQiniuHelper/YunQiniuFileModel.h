//
// Created by yun on 2019-01-22.
// Copyright (c) 2019 skkj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YunQiniuFileModel : NSObject

@property (nonatomic, copy) NSString *fileUrl;

@property (nonatomic, strong) NSDictionary *resp;

@property (nonatomic, copy) NSString *key;

- (instancetype)initWithFileUrl:(NSString *)fileUrl resp:(NSDictionary *)resp key:(NSString *)key;

+ (instancetype)modelWithFileUrl:(NSString *)fileUrl resp:(NSDictionary *)resp key:(NSString *)key;

@end