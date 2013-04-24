//
//  MSFilterViewController.m
//  MySeeen
//
//  Created by Thomas Ricouard on 19/04/13.
//
//

#import "DMFilterView.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kFilterViewHeight = 44.0;
const CGFloat kAnimationSpeed = 0.20;
@interface DMFilterView ()
{
    NSMutableArray *_strings;
    CGPoint _initialDraggingPoint;
}
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) UIImageView *selectedBackgroundImageView;
@property (nonatomic, strong) UIView *selectedTopBackgroundView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

- (void)updateButtonsStyle;
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
- (void)pan:(UIPanGestureRecognizer *)reconizer;
- (NSArray *)buttonsIntersectForFrame:(CGRect)frame;
- (UIButton *)selectedButton;
@end

@implementation DMFilterView

- (id)initWithStrings:(NSArray *)strings containerView:(UIView *)contrainerView
{
    NSAssert(strings.count <= 4, @"only support less than 4 titles");
    self = [super initWithFrame:CGRectMake(0,
                                           contrainerView.frame.size.height -
                                           kFilterViewHeight,
                                           contrainerView.frame.size.width,
                                           kFilterViewHeight)];
    if (self) {
        _strings = [strings mutableCopy];
        _containerView = contrainerView;
        _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.backgroundView];
        CGFloat x = 0.0;
        CGFloat buttonWidth = self.frame.size.width/strings.count;
        NSInteger tag = 0;
        _selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          buttonWidth,
                                                                          self.frame.size.height)];
        _selectedBackgroundImageView = [[UIImageView alloc]initWithFrame:self.selectedBackgroundView.frame];
        [self.selectedBackgroundView addSubview:self.selectedBackgroundImageView];
        _selectedTopBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                             0,
                                                                             self.selectedBackgroundView.frame.size.width,
                                                                             5)];
        [self.selectedBackgroundView addSubview:self.selectedTopBackgroundView];
        [self addSubview:self.selectedBackgroundView];
        for (NSString *string in strings) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:tag];
            [button setFrame:CGRectMake(x,
                                        0,
                                        buttonWidth,
                                        self.frame.size.height)];
            [button setTitle:string forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(onButton:)
             forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            x += buttonWidth;
            tag += 1;
        }
    }
    [self applyDefaultStyle];
    [self setDraggable:YES];
    [self setSelectedIndex:0];
    return self;
}

#pragma mark - display
- (void)attachToContainerView
{
    if (!self.superview) {
        [self.containerView addSubview:self];   
    }
}

- (void)applyDefaultStyle
{
    //Default ugly style
    [self setBackgroundColor:[UIColor lightGrayColor]];
    [self setSelectedItemBackgroundColor:[UIColor darkGrayColor]];
    [self setSelectedItemTopBackgroundColor:[UIColor blueColor]];
    [self setTitlesColor:[UIColor blackColor]];
    [self setTitleInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setTitlesFont:[UIFont systemFontOfSize:14]];
}

- (void)hide:(BOOL)hide animated:(BOOL)animated animationCompletion:(void (^)(void))completion
{
    CGRect f = self.frame;
    if (!hide) {
        f.origin.y = self.containerView.frame.size.height - kFilterViewHeight;

    }
    else{
        f.origin.y = self.containerView.frame.size.height + kFilterViewHeight;
    }
    if (animated) {
        CGFloat animationSpeed;
        if ([self.delegate respondsToSelector:@selector(filterViewDisplayAnimatioSpeed:)]) {
            animationSpeed = [self.delegate filterViewDisplayAnimatioSpeed:self];
        }
        else{
            animationSpeed = kAnimationSpeed;
        }
        [UIView animateWithDuration:animationSpeed
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [self setFrame:f];
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 completion();
                             }
                         }];
    }
    else{
        [self setFrame:f];
        completion();
    }

}

#pragma mark - Action
- (void)onButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if ([button isEqual:btn]) {
                [btn setUserInteractionEnabled:NO];
            }
            else{
                [btn setUserInteractionEnabled:YES];
            }
        }
    }
    CGFloat animationSpeed;
    if ([self.delegate respondsToSelector:@selector(filterViewSelectionAnimationSpeed:)]) {
        animationSpeed = [self.delegate filterViewSelectionAnimationSpeed:self];
    }
    else{
        animationSpeed = kAnimationSpeed;
    }
    if ([self.delegate respondsToSelector:
         @selector(filterViewSelectionAnimationDidBegin:)]) {
        [self.delegate
         filterViewSelectionAnimationDidBegin:self];
    }
    [UIView animateWithDuration:animationSpeed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.selectedBackgroundView.frame;
                         frame.origin.x = button.frame.origin.x;
                         [self.selectedBackgroundView setFrame:frame];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             if ([self.delegate
                                  respondsToSelector:@selector(filterViewSelectionAnimationDidEnd:)]) {
                                 [self.delegate
                                  filterViewSelectionAnimationDidEnd:self];
                             }
                         }
                     }];
    _selectedIndex = button.tag;
    [self.delegate filterView:self didSelectedAtIndex:_selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    NSAssert(selectedIndex < _strings.count, @"requested index is out of bounds");
    UIButton *selectedButton;
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == selectedIndex) {
                selectedButton = button;
                break;
            }
        }
    }
    [self onButton:selectedButton];
}

#pragma mark - Background
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    [self.backgroundView setImage:_backgroundImage];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.backgroundView.image = nil;
    [super setBackgroundColor:backgroundColor];
}

