//
//  FourthViewController.m
//  JBTabBarControllerExample
//
//  Created by Jin Budelmann on 20/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "FourthViewController.h"

@implementation FourthViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Fist";
        self.tabBarItem.image = [UIImage imageNamed:@"Fist-unselected"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"Fist-selected"];
    }
    return self;
}

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor orangeColor];
}


@end