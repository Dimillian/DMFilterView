//
//  MSFilterViewController.m
//  MySeeen
//
//  Created by Thomas Ricouard on 19/04/13.
//
//

#import "DMFilterView.h"

const CGFloat kFilterViewHeight = 44.0;
const CGFloat kAnimationSpeed = 0.20;
@interface DMFilterView ()
{
    NSMutableArray *_strings;
}
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) UIImageView *selectedBackgroundImageView;

- (void)updateButtonsStyle;
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
        [_backgroundView setImage:[UIImage imageNamed:@"tabbar"]];
        [self addSubview:self.backgroundView];
        CGFloat x = 0.0;
        CGFloat buttonWidth = self.frame.size.width/strings.count;
        NSInteger tag = 0;
        _selectedBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          buttonWidth,
                                                                          self.frame.size.height)];
        _selectedBackgroundImageView = [[UIImageView alloc]initWithFrame:self.selectedBackgroundView.frame];
        [_selectedBackgroundImageView setImage:[UIImage imageNamed:@"tabbar_select"]];
        [self.selectedBackgroundView addSubview:self.selectedBackgroundImageView];
        [self addSubview:self.selectedBackgroundView];
        for (NSString *string in strings) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTag:tag];
            [button setFrame:CGRectMake(x,
                                        0,
                                        buttonWidth,
                                        self.frame.size.height)];
            [button setTitle:string forState:UIControlStateNormal];
            UIColor *mColor = [UIColor colorWithRed:240/255.0
                                              green:130/255.0
                                               blue:76/255.0
                                              alpha:1.0];
            [button setTitleColor:mColor forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button addTarget:self
                       action:@selector(onButton:)
             forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            x += buttonWidth;
            tag += 1;
        }
    }
    return self;
}

#pragma mark - display
- (void)attachToContainerView
{
    if (!self.superview) {
        [self.containerView addSubview:self];   
    }
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
    CGFloat animationSpeed;
    if ([self.delegate respondsToSelector:@selector(filterViewSelectionAnimationSpeed:)]) {
        animationSpeed = [self.delegate filterViewSelectionAnimationSpeed:self];
    }
    else{
        animationSpeed = kAnimationSpeed;
    }
    [UIView animateWithDuration:animationSpeed
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         if ([self.delegate respondsToSelector:
                              @selector(filterViewSelectionAnimationDidBegin:)]) {
                             [self.delegate
                              filterViewSelectionAnimationDidBegin:self];
                         }
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
    if (_selectedIndex == selectedIndex) {
        return;
    }
    NSAssert(selectedIndex < _strings.count, @"requested index is out of bounds");
    UIButton *selectedButton;
    for (UIButton *button in self.subviews) {
        if (button.tag == selectedIndex) {
            selectedButton = button;
            break;
        }
    }
    [self onButton:selectedButton];
}

#pragma mark - Background
- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage == backgroundImage)
        return;
    _backgroundImage = backgroundImage;
    [self.backgroundView setHidden:NO];
    [self.backgroundView setImage:_backgroundImage];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [self.backgroundView setHidden:YES];
    [super setBackgroundColor:backgroundColor];
}

-(void)setSelectedBackgroundImage:(UIImage *)selectedBackgroundImage
{
    if(_selectedBackgroundImage == selectedBackgroundImage)
        return;
    [self.selectedBackgroundImageView setHidden:NO];
    [self.selectedBackgroundImageView setImage:selectedBackgroundImage];
    _selectedBackgroundImage = selectedBackgroundImage;
}

-(void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if(_selectedBackgroundColor == selectedBackgroundColor)
        return;
    [self.selectedBackgroundImageView setHidden:YES];
    [self.selectedBackgroundView setBackgroundColor:selectedBackgroundColor];
    _selectedBackgroundColor = selectedBackgroundColor;
}

#pragma mark - buttons style
-(void)setTitlesColor:(UIColor *)titlesColor
{
    if(_titlesColor == titlesColor)
        return;
    _titlesColor = titlesColor;
    [self updateButtonsStyle];
}

-(void)setTitlesFont:(UIFont *)titlesFont
{
    if(_titlesFont == titlesFont)
        return;
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

@end
