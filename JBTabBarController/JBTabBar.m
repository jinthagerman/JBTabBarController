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
#import "JBTab.h"
#import "UITabBarItem+JBAdditions.h"

@interface JBTabBar()
-(JBTab*) tabWithTabBarItem:(UITabBarItem*)item;
@end

static CGSize const kDefaultSize = {320.0f, 49.0f};

@implementation JBTabBar

@synthesize delegate = _delegate;
@synthesize items = _items;
@synthesize selectedItem = _selectedItem;

@synthesize selectionIndicatorImage = _selectionIndicatorImage; 

@synthesize layoutStrategy = _layoutStrategy;
@synthesize maximumTabWidth = _maximumTabWidth;
@synthesize layoutBlock = _layoutBlock;

- (id) init
{
    if (self = [super init])
    {
        self.maximumTabWidth = CGFLOAT_MAX;
        
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
    
    _tabs = [[NSMutableArray alloc] initWithCapacity:[_items count]];
    
    for (UITabBarItem* item in _items)
    {
        JBTab* tab = [self tabWithTabBarItem:item];
        [_tabs addObject:tab];
        [self addSubview:tab];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self shouldLayout]) {
        switch (self.layoutStrategy) {
            case JBTabBarLayoutStrategyCenter:
                [self layoutCentered];
                break;
            case JBTabBarLayoutStrategyEqualSpacing:
                [self layoutEquallySpaced];
                break;
            case JBTabBarLayoutStrategyLeftJustified:
                [self layoutLeft];
                break;
            case JBTabBarLayoutStrategyRightJustified:
                [self layoutRight];
                break;
            case JBTabBarLayoutStrategyBlockBased:
                if (self.layoutBlock) {
                    [self layoutBlockBased];
                    break;
                }
            case JBTabBarLayoutStrategyFill:
            default:
                [self layoutFill];
                break;
        }
    } else {
        [self layoutFill];
    }
}

- (BOOL) shouldLayout {
    BOOL isValidWidth = (self.maximumTabWidth < CGFLOAT_MAX - FLT_EPSILON && self.frame.size.width/[_items count] > self.maximumTabWidth);
    BOOL isBlockBased = (self.layoutStrategy == JBTabBarLayoutStrategyBlockBased);
    return isBlockBased || isValidWidth;
}

- (void) layoutFill {
    NSUInteger itemCount = [_items count];
    CGFloat horizontalOffset = 0;
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(horizontalOffset, 0.0, self.frame.size.width/itemCount, self.frame.size.height);
        
        horizontalOffset = horizontalOffset + self.frame.size.width/itemCount;
    }
}

- (void) layoutCentered {
    NSUInteger itemCount = [_items count];
    CGFloat horizontalOffset = (self.frame.size.width - itemCount*self.maximumTabWidth)/2;
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(horizontalOffset, 0.0, self.maximumTabWidth, self.frame.size.height);
        
        horizontalOffset = horizontalOffset + self.maximumTabWidth;
    }
}

- (void) layoutEquallySpaced {
    NSUInteger itemCount = [_items count];
    CGFloat spacing = (self.frame.size.width - itemCount*self.maximumTabWidth)/(itemCount+1);
    CGFloat horizontalOffset = spacing;
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(horizontalOffset, 0.0, self.maximumTabWidth, self.frame.size.height);
        
        horizontalOffset = horizontalOffset + self.maximumTabWidth + spacing;
    }
}

- (void) layoutLeft {
    NSUInteger itemCount = [_items count];
    CGFloat horizontalOffset = 0;
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        tab.frame = CGRectMake(horizontalOffset, 0.0, self.maximumTabWidth, self.frame.size.height);
        
        horizontalOffset = horizontalOffset + self.maximumTabWidth;
    }
}

- (void) layoutRight {
    NSUInteger itemCount = [_items count];
    CGFloat horizontalOffset = self.frame.size.width - self.maximumTabWidth;
    for (NSUInteger i = 1 ; i <= itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:itemCount - i];
        tab.frame = CGRectMake(horizontalOffset, 0.0, self.maximumTabWidth, self.frame.size.height);
        
        horizontalOffset = horizontalOffset - self.maximumTabWidth;
    }
}

- (void) layoutBlockBased {
    NSUInteger itemCount = [_items count];
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        self.layoutBlock(tab,i);
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundView.image = backgroundImage;
}

- (UIImage *)backgroundImage {
    return _backgroundView.image;
}

- (void)setSelectionIndicatorImage:(UIImage *)selectionIndicatorImage {
    for (JBTab* tab in _tabs) {
        tab.selectedBackgroundImage = selectionIndicatorImage;
    }
    _selectionIndicatorImage = selectionIndicatorImage;
}

-(void) deselectAllTabsExcept:(JBTab*)selectedTab
{ 
    for (JBTab* tab in _tabs)
    {
        tab.selected = (tab == selectedTab);
    }
}

- (JBTab*) tabWithTabBarItem:(UITabBarItem *)item
{
    JBTab* tab = [[JBTab alloc] init];
    tab.titleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
    tab.titleLabel.textAlignment = UITextAlignmentCenter;
    tab.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [tab setTitleColor:[UIColor colorWithWhite:0.6f alpha:1.0f] selected:NO];
    [tab setTitleColor:[UIColor whiteColor] selected:YES];
        
    [tab setImage:item.image selected:NO];
    [tab setImage:item.selectedImage selected:YES];
    
    tab.selectedBackgroundImage = self.selectionIndicatorImage;
        
    tab.title = item.title;
    
    __block UITabBarItem* tabItem = item;
    [tab setTouchDownBlock:^{
        if ([_delegate respondsToSelector:@selector(tabBar:didSelectItem:)])
            [_delegate performSelector:@selector(tabBar:didSelectItem:) withObject:self withObject:tabItem];
    }];
        
    return tab;
}

- (void)setSelectedItem:(UITabBarItem *)selectedItem {
    if ([_items containsObject:selectedItem]) {
        [self deselectAllTabsExcept:[_tabs objectAtIndex:[_items indexOfObject:selectedItem]]];
        _selectedItem = selectedItem;
    }
}

- (void)setLayoutStrategy:(JBTabBarLayoutStrategy)layoutStrategy {
    _layoutStrategy = layoutStrategy;
    [self setNeedsLayout];
}

- (void)setMaximumTabWidth:(CGFloat)maximumTabWidth {
    _maximumTabWidth = maximumTabWidth;
    [self setNeedsLayout];
}

@end
