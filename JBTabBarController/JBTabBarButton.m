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

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    if ([self currentTitle] && ![[self currentTitle] isEqualToString:@""]) {
        CGFloat paddingH = 3.0f;
        CGFloat requiredWidth = self.bounds.size.width - 2*paddingH;
        CGSize titleSize = [[self currentTitle] sizeWithFont:self.titleLabel.font
                                                 minFontSize:8.0f
                                              actualFontSize:NULL
                                                    forWidth:requiredWidth
                                               lineBreakMode:UILineBreakModeMiddleTruncation];
                
        if ([self currentImage]) {
            CGFloat paddingV = 3.0f;
            CGFloat imageHeight = self.bounds.size.height - titleSize.height - paddingV;
            return CGRectMake((self.bounds.size.width - titleSize.width)/2, imageHeight + paddingV, titleSize.width, titleSize.height);   
        } else {
            CGFloat paddingV = (self.bounds.size.height - titleSize.height)/2;
            return CGRectMake((self.bounds.size.width - titleSize.width)/2, paddingV, titleSize.width, titleSize.height);
        }
    }
    return CGRectZero;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    if ([self currentImage]) {
        CGFloat paddingH = 3.0f;
        CGFloat requiredWidth = self.bounds.size.width - 2*paddingH;
        CGSize titleSize = [[self currentTitle] sizeWithFont:self.titleLabel.font
                                                 minFontSize:8.0f
                                              actualFontSize:NULL
                                                    forWidth:requiredWidth
                                               lineBreakMode:UILineBreakModeMiddleTruncation];
        
        if ([self currentTitle] && ![[self currentTitle] isEqualToString:@""]) {
            CGFloat paddingV = 3.0f;
            CGFloat imageHeight = self.bounds.size.height - titleSize.height - paddingV;
            CGFloat imageScale = imageHeight/[self currentImage].size.height;
            CGFloat imageWidth = [self currentImage].size.width*imageScale;
            
            return CGRectMake((self.bounds.size.width - imageWidth)/2, paddingV, imageWidth, imageHeight);   
        } else {
            CGSize imageSize = [self currentImage].size;
            CGFloat paddingV = (self.bounds.size.height - imageSize.height)/2;
            return CGRectMake((self.bounds.size.width - imageSize.width)/2, paddingV, imageSize.width, imageSize.height);
        }
    }
    return CGRectZero;
}

@end
