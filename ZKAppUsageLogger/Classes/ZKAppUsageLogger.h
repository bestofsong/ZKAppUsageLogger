//
//  ZKAppUsageLogger.h
//  Pods
//
//  Created by wansong.mbp.work on 12/04/2017.
//
//

#import <Foundation/Foundation.h>

// detailedInfo: { event_type, detailedInfo }， app usage数据存放在detailedInfo字段，其他字段可以按需添加
typedef void (^LogSendHandler) (NSDictionary *detailedInfo);

@interface ZKAppUsageLogger : NSObject

+ (instancetype) sharedInstance;

// configurations: { logSendHandler(必需), device_id（可选，默认会获取idfa） }
- (void)config:(NSDictionary *)configurations;

- (void)logAppEntrance:(NSString*)pageName;

@end
