 //
//  JBTabBarController.m
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "JBTabBarController.h"

#import "JBTabBar.h"

#import "UITabBarItem+JBAdditions.h"

@interface JBTabBarController()

@property (nonatomic, readwrite, retain) JBTabBar* tabBar;

- (void) setUpTabBarItems;

@end

@implementation JBTabBarController

@synthesize tabBar;
@synthesize viewControllers = _viewControllers;

#pragma mark - View lifecycle

-  (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tabBar = [[JBTabBar alloc] init];
    self.tabBar.delegate = self;
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"bg"];
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"bg-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 5, 5, 5)];
    
    CGRect frame = self.tabBar.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    self.tabBar.frame = frame;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self setUpTabBarItems];
    self.selectedIndex = 0;
    
    [self.view addSubview:self.tabBar];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tabBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void) setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    if (self.tabBar) {
        [self setUpTabBarItems];
    }
}

- (void) setUpTabBarItems {
    if ([_viewControllers count]>0) {
        NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity:[_viewControllers count]];
        for (id object in _viewControllers) {
            NSAssert([object isKindOfClass:[UIViewController class]], @"Only UIViewControllers can be loaded into the JBTabBArController viewControllers");
            UIViewController* controller = (UIViewController*) object;
            [items addObject:controller.tabBarItem];
        }
        self.tabBar.items = items;
    }
}

- (void)tabBar:(JBTabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    for (UIViewController* controller in _viewControllers) {
        if ([controller.tabBarItem isEqual:item]) {
            self.selectedViewController = controller;
            return;
        }
    }
}

#pragma mark Selected Tab properties

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    self.selectedViewController = [_viewControllers objectAtIndex:selectedIndex];
}

- (NSUInteger)selectedIndex {
    return [_viewControllers indexOfObject:_selectedViewController];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    if (selectedViewController != _selectedViewController && [_viewControllers containsObject:selectedViewController]) {
        [_selectedViewController.view removeFromSuperview];
        
        CGRect frame = self.view.bounds;
        frame.size.height -= self.tabBar.frame.size.height;
        selectedViewController.view.frame = frame;
        
        [self.view insertSubview:selectedViewController.view belowSubview:self.tabBar];
        
        _selectedViewController = selectedViewController;
        if (self.tabBar.selectedItem != _selectedViewController.tabBarItem) {
            self.tabBar.selectedItem = _selectedViewController.tabBarItem;
        }
    }
}

- (UIViewController*) selectedViewController {
    return _selectedViewController;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [_selectedViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [_selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
