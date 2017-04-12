//
//  ZKAppUsageLoggerPrivate.h
//  Pods
//
//  Created by wansong.mbp.work on 12/04/2017.
//
//

#ifndef ZKAppUsageLoggerPrivate_h
#define ZKAppUsageLoggerPrivate_h

#import "ZKAppUsageLogger.h"


@interface ZKAppUsageLogger ()

- (void)logPageName:(NSString*)pageName duration:(NSNumber*)duration;

- (void)logAppLaunch;

@end

#endif /* ZKAppUsageLoggerPrivate_h */
