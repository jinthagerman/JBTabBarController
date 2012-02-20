//
//  ThirdViewController.m
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Elephant";
        self.tabBarItem.image = [UIImage imageNamed:@"Elephant-unselected"];
        self.tabBarItem.selectedImage = [UIImage imageNamed:@"Elephant-selected"];
    }
    return self;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"test"];
    cell.detailTextLabel.text = @"Test Cell";
    cell.textLabel.text = [NSString stringWithFormat:@"cell %@",indexPath];
    return cell;
}

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

@end
