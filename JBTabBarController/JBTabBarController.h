//
//  JBTabBarController.h
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JBTabBar.h"

@class JBTabBar;
@protocol JBTabBarDelegate;

@interface JBTabBarController : UIViewController <JBTabBarDelegate> {
    NSArray* _viewControllers;
    __unsafe_unretained UIViewController* _selectedViewController;
}

@property (nonatomic, readonly, retain) JBTabBar* tabBar;
@property (nonatomic, retain) NSArray* viewControllers;

@property (nonatomic, unsafe_unretained) UIViewController* selectedViewController;
@property (nonatomic) NSUInteger selectedIndex;

@end
