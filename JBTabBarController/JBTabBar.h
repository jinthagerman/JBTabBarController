//
//  JBTabBar.h
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBTabBarDelegate;

@interface JBTabBar : UIView {
    NSMutableArray                              *_buttons;
    __unsafe_unretained id<JBTabBarDelegate>     _delegate;
    NSArray                                     *_items;
    __unsafe_unretained UITabBarItem            *_selectedItem;
    UIImage                                     *_selectionIndicatorImage;
    UIImageView                                 *_backgroundView;
}

@property(nonatomic,unsafe_unretained) id<JBTabBarDelegate> delegate;
@property(nonatomic,copy) NSArray *items;
@property(nonatomic,unsafe_unretained) UITabBarItem *selectedItem;

//- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@property(nonatomic,strong) UIImage *backgroundImage;
@property(nonatomic,strong) UIImage *selectionIndicatorImage; 

@end

@protocol JBTabBarDelegate<NSObject>
@optional

- (void)tabBar:(JBTabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end