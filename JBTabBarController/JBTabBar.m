//
//    JBTabBar
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
        
        self.backgroundImage = [UIImage imageNamed:@"JBTabBarController.bundle/bg.png"];
        
        UIImage* selected = [UIImage imageNamed:@"JBTabBarController.bundle/bg-selected.png"];
        if ([selected respondsToSelector:@selector(resizableImageWithCapInsets:)]) {
            self.selectionIndicatorImage = [selected resizableImageWithCapInsets:UIEdgeInsetsMake(6, 5, 5, 5)];
        } else {
            self.selectionIndicatorImage = [selected stretchableImageWithLeftCapWidth:5 topCapHeight:6];
        }
        
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
        } else {
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
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.showsTouchWhenHighlighted = NO;
    button.reversesTitleShadowWhenHighlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    
    [button setTitleColor:[UIColor colorWithWhite:0.6f alpha:1.0f] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
    [button setImage:item.image forState:UIControlStateNormal];
    [button setImage:item.selectedImage forState:UIControlStateSelected];
    
    [button setBackgroundImage:self.selectionIndicatorImage forState:UIControlStateHighlighted];
    [button setBackgroundImage:self.selectionIndicatorImage forState:UIControlStateSelected];
        
    [button setTitle:item.title forState:UIControlStateNormal];
        
    return button;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    if ([_items containsObject:selectedItem]) {
        [self dimAllButtonsExcept:[_buttons objectAtIndex:[_items indexOfObject:selectedItem]]];
        _selectedItem = selectedItem;
    }
}

@end
