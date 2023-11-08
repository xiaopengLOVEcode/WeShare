
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLViewControllerUtils : NSObject

+ (nullable UIViewController *)rootViewController;

+ (nullable UITabBarController *)tabBarController;

+ (BOOL)isPresentedViewController:(UIViewController *)viewController;

+ (nullable UIViewController *)currentPresentedController;

+ (nullable UIViewController *)currentTopController;

+ (UIViewController *)topViewControllerForViewController:(UIViewController *)viewController;

+ (nullable UIViewController *)viewControllerWhichPushedViewController:(UIViewController *)viewController;

+ (nullable UIViewController *)preViewController:(UIViewController *)viewController;

+ (void)pushViewControllerFromTopViewController:(UIViewController *)vc;

+ (void)pushViewControllerFromTopViewController:(UIViewController *)vc animated:(BOOL)animated;

+ (void)presentViewControllerFromTopViewController:(UIViewController *)vc;

+ (void)presentViewControllerFromTopViewController:(UIViewController *)vc
                                          animated:(BOOL)animated
                                        completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
