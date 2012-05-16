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
    
    JBLayoutBlock layoutBlock = nil;
    if ([self shouldLayout]) {
        switch (self.layoutStrategy) {
            case JBTabBarLayoutStrategyCenter: {
                layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
                    CGFloat horizontalOffset = (self.frame.size.width - numberOfTabs*self.maximumTabWidth)/2;
                    tab.frame = CGRectMake(horizontalOffset + self.maximumTabWidth*index, 0.0, self.maximumTabWidth, self.frame.size.height);
                } copy];
                break;
            }
            case JBTabBarLayoutStrategyEqualSpacing: {
                layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
                    CGFloat spacing = (self.frame.size.width - numberOfTabs*self.maximumTabWidth)/(numberOfTabs+1);
                    tab.frame = CGRectMake(spacing*(index + 1) + self.maximumTabWidth*index, 0.0, self.maximumTabWidth, self.frame.size.height);
                } copy];
                break;
            }
            case JBTabBarLayoutStrategyLeftJustified: {
                layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
                    tab.frame = CGRectMake(self.maximumTabWidth*index, 0.0, self.maximumTabWidth, self.frame.size.height);
                } copy];
                break;
            }
            case JBTabBarLayoutStrategyRightJustified: {
                layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
                    tab.frame = CGRectMake(self.frame.size.width - self.maximumTabWidth*(numberOfTabs - index), 0.0, self.maximumTabWidth, self.frame.size.height);
                } copy];
                break;
            }
            case JBTabBarLayoutStrategyBlockBased: {
                if (self.layoutBlock) {
                    layoutBlock = self.layoutBlock;
                    break;
                }
            }
            case JBTabBarLayoutStrategyFill: {
            default:
                layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
                    CGFloat tabWidth = self.frame.size.width/numberOfTabs;
                    tab.frame = CGRectMake(tabWidth*index, 0.0, tabWidth, self.frame.size.height);
                } copy];
                break;
            }
        }
    } else {
        layoutBlock = [^(JBTab *tab, NSUInteger index, NSUInteger numberOfTabs) {
            CGFloat tabWidth = self.frame.size.width/numberOfTabs;
            tab.frame = CGRectMake(tabWidth*index, 0.0, tabWidth, self.frame.size.height);
        } copy];
    }
    
    [self layoutWithBlock:layoutBlock];
}

- (BOOL) shouldLayout {
    BOOL isValidWidth = (self.maximumTabWidth < CGFLOAT_MAX - FLT_EPSILON && self.frame.size.width/[_items count] > self.maximumTabWidth);
    BOOL isBlockBased = (self.layoutStrategy == JBTabBarLayoutStrategyBlockBased);
    return isBlockBased || isValidWidth;
}

- (void) layoutWithBlock:(JBLayoutBlock)block {
    NSUInteger itemCount = [_items count];
    for (NSUInteger i = 0 ; i < itemCount ; i++)
    {
        JBTab* tab = [_tabs objectAtIndex:i];
        block(tab,i,itemCount);
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