- (void)setSelectedItemBackgroundImage:(UIImage *)selectedItemBackgroundImage
{
    self.selectedItemBackgroundColor = nil;
    self.selectedTopBackgroundView.backgroundColor = nil;
    [self.selectedBackgroundImageView setImage:selectedItemBackgroundImage];
    _selectedItemBackgroundImage = selectedItemBackgroundImage;
}

- (void)setSelectedItemBackgroundColor:(UIColor *)selectedItemBackgroundColor
{
    self.selectedBackgroundImageView.image = nil;
    [self.selectedBackgroundView setBackgroundColor:selectedItemBackgroundColor];
    _selectedItemBackgroundColor = selectedItemBackgroundColor;
}

- (void)setSelectedItemTopBackgroundColor:(UIColor *)selectedItemTopBackgroundColor
{
    [self.selectedTopBackgroundView setBackgroundColor:selectedItemTopBackgroundColor];
    _selectedItemTopBackgroundColor = selectedItemTopBackgroundColor;
}

- (void)setSelectedItemTopBackroundColorHeight:(CGFloat)selectedItemTopBacktroundColorHeight
{
    CGRect frame = self.selectedTopBackgroundView.frame;
    frame.size.height = selectedItemTopBacktroundColorHeight;
    [self.selectedTopBackgroundView setFrame:frame];
    _selectedItemTopBackroundColorHeight = selectedItemTopBacktroundColorHeight;
}

- (void)setTitleInsets:(UIEdgeInsets)titleInsets
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleEdgeInsets:titleInsets];
        }
    }
    _titleInsets = titleInsets;
}

#pragma mark - internal properti
- (UIButton *)selectedButton
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == self.selectedIndex) {
                return button;
            }
        }
    }
    return nil;
}

- (void)setSelectedButton:(UIButton *)button
{
    [self setSelectedIndex:button.tag];
}

#pragma mark - buttons style
- (void)setTitlesColor:(UIColor *)titlesColor
{
    _titlesColor = titlesColor;
    [self updateButtonsStyle];
}

- (void)setTitlesFont:(UIFont *)titlesFont
{
    _titlesFont = titlesFont;
    [self updateButtonsStyle];
}

- (void)updateButtonsStyle
{
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button setTitleColor:self.titlesColor forState:UIControlStateNormal];
            [button.titleLabel setFont:self.titlesFont];
        }
    }
}

#pragma mark - strings
- (NSString *)titleAtIndex:(NSInteger)index
{
    NSAssert(index < _strings.count, @"requested index is out of bounds");
    return [_strings objectAtIndex:index];
}

- (void)setTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSAssert(index < _strings.count, @"requested index is out of bounds");
    [_strings replaceObjectAtIndex:index withObject:title];
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            if (button.tag == index) {
                [button setTitle:title forState:UIControlStateNormal];
                break;
            }
        }
    }
}

#pragma mark - Pan gesture
- (void)setDraggable:(BOOL)draggable
{
    _draggable = draggable;
    if (draggable) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self.selectedBackgroundView addGestureRecognizer:self.panGesture];
        [self.selectedBackgroundView setUserInteractionEnabled:YES];
    }
    else{
        [self.selectedBackgroundView removeGestureRecognizer:self.panGesture];
        [self.selectedBackgroundView setUserInteractionEnabled:NO];
    }
}
- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)pan:(UIPanGestureRecognizer *)reconizer
{
    [self adjustAnchorPointForGestureRecognizer:reconizer];
    
    if (reconizer.state == UIGestureRecognizerStateBegan) {
        _initialDraggingPoint = self.selectedBackgroundView.layer.position;
        
    }
    else if (reconizer.state == UIGestureRecognizerStateChanged){
        CGPoint translation = [reconizer translationInView:[self.selectedBackgroundView superview]];
        CGFloat correctedTranslation = translation.x;
        [self.selectedBackgroundView setCenter:CGPointMake([self.selectedBackgroundView center].x +
                                                           correctedTranslation,
                                                           [self.selectedBackgroundView center].y)];
        [reconizer setTranslation:CGPointZero inView:[self.selectedBackgroundView superview]];
        
    }
    else if (reconizer.state == UIGestureRecognizerStateEnded || reconizer.state == UIGestureRecognizerStateCancelled){
        NSArray *buttons = [self buttonsIntersectForFrame:self.selectedBackgroundView.frame];
        if (buttons.count == 1) {
            [self setSelectedButton:[buttons objectAtIndex:0]];
        }
        else{
            CGRect firstIntersection = CGRectIntersection(self.selectedBackgroundView.frame, [[buttons objectAtIndex:0]frame]);
            CGRect secondIntersection = CGRectIntersection(self.selectedBackgroundView.frame, [[buttons objectAtIndex:1]frame]);
            if (firstIntersection.size.width < secondIntersection.size.width) {
                [self setSelectedButton:[buttons objectAtIndex:1]];
            }
            else{
                [self setSelectedButton:[buttons objectAtIndex:0]];
            }
        }
    }
}

- (NSArray *)buttonsIntersectForFrame:(CGRect)frame
{
    NSMutableArray *intersections = [[NSMutableArray alloc]initWithCapacity:2];
    for (UIButton *button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            BOOL intersect = CGRectIntersectsRect(button.frame, frame);
            if (intersect) {
                [intersections addObject:button];
            }
            intersect = NO;
        }
    }
    return intersections;
}

@end
