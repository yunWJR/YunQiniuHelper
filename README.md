# YunQiniuHelper

自己封装的 iOS 端的七牛上传工具，使用 Objective-C。

- Platform:  iOS 9.0 and later

## 需要的基本库

- Qiniu

## 使用方法

- 支持上传 UIImage 和 NSData

- 基本配置在**YunQiniuUploadConfig.h**修改

- 采用 token 上传（后台提供）

### 1. 设置代理

建议代理设置在一个单例辅助类中，不需要每个使用的地方都实现。

```
YunQiniuUploadConfig.instance.delegate = self;
```

实现以下2个代理

```
- (void)getQnPara:(getQnParaBlock)rst {
    NSString *token; /// 从后台获取上传 token
    if (rst) {
        rst(YES, token, nil);
    }
}

/// 上传成功后，根据 resp 获取 url
/// 上传结果也有 resp 的值，也可以自己从结果取
- (NSString *)getFileUrlByResp:(NSDictionary *)resp {
    return resp[@"fileUrl"];
}
```

### 2. 上传单个文件

```
    id file = nil; // UIImage 或者 NSData
    id fileKey = nil; // 可以指定 key，不指定则由七牛生成，建议 nil，避免重复文件覆盖。
    [YunQiniuUploadHelper uploadFile:file
                             fileKey:fileKey
                            progress:nil
                             success:^(YunQiniuFileModel *file) {
                                 // file 上传成功的结果
                             }
                             failure:^(NSError *err) {

                             }];
```

### 3. 上传多个文件

```
    NSArray * files = nil; // 文件数组，UIImage 或者 NSData
    NSArray<NSString *> *fileKeys = nil; // key 数组， 可以指定 key，不指定则由七牛生成，建议 nil，避免重复文件覆盖。
    [YunQiniuUploadHelper uploadFiles:files
                             fileKeys:fileKeys
                            progress:nil
                             success:^(NSArray<YunQiniuFileModel *> *files) {
                                 // files 上传成功的结果
                             }
                             failure:^(NSError *err) {

                             }];
```

### 4. 注意

- 建议代理设置在一个单例辅助类中，不需要每个使用的地方都实现。
- 该上传暂不支持多线程。

## 安装

Use the cocoaPods

> `pod 'YunQiniuHelper'`


