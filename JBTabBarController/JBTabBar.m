//
//  JBTabBar.m
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "JBTabBar.h"
#import "JBTabBarButton.h"
#import "UITabBarItem+JBAdditions.h"

@interface JBTabBar()
-(UIButton*) buttonWithTabBarItem:(UITabBarItem*)item;
@end

static CGSize const kDefaultSize = {320.0f, 49.0f};

@implementation JBTabBar

@synthesize delegate = _delegate;
@synthesize items = _items;
@synthesize selectedItem = _selectedItem;

@synthesize selectionIndicatorImage = _selectionIndicatorImage; 

- (id) init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor blackColor];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth ;
        [self addSubview:_backgroundView];
        [self sendSubviewToBack:_backgroundView];
        
        self.frame = CGRectMake(0.0f, 0.0f, kDefaultSize.width, kDefaultSize.height);
    }
    return self;
}

- (void) setItems:(NSArray *)items {
    _items = items;
    
    _buttons = [[NSMutableArray alloc] initWithCapacity:[_items count]];
    
    for (UITabBarItem* item in _items)
    {
        UIButton* button = [self buttonWithTabBarItem:item];
        
        [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
        
        [_buttons addObject:button];
        
        [self addSubview:button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger itemCount = [_items count];
    
    CGFloat horizontalOffset = 0;
    
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        UIButton* button = [_buttons objectAtIndex:i];
        button.frame = CGRectMake(horizontalOffset, 0.0, self.frame.size.width/itemCount, self.frame.size.height);
        
        horizontalOffset = horizontalOffset + self.frame.size.width/itemCount;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundView.image = backgroundImage;
}

- (UIImage *)backgroundImage {
    return _backgroundView.image;
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage {
    for (JBTabBarButton* button in _buttons) {
        [button setBackgroundImage:selectionIndicatorImage forState:UIControlStateHighlighted];
        [button setBackgroundImage:selectionIndicatorImage forState:UIControlStateSelected];
    }
    _selectionIndicatorImage = selectionIndicatorImage;
}

-(void) dimAllButtonsExcept:(UIButton*)selectedButton
{
    for (UIButton* button in _buttons)
    {
        if (button == selectedButton)
        {
            button.selected = YES;
            button.highlighted = NO;
        }
        else
        {
            button.selected = NO;
            button.highlighted = NO;
        }
    }
}

- (void)touchDownAction:(UIButton*)button
{    
    self.selectedItem = [_items objectAtIndex:[_buttons indexOfObject:button]];
    
    if ([_delegate respondsToSelector:@selector(tabBar:didSelectItem:)])
        [_delegate performSelector:@selector(tabBar:didSelectItem:) withObject:self withObject:_selectedItem];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    UIButton* button = [_buttons objectAtIndex:index];
    
    [self dimAllButtonsExcept:button];
}

- (UIButton*) buttonWithTabBarItem:(UITabBarItem *)item
{
    JBTabBarButton* button = [[JBTabBarButton alloc] init];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    button.titleLabel.textAlignment = UITextAlignmentCenter;
    
    [button setTitleColor:[UIColor colorWithWhite:0.6f alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.selectedImage forState:UIControlStateHighlighted];
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    
    [button setBackgroundImage:self.selectionIndicatorImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:self.selectionIndicatorImage forState:UIControlStateSelected];
        
    [button setTitle:item.title forState:UIControlStateNormal];
    
    button.adjustsImageWhenHighlighted = NO;
    
    return button;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    if ([_items containsObject:selectedItem]) {
        [self dimAllButtonsExcept:[_buttons objectAtIndex:[_items indexOfObject:selectedItem]]];
        _selectedItem = selectedItem;
    }
}

@end
