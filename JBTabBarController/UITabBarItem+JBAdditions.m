//
//  UITabBarItem+JBAdditions.m
//  JBTabBarController
//
//  Created by Jin Budelmann on 3/02/12.
//  Copyright (c) 2012 BitCrank. All rights reserved.
//

#import "UITabBarItem+JBAdditions.h"
#import <objc/runtime.h>

@implementation UITabBarItem (JBAdditions)

static char selectedImageKey; 

- (UIImage*) selectedImage { 
    return (UIImage*)objc_getAssociatedObject(self, &selectedImageKey); 
} 

- (void) setSelectedImage:(UIImage*)image { 
    objc_setAssociatedObject(self, &selectedImageKey, image, OBJC_ASSOCIATION_RETAIN_NONATOMIC); 
}

@end
