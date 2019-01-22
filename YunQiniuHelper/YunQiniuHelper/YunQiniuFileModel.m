//
// Created by yun on 2019-01-22.
// Copyright (c) 2019 skkj. All rights reserved.
//

#import "YunQiniuFileModel.h"

@interface YunQiniuFileModel () {
}

@end

@implementation YunQiniuFileModel

- (instancetype)initWithFileUrl:(NSString *)fileUrl resp:(NSDictionary *)resp key:(NSString *)key {
    self = [super init];
    if (self) {
        self.fileUrl = fileUrl;
        self.resp = resp;
        self.key = key;
    }

    return self;
}

+ (instancetype)modelWithFileUrl:(NSString *)fileUrl resp:(NSDictionary *)resp key:(NSString *)key {
    return [[self alloc] initWithFileUrl:fileUrl resp:resp key:key];
}

@end