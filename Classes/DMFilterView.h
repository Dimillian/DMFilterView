//
//  MSFilterViewController.h
//  MySeeen
//
//  Created by Thomas Ricouard on 19/04/13.
//
//

#import <UIKit/UIKit.h>

extern const CGFloat kFilterViewHeight;

@class DMFilterView;
@protocol DMFilterViewDelegate <NSObject>
@required
//The delegare must implement this method to perform actions regarding the newly selected index
- (void)filterView:(DMFilterView *)filterView didSelectedAtIndex:(NSInteger)index;
@optional
//If the delegate implement this method it can return a custom animation speed for the hide/unhide
- (CGFloat)filterViewDisplayAnimatioSpeed:(DMFilterView *)filterView;
//If the delegate implement this methid it can return a custom animation speed for the selection
- (CGFloat)filterViewSelectionAnimationSpeed:(DMFilterView *)filterView;
@end

@interface DMFilterView : UIView
{
    id<DMFilterViewDelegate>__unsafe_unretained _delegate;
}

//When the selectedIndex is set the selected button will change with animation
//Delegate will be calles as usual
//You can change the selected buttom programatically instead of a user action, it will behave the same
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, unsafe_unretained) id<DMFilterViewDelegate>delegate;
@property (nonatomic, readonly, assign) UIView *containerView;
//You can set a background imagen the background image will remove the background color.
@property (nonatomic, strong) UIImage *backgroundImage;
//The selected background image behind the selected button.
@property (nonatomic, strong) UIImage *selectedBackgroundImage;
//The selected background color behind the selected button
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
//The buttons title color
@property (nonatomic, strong) UIColor *titlesColor;
//The buttons font
@property (nonatomic, strong) UIFont *titlesFont;

/**
Designed initializer
@param strings An array of strings containing titles of buttons. Maximum number of titles, and so of buttons is 4
 An exception will be raised if you pass more than 4 string
@param containerView The view where the filter view will be added, can't be changed once set
@return An initialized MSFilterView 
 */
- (id)initWithStrings:(NSArray *)strings
       containerView:(UIView *)contrainerView;
//You should called this method once to attach the filter view to the bottom of the view you passed
//in the init method
- (void)attachToContainerView;
/**
Hide and show the filter view, with or without animation
@param hide if YES it will hide the filter view, if NO if will show the filter view
@param animated animate or not the transition 
 */
- (void)hide:(BOOL)hide animated:(BOOL)animated;
/**
 @param index the button index
 @return the title of the button at the given index
 */
- (NSString *)titleAtIndex:(NSInteger)index;
/**
 @param title the new title will replace the previous title
 @param index the button index
 */
- (void)setTitle:(NSString *)title atIndex:(NSInteger)index;
@end
