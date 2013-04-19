DMFilterView
============

A `UIView` Subclass which add itself at the bottom of any view.

#What is it ? 
`DMFilterView` is a subclass of `UIView`, it look like a `UITabBar` but it much more lighter to implement. You just init it with an Array of strings and then attach it to your view. 
It provide some delegate 

Image

Note: The UI look bad because you need to change provided images before using it in your app. 
Images provided are not adapted.

#Feature
1. Easy to use
2. Selectiond and show/hide animations
3. Easy customization
4. Change the background image or replace it by a color, and change the selected image
5. Ultra lite

#How to use
Add `DMFilterView` to your project and do something like this in a view or view a view controller

	_filterView = [[DMFilterView alloc]initWithStrings:@[@"ABC", @"Filter 1", @"Filter 2"] containerView:self.view];`
	`[self.filterView attachToContainerView];

Then you need to implement the only `@required` delegate method which is

	- (void)filterView:(DMFilterView *)filterView didSelectedAtIndex:(NSInteger)index
	{
	   //Place your filter logic here
	}

`DMFilterView` also provide some other delegate `@optional` method such as

	- (CGFloat)filterViewDisplayAnimatioSpeed:(DMFilterView *)filterView;
	- (CGFloat)filterViewSelectionAnimationSpeed:(DMFilterView *)filterView;

	


