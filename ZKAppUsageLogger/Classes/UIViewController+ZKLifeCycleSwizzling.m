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
  if ([self shouldIgnore]) {
    return;
  }

  objc_setAssociatedObject(self, kLastAppear, [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)zhike_viewDidDisappear:(BOOL)animated {
  [self zhike_viewDidDisappear:animated];
  if ([self shouldIgnore]) {
    return;
  }
  NSDate *lastDate = (NSDate*)objc_getAssociatedObject(self, kLastAppear);
  if (lastDate) {
    double duration = -[lastDate timeIntervalSinceNow];
    [[ZKAppUsageLogger sharedInstance] logPageName:[self guessTitle] duration:@(duration)];
    objc_setAssociatedObject(self, kLastAppear, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
}

- (BOOL)shouldIgnore {
  if ([self isKindOfClass:UINavigationController.class] ||
      [self isKindOfClass:UITabBarController.class] ||
      [self isKindOfClass:UIAlertController.class]) {
    return YES;
  }
  
  return NO;
}

- (NSString *)guessTitle {
  return self.title ?: (self.navigationItem.title ?: NSStringFromClass(self.class));
}

@end
