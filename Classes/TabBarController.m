//
//  TabBarController.m
//  JBTabBarControllerExampleExample
//
//  Created by Jin Budelmann on 20/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void) viewDidLoad {
    self.tabBar.backgroundImage = [UIImage imageNamed:@"bg"];
    
    self.tabBar.selectionIndicatorImage = [[UIImage imageNamed:@"bg-selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 5, 5, 5)];
}

@end
