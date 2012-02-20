//
//  FirstViewController.m
//  JBTabBarControllerExample
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"At";
        self.tabBarItem.image = [UIImage imageNamed:@"At-unselected"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"At-selected"];
    }
    return self;
}

@end
