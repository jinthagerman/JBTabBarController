//
//    JBTabBarController
//
//    This code is distributed under the terms and conditions of the MIT license.
//
//    Copyright (c) 2012 Jin Budelmann.
//    http://www.bitcrank.com
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of this 
//    software and associated documentation files (the "Software"), to deal in the Software 
//    without restriction, including without limitation the rights to use, copy, modify, merge, 
//    publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
//    persons to whom the Software is furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all copies or 
//    substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
//    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
//    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
//    OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//    DEALINGS IN THE SOFTWARE.
//

#import "JBTabBarController.h"

#import "JBTabBar.h"

#import "UITabBarItem+JBAdditions.h"

@interface JBTabBarController()

@property (nonatomic, readwrite, strong) JBTabBar* tabBar;

- (void) setUpTabBarItems;
- (void) loadControllerViews;

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
    
    CGRect frame = self.tabBar.frame;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    frame.size.width = self.view.bounds.size.width;
    self.tabBar.frame = frame;
    self.tabBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self setUpTabBarItems];
    [self loadControllerViews];
    
    [self.view addSubview:self.tabBar];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.tabBar = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if (self.viewControllers == nil) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  
  if ([self.viewControllers count] == 0) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }
  
  if (self.selectedIndex >= [self.viewControllers count]) {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  }

  return [[self.viewControllers objectAtIndex:self.selectedIndex] shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (void) setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
    
    [self loadControllerViews];
    
    for (UIViewController* controller in _viewControllers) {
        if ([controller respondsToSelector:@selector(setJBTabBarController:)]) {
            [controller performSelector:@selector(setJBTabBarController:) withObject:self];
        }
    }
    
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

- (void)loadControllerViews {
    if ([_viewControllers count]>0) {
        for (id object in _viewControllers) {
            NSAssert([object isKindOfClass:[UIViewController class]], @"Only UIViewControllers can be loaded into the JBTabBArController viewControllers");
            UIViewController* controller = (UIViewController*) object;
            [controller view];
        }
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
        NSArray *versionInfo = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
        BOOL notifyViews  = [[versionInfo objectAtIndex:0] intValue] < 5;
        
        if (notifyViews) [_selectedViewController viewWillDisappear:NO];
        [_selectedViewController.view removeFromSuperview];
        if (notifyViews) [_selectedViewController viewDidDisappear:NO];
        
        CGRect frame = self.view.bounds;
        frame.size.height -= self.tabBar.frame.size.height;
        selectedViewController.view.frame = frame;
        
        if (notifyViews) [selectedViewController viewWillAppear:NO];
        [self.view insertSubview:selectedViewController.view belowSubview:self.tabBar];
        if (notifyViews) [selectedViewController viewDidAppear:NO];

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
