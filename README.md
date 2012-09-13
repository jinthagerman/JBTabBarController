# JBTabBarController

+![](http://farm9.staticflickr.com/8446/7892326866_73070f3c07.jpg)

**JBTabBarController** aims to be a drop-in replacement of `UITabBarController`, but with the intention of letting developers easily customise its appearance. **JBTabBar** uses images for all UI elements except for the labels on TabBar items. This gives the Developer/Designer the freedom to customise all aspects of the TabBar. 

In particular, the images for selected and unselected states can be specified and are colour images not clipping masks. `UITabBarItem+JBAdditions.h` adds an additional property (`selectedImage`) to `UITabBarItem` which specifies the image to show in the selected state. 30 pixel squared images (60 pixels for Retina displays) are recommended for this purpose.

## Installation Notes
To use, import all the files in the **JBTabBarController** folder into your project and include "`JBTabBarController.h`" where ever it is needed or in your precompiled header. 

Also, include "`JBTabBarController+ConvenienceMethods.h`" if you want to use the convenience property added to `UIViewController`. This property works the same as the `tabBarController` property on `UIViewController` and gives you access to the relevant **JBTabBarController** from any of the `UIViewController`s contained in it. Using this property currently requires **JRSwizzle**.

The project uses ARC and targets iOS 4.0+ devices.

## Todo
* Make **JBTabBar** titles more configurable (font, colour, shadow)
* Make **JBTabBar** more dynamic (swizzle `UIViewController` title property)
* More example TabBars (i.e replicate Apple Trailers and Twitter app tabbars)
* Adopt more `UITabBarController` conventions and behaviours
* Make the example compile without **JRSwizzle**
* Automatic resize of tabBar with new backgroundImage (KVO)
* Option to hide labels

## Example Resources

The included example attempts to emulate the standard `UITabBar` design provided by Apple. The layer styles used to create the TabBar images in Photoshop are in the Extras folder.

The example **JBTabBar** uses the following icons from the following authors (all from The Noun Project)

* ["Levitation" icon by Scott Lewis, from The Noun Project](http://thenounproject.com/noun/levitation/#icon-No774)
* ["At" from The Noun Project (under Public Domain)](http://thenounproject.com/noun/at/#icon-No596)
* ["Brain" from The Noun Project (under Public Domain)](http://thenounproject.com/noun/brain/#icon-No685)
* ["Peaceful Protest" from The Noun Project (under Public Domain)](http://thenounproject.com/noun/peaceful-protest/#icon-No760)
* ["Elephant" from the Adrijan Karavdic, from The Noun Project](http://thenounproject.com/noun/elephant/#icon-No860)

## License

This code is distributed under the terms and conditions of the MIT license.

Copyright (c) 2012 Jin Budelmann.
[http://www.bitcrank.com](http://www.bitcrank.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
