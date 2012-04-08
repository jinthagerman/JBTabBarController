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

#import "JBTabBarButton.h"

@implementation JBTabBarButton 

- (void) layoutSubviews {
    [super layoutSubviews];
    
    CGFloat paddingH = 3.0f;
    CGFloat paddingV = 3.0f;        
    CGFloat requiredWidth = self.bounds.size.width - 2*paddingH;
    CGSize titleSize = [[self currentTitle] sizeWithFont:self.titleLabel.font
                                                forWidth:requiredWidth 
                                           lineBreakMode:self.titleLabel.lineBreakMode];
    
    if ([self currentImage] && [self currentTitle]) {
        CGFloat imageHeight = self.bounds.size.height - titleSize.height - paddingV;
        
        self.imageView.frame = CGRectMake(paddingH, paddingV, requiredWidth, imageHeight); 
        
        self.titleLabel.frame = CGRectMake(paddingH, imageHeight + paddingV, requiredWidth, titleSize.height);  
    } else if (![self currentImage] && [self currentTitle]) {
        self.titleLabel.frame = CGRectMake(paddingH, (self.bounds.size.height-titleSize.height)/2, requiredWidth, titleSize.height);   
    } else if ([self currentImage] && ![self currentTitle]) {
        CGSize imageSize = [self currentImage].size;
        CGFloat paddingV = (self.bounds.size.height - imageSize.height)/2;
        self.imageView.frame = CGRectMake(roundf((self.bounds.size.width - imageSize.width)/2), roundf(paddingV), roundf(imageSize.width), roundf(imageSize.height));
    }    
}

@end
