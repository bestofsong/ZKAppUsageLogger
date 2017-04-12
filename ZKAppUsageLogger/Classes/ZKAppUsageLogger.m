//
//  ZKAppUsageLogger.m
//  Pods
//
//  Created by wansong.mbp.work on 12/04/2017.
//
//

#import "ZKAppUsageLogger.h"
#import "ZKAppUsageLoggerPrivate.h"

#import <AdSupport/ASIdentifierManager.h>

@interface ZKAppUsageLogger ()

@property (copy, nonatomic) LogSendHandler logSendHandler;
@property (copy, nonatomic) NSString *device_id;

@end

@implementation ZKAppUsageLogger

+ (instancetype)sharedInstance {
  static dispatch_once_t onceToken;
  static ZKAppUsageLogger *ret = nil;
  dispatch_once(&onceToken, ^{
    ret = [[ZKAppUsageLogger alloc] init];
  });
  return ret;
}

- (NSString*)device_id {
  if (!_device_id) {
    _device_id = [self.class identifierForAdvertising];
  }
  return _device_id;
}

- (void)config:(NSDictionary *)configurations {
  self.logSendHandler = configurations[@"logSendHandler"];
  self.device_id = configurations[@"device_id"];
}

- (void)logPageName:(NSString*)pageName duration:(NSNumber*)duration {
  [self logType:@"app页面停留时长"
   detailedInfo:@{
                  @"page_name": pageName ?: @"",
                  @"page_stay_duration": duration ?: @0
                  }];
}

- (void)logAppLaunch {
  [self logType:@"打开app" detailedInfo:nil];
}

- (void)logAppEntrance:(NSString*)pageName {
  NSString *type = [NSString stringWithFormat:@"app进入%@页", pageName];
  [self logType:type detailedInfo:nil];
}

- (void)logType:(NSString*)type detailedInfo:(NSDictionary*)detailedInfo {
  if (self.logSendHandler) {
    NSMutableDictionary *detailedInfoWithDeviceId = [NSMutableDictionary dictionaryWithDictionary:detailedInfo ?: @{}];
    detailedInfoWithDeviceId[@"device_id"] = self.device_id ?: @"";
    self.logSendHandler(@{
                          @"event_type": type ?: @"",
                          @"detailedInfo": detailedInfoWithDeviceId,
                          });
  }
}

+ (NSString *)identifierForAdvertising {
  if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
    NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    return [IDFA UUIDString];
  }
  return nil;
}

@end
