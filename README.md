# ZKAppUsageLogger

[![CI Status](http://img.shields.io/travis/bestofsong/ZKAppUsageLogger.svg?style=flat)](https://travis-ci.org/bestofsong/ZKAppUsageLogger)
[![Version](https://img.shields.io/cocoapods/v/ZKAppUsageLogger.svg?style=flat)](http://cocoapods.org/pods/ZKAppUsageLogger)
[![License](https://img.shields.io/cocoapods/l/ZKAppUsageLogger.svg?style=flat)](http://cocoapods.org/pods/ZKAppUsageLogger)
[![Platform](https://img.shields.io/cocoapods/p/ZKAppUsageLogger.svg?style=flat)](http://cocoapods.org/pods/ZKAppUsageLogger)

## Example
```
1. 配置
[[ZKAppUsageLogger sharedInstance] config:
@{@"logSendHandler": ^(NSDictionary *cpsInfo) {
  if (cpsInfo) {
    [CpsManager postCpsInfo:@[cpsInfo] success:nil failure:nil];
  }
}}];
------------------------------------------------------------------------------------------
2.app启动
[[ZKAppUsageLogger sharedInstance] logAppLaunch];
------------------------------------------------------------------------------------------
3.进入X页面
[[ZKAppUsageLogger sharedInstance] logPageEntrance:@"注册页"];
------------------------------------------------------------------------------------------
4.页面停留时长
由UIViewController+ZKLifeCycleSwizzling自动执行
```


To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ZKAppUsageLogger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ZKAppUsageLogger"
```

## Author

bestofsong, betterofsong@gmail.com

## License

ZKAppUsageLogger is available under the MIT license. See the LICENSE file for more info.
