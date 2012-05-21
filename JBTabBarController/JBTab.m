//
//    JBTabBarButton
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

#import "JBTab.h"

@interface JBTab()

@property (nonatomic, strong) UIImageView           *backgroundView;

@property(nonatomic,strong) UIColor                 *normalTitleColor;
@property(nonatomic,strong) UIColor                 *normalTitleShadowColor;
@property(nonatomic,strong) UIImage                 *normalImage;

@property(nonatomic,strong) UIColor                 *selectedTitleColor;
@property(nonatomic,strong) UIColor                 *selectedTitleShadowColor;
@property(nonatomic,strong) UIImage                 *selectedImage;

@property(nonatomic,strong) tapBlock                 touchDownBlock;

@end 

@implementation JBTab 

@synthesize selected = _selected;

@synthesize normalTitleColor = _normalTitleColor;
@synthesize normalTitleShadowColor = _normalTitleShadowColor;
@synthesize normalImage = _normalImage;

@synthesize selectedTitleColor = _selectedTitleColor;
@synthesize selectedTitleShadowColor = _selectedTitleShadowColor;
@synthesize selectedImage = _selectedImage;

@synthesize touchDownBlock = _touchDownBlock;

@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;

@synthesize backgroundView = _backgroundView;

- (id)init
{
    self = [super init];
    if (self) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
        
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        [self setTitleColor:[UIColor whiteColor] selected:NO];
        [self setTitleShadowColor:[UIColor clearColor] selected:NO];
        
        [self configureViewsSelected:NO];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingH = 3.0f;
    CGFloat paddingV = 3.0f;        
    CGFloat requiredWidth = self.bounds.size.width - 2*paddingH;
    CGSize titleSize = [self.title sizeWithFont:self.titleLabel.font
                                                forWidth:requiredWidth 
                                           lineBreakMode:self.titleLabel.lineBreakMode];
    
    if (self.currentImage && self.title) {
        CGFloat imageHeight = self.bounds.size.height - titleSize.height - paddingV;
        
        self.imageView.frame = CGRectMake(paddingH, paddingV, requiredWidth, imageHeight); 
        
        self.titleLabel.frame = CGRectMake(paddingH, imageHeight + paddingV, requiredWidth, titleSize.height);  
    } else if (!self.currentImage && self.title) {
        self.titleLabel.frame = CGRectMake(paddingH, (self.bounds.size.height-titleSize.height)/2, requiredWidth, titleSize.height);   
    } else if (self.currentImage && !self.title) {
        CGSize imageSize = self.currentImage.size;
        CGFloat paddingV = (self.bounds.size.height - imageSize.height)/2;
        self.imageView.frame = CGRectMake(roundf((self.bounds.size.width - imageSize.width)/2), roundf(paddingV), roundf(imageSize.width), roundf(imageSize.height));
    }    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_touchDownBlock) {
        _touchDownBlock();
    }
}

- (void)setSelected:(BOOL)selected {
    if (_selected != selected) {
        [self configureViewsSelected:selected];
    }
    _selected = selected;
}

- (void) configureViewsSelected:(BOOL)selected {
    _backgroundView.hidden = !selected;
    
    if (selected) {
        _titleLabel.textColor = _selectedTitleColor;
        _titleLabel.shadowColor = _selectedTitleShadowColor;
        
        _imageView.image = _selectedImage;
    } else {
        _titleLabel.textColor = _normalTitleColor;
        _titleLabel.shadowColor = _normalTitleShadowColor;
        
        _imageView.image = _normalImage;
    }
}

- (void) setTitleColor:(UIColor*)titleColor selected:(BOOL)selected {
    if (!_normalTitleColor || !selected) {
        _normalTitleColor = titleColor;
    }
    
    if (!_selectedTitleColor || selected) {
        _selectedTitleColor = titleColor;
    }
    
    if (selected == self.selected) {
        _titleLabel.textColor = titleColor;
    }
}

- (void) setTitleShadowColor:(UIColor*)titleShadowColor selected:(BOOL)selected {
    if (!_normalTitleShadowColor || !selected) {
        _normalTitleShadowColor = titleShadowColor;
    }
    
    if (!_selectedTitleShadowColor || selected) {
        _selectedTitleShadowColor = titleShadowColor;
    }
    
    if (selected == self.selected) {
        _titleLabel.shadowColor = titleShadowColor;
    }
}

- (void) setImage:(UIImage*)image selected:(BOOL)selected {
    if (!_normalImage || !selected) {
        _normalImage = image;
    }
    
    if (!_selectedImage || selected) {
        _selectedImage = image;
    }
    
    if (selected == self.selected) {
        _imageView.image = image;
    }
}

- (void)setTouchDownBlock:(tapBlock)block {
    _touchDownBlock = [block copy];   
}

#pragma mark Convenience Methods

- (void) setTitle:(NSString*)title {
    _titleLabel.text = title;
}

- (NSString*) title {
    return _titleLabel.text;
}

- (void) setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage {
    _backgroundView.image = selectedBackgroundImage;
}

- (UIImage*) selectedBackgroundImage {
    return _backgroundView.image;
}

- (UIColor *)currentTitleColor {
    return (_selected) ? _selectedTitleColor : _normalTitleColor;
}

- (UIColor *)currentTitleShadowColor {
    return (_selected) ? _selectedTitleShadowColor : _normalTitleShadowColor;
}

- (UIImage*)currentImage {
    return (_selected) ? _selectedImage : _normalImage;
}

@end
