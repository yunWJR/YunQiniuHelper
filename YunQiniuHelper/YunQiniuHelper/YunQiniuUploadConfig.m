//
// Created by 王健 on 16/5/13.
// Copyright (c) 2016 成都晟堃科技有限责任公司. All rights reserved.
//

#import "YunQiniuUploadConfig.h"

@implementation YunQiniuUploadConfig

+ (YunQiniuUploadConfig *)instance {
    static YunQiniuUploadConfig *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cmpFactor = 1.0f;
    }

    return self;
}

@end