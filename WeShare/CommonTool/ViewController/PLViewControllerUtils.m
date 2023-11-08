
#import "PLViewControllerUtils.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation PLViewControllerUtils

+ (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].delegate.window;
}

+ (UIViewController *)rootViewController {
    return [self keyWindow].rootViewController;
}

+ (UITabBarController *)tabBarController {
    UITabBarController *tabBarController = nil;
    UIViewController *rootViewController = [self rootViewController];
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        rootViewController = [(UINavigationController *)rootViewController topViewController];
    }
    if (rootViewController.childViewControllers.count > 0) {
        for (UIViewController *subViewController in rootViewController.childViewControllers) {
            if ([subViewController isKindOfClass:[UITabBarController class]]) {
                tabBarController = (UITabBarController *)subViewController;
                break;
            }
        }
    }
    return tabBarController;
}

+ (BOOL)isPresentedViewController:(UIViewController *)viewController {
    BOOL isPresented = viewController.presentingViewController.presentedViewController == viewController;
    if (viewController.navigationController != nil &&
        (viewController == viewController.navigationController.viewControllers[0] ||
         viewController.parentViewController == viewController.navigationController.viewControllers[0])) {
        isPresented |= viewController.presentingViewController.presentedViewController == viewController.navigationController;
    }
    return isPresented;
}

+ (UIViewController *)currentPresentedController {
    UIViewController *currentPresentedController = nil;
    UIViewController *rootViewController = [self rootViewController];
    currentPresentedController = rootViewController;
    while (currentPresentedController.presentedViewController != nil) {
        currentPresentedController = currentPresentedController.presentedViewController;
    }

    // no presented view controller
    if (currentPresentedController == rootViewController) {
        currentPresentedController = nil;
    }
    return currentPresentedController;
}

+ (UIViewController *)currentTopController {
    UIViewController *currentPresentedController = [self currentPresentedController];
    UIViewController *currentTopController = currentPresentedController ?: [self rootViewController];
    return [self topViewControllerForViewController:currentTopController];
}

+ (UIViewController *)topViewControllerForViewController:(UIViewController *)viewController {
    UIViewController *topViewController = viewController;
    while (YES) {
        if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = [(UITabBarController *)topViewController selectedViewController];
        } else if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if (topViewController.childViewControllers.count > 0) {
            topViewController = topViewController.childViewControllers.firstObject;
        } else {
            break;
        }
    }
    return topViewController;
}

+ (UIViewController *)viewControllerWhichPushedViewController:(UIViewController *)viewController {
    __block UIViewController *result = nil;
    [viewController.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse
                                                                          usingBlock:^(__kindof UIViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
                                                                              if (vc == viewController) {
                                                                                  if (idx > 0) {
                                                                                      result = viewController.navigationController.viewControllers[idx - 1];
                                                                                  }
                                                                                  *stop = YES;
                                                                              }
                                                                          }];
    return result;
}

+ (UIViewController *)preViewController:(UIViewController *)viewController {
    UIViewController *targetVC = nil;
    NSArray<UIViewController *> *vcs = viewController.navigationController.viewControllers;
    for (UIViewController *vc in vcs) {
        if (vc == viewController) {
            break;
        }
        targetVC = vc;
    }
    return targetVC;
}

+ (void)pushViewControllerFromTopViewController:(UIViewController *)vc {
    [self pushViewControllerFromTopViewController:vc animated:YES];
}

+ (void)pushViewControllerFromTopViewController:(UIViewController *)vc animated:(BOOL)animated {
    UIViewController *topVC = [self currentTopController];
    UINavigationController *navVC;
    if ([topVC isKindOfClass:[UINavigationController class]]) {
        navVC = (UINavigationController *)topVC;
    } else {
        navVC = topVC.navigationController;
    }

    NSAssert(navVC != nil, @"NavigationController should not be nil");
    [navVC pushViewController:vc animated:animated];
}

+ (void)presentViewControllerFromTopViewController:(UIViewController *)vc {
    [self presentViewControllerFromTopViewController:vc animated:YES completion:nil];
}

+ (void)presentViewControllerFromTopViewController:(UIViewController *)vc
                                          animated:(BOOL)animated
                                        completion:(void (^ __nullable)(void))completion {
    UIViewController *topVC = [self currentTopController];
    [topVC presentViewController:vc animated:animated completion:completion];
}

@end
