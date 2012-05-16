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

#import <UIKit/UIKit.h>

typedef enum {
    JBTabBarLayoutStrategyFill = 0,
    JBTabBarLayoutStrategyCenter,
    JBTabBarLayoutStrategyEqualSpacing,
    JBTabBarLayoutStrategyLeftJustified,
    JBTabBarLayoutStrategyRightJustified,
    JBTabBarLayoutStrategyBlockBased
} JBTabBarLayoutStrategy;

@class JBTab;
typedef void (^JBLayoutBlock) (JBTab* tab, NSUInteger index, NSUInteger numberOfTabs);

@protocol JBTabBarDelegate;

@interface JBTabBar : UIView {
    NSMutableArray                              *_tabs;
    __unsafe_unretained id<JBTabBarDelegate>     _delegate;
    NSArray                                     *_items;
    __unsafe_unretained UITabBarItem            *_selectedItem;
    UIImage                                     *_selectionIndicatorImage;
    UIImageView                                 *_backgroundView;
    JBTabBarLayoutStrategy                      _layoutStrategy;
}

@property(nonatomic,unsafe_unretained) id<JBTabBarDelegate> delegate;
@property(nonatomic,copy) NSArray *items;
@property(nonatomic,unsafe_unretained) UITabBarItem *selectedItem;

// Determines how the tab views will be laid out. If self.frame.size.width/numberOfTabs >= maximumTabWidth, 
// this setting will have no effect (i.e same result as JBTabBarLayoutStrategyFill).
@property(nonatomic) JBTabBarLayoutStrategy layoutStrategy;

// Sets the maximum width of a tab view. This only comes into effect 
// once self.frame.size.width/numberOfTabs < maximumTabWidth
// Defaults to CGFLOAT_MAX
@property(nonatomic) CGFloat maximumTabWidth;

// Will only be used if layoutStrategy is set to JBTabBarLayoutStrategyBlockBased
@property(nonatomic, copy) JBLayoutBlock layoutBlock;

// Needs to be implemented to replicate UITabBar fully
//- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@property(nonatomic,strong) UIImage *backgroundImage;
@property(nonatomic,strong) UIImage *selectionIndicatorImage; 

@end

@protocol JBTabBarDelegate<NSObject>
@optional

- (void)tabBar:(JBTabBar *)tabBar didSelectItem:(UITabBarItem *)item;

@end