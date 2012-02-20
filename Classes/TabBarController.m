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
    
    UIImage* selected = [UIImage imageNamed:@"bg-selected"];
    if ([selected respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
        self.tabBar.selectionIndicatorImage = [selected resizableImageWithCapInsets:UIEdgeInsetsMake(6, 5, 5, 5)];
    } else {
        self.tabBar.selectionIndicatorImage = [selected stretchableImageWithLeftCapWidth:5 topCapHeight:6];
    }
}

@end
