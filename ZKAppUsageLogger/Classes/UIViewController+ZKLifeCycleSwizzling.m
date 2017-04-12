//
//  UIViewController+LifeCycleSwizzling.m
//  Pods
//
//  Created by wansong.mbp.work on 12/04/2017.
//
//

#import "JRSwizzle.h"
#import <objc/runtime.h>
#import "UIViewController+ZKLifeCycleSwizzling.h"
#import "ZKAppUsageLoggerPrivate.h"
const char *kLastAppear = "VC(ZKLifeCycleSwizzling)kLastAppear";

@implementation UIViewController (ZKLifeCycleSwizzling)

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(zhike_viewDidAppear:) error:NULL];
    [self jr_swizzleMethod:@selector(viewDidDisappear:) withMethod:@selector(zhike_viewDidDisappear:) error:NULL];
  });
}

- (void)zhike_viewDidAppear:(BOOL)animated {
  [self zhike_viewDidAppear:animated];
  objc_setAssociatedObject(self, kLastAppear, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zhike_viewDidDisappear:(BOOL)animated {
  [self zhike_viewDidDisappear:animated];
  NSDate *lastDate = (NSDate*)objc_getAssociatedObject(self, kLastAppear);
  if (lastDate) {
    double duration = -[lastDate timeIntervalSinceNow];
    [[ZKAppUsageLogger sharedInstance] logPageName:[self guessTitle] duration:@(duration)];
    NSLog(@"%@ duration: %@", [self guessTitle], @(duration));
    objc_setAssociatedObject(self, kLastAppear, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

- (NSString *)guessTitle {
  return self.title ?: (self.navigationItem.title ?: @"none");
}

@end
