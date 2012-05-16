//
//  FirstViewController.m
//  JBTabBarControllerExample
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "FirstViewController.h"
#import "JBTabBarController.h"

#import "AppDelegate.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat padding = 10.0f;
    
    CGFloat segmentHeight = 40.0f;
    
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UISegmentedControl* layoutPicker = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
                                                                                  @"Fill",
                                                                                  @"Center",
                                                                                  @"Equal",
                                                                                  @"Left",
                                                                                  @"Right",
                                                                                  @"Block",nil]];
    layoutPicker.frame = CGRectMake(padding, padding, self.view.bounds.size.width-2*padding, segmentHeight);
    layoutPicker.segmentedControlStyle = UISegmentedControlStyleBar;
    layoutPicker.selectedSegmentIndex = delegate.layoutStrategy;
    [layoutPicker addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:layoutPicker];
    
    UIButton* minusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [minusButton addTarget:self action:@selector(decrement) forControlEvents:UIControlEventTouchUpInside];
    [minusButton setTitle:@"-" forState:UIControlStateNormal];
    [minusButton sizeToFit];
    minusButton.frame = CGRectMake(padding, 
                                   segmentHeight + 2*padding, 
                                   minusButton.bounds.size.width, 
                                   minusButton.bounds.size.height);
    [self.view addSubview:minusButton];
    
    UIButton* plusButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusButton addTarget:self action:@selector(increment) forControlEvents:UIControlEventTouchUpInside];
    [plusButton setTitle:@"+" forState:UIControlStateNormal];
    [plusButton sizeToFit];
    plusButton.frame = CGRectMake(self.view.bounds.size.width - padding - plusButton.bounds.size.width, 
                                  segmentHeight + 2*padding, 
                                  plusButton.bounds.size.width, 
                                  plusButton.bounds.size.height);
    [self.view addSubview:plusButton];
}

- (void) changeLayout:(UISegmentedControl*)segmentControl {
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.layoutStrategy = segmentControl.selectedSegmentIndex;
}

- (void) increment {
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.numberOfTabs++;
}

- (void) decrement {
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    delegate.numberOfTabs--;
}

@end
