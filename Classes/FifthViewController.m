//
//  FifthViewController.m
//  JBTabBarControllerExample
//
//  Created by Jin Budelmann on 20/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "FifthViewController.h"

@implementation FifthViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Levitate";
        self.tabBarItem.image = [UIImage imageNamed:@"Levitate-unselected"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"Levitate-selected"];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor purpleColor];
}


@end
