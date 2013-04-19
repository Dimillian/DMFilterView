DMFilterView
============

A `UIView` subclass which add itself at the bottom of any view.

##What is it ? 
`DMFilterView` is a subclass of `UIView`, it look like a `UITabBar` but it much more lighter to implement. You just init it with an `NSArray` of strings and then attach it to your view. 
It provides some easy delegate and customization functions.

For example I use it in [MySeeen](http://myseeenapp.com) to filter the MySeeen grid view, and I think this is the primary functionality of this control, it should act as a filter 
In the provided example I show you how to hide and show it regarding a `UITableView` scroll. 
Cool heh?

![image](https://raw.github.com/Dimillian/DMFilterView/master/image1.png)
![image](https://raw.github.com/Dimillian/DMFilterView/master/image2.png)

Note: You should change provided images by your own before using in your application.

##Feature
1. Easy to use.
2. Fully animated (Selection, show, hide).
3. Easy customization. (fonts, colors, etc…)
4. Change the background image or replace it by a color, and change the selected image or color.
5. Ultra lite

##How to use
Add `DMFilterView` to your project and do something like this in a view or view a view controller

	_filterView = [[DMFilterView alloc]initWithStrings:@[@"ABC", @"Filter 1", @"Filter 2"] containerView:self.view];
	[self.filterView attachToContainerView];

Then you need to implement the only `@required` delegate method which is

	- (void)filterView:(DMFilterView *)filterView didSelectedAtIndex:(NSInteger)index
	{
	   //Place your filter logic here
	}

`DMFilterView` also provides some other delegate `@optional` method such as

	- (CGFloat)filterViewDisplayAnimatioSpeed:(DMFilterView *)filterView;
	- (CGFloat)filterViewSelectionAnimationSpeed:(DMFilterView *)filterView;

	
## Licensing 
Copyright (C) 2012 by Thomas Ricouard. 

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

