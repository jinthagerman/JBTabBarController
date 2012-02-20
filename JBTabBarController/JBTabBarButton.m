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
    
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.adjustsFontSizeToFitWidth = NO;
    self.titleLabel.lineBreakMode = UILineBreakModeMiddleTruncation;

    if (!![self currentImage] && !![self currentTitle]) {
        CGFloat paddingV = 3.0f;
        CGFloat imageHeight = self.bounds.size.height - self.titleLabel.font.lineHeight - 2*paddingV;
        CGFloat imageScale = imageHeight/self.imageView.frame.size.height;
                
        CGRect frame = self.imageView.frame;
        frame.size.height *= imageScale;
        frame.size.width *= imageScale;
        frame.origin.x = (self.bounds.size.width - frame.size.width)/2;
        frame.origin.y = paddingV;
        self.imageView.frame = frame; 
        
        frame = self.titleLabel.frame;
        frame.origin.x = 3.0f;
        frame.origin.y = self.imageView.frame.size.height + paddingV;
        frame.size.height = self.titleLabel.font.lineHeight;
        frame.size.width = self.bounds.size.width - 2*frame.origin.x;
        self.titleLabel.frame = frame;   
    } else if (![self currentImage] && !![self currentTitle]) {
        CGFloat padding = (self.bounds.size.height - self.titleLabel.font.lineHeight)/2;
        
        CGRect frame = self.titleLabel.frame;
        frame.origin.x = 3.0f;
        frame.origin.y = padding;
        frame.size.height = self.titleLabel.font.lineHeight;
        frame.size.width = self.bounds.size.width - 2*frame.origin.x;
        self.titleLabel.frame = frame;   
    } else if (!![self currentImage] && ![self currentTitle]) {
        CGFloat padding = (self.bounds.size.height - self.imageView.frame.size.height)/2;
        
        CGRect frame = self.imageView.frame;
        frame.origin.x = (self.bounds.size.width - frame.size.width)/2;
        frame.origin.y = padding;
        self.imageView.frame = frame;
    }
}

@end
