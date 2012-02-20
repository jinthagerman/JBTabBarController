//
//  JBTabBarButton.m
//  JBTabBarControllerExample
//
//  Created by Jin Budelmann on 10/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
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
