//
//  MKNumberBadgeView.h
//  QQSimulator
//
//  Created by Jackie Liu on 16/3/2.
//  Copyright © 2016年 Jackie Liu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MKNumberBadgeView : UIView
{
    NSUInteger _value;
}

// Text format for the badge, defaults to just the number
@property (retain,nonatomic) NSString *textFormat;

// Adjustment offset for the text in the badge
@property (assign,nonatomic) CGPoint adjustOffset;

// The current value displayed in the badge. Updating the value will update the view's display
@property (assign,nonatomic) NSUInteger value;

// Indicates whether the badge view draws a dhadow or not.
@property (assign,nonatomic) BOOL shadow;

// The offset for the shadow, if there is one.
@property (assign,nonatomic) CGSize shadowOffset;

// The base color for the shadow, if there is one.
@property (retain,nonatomic) UIColor * shadowColor;

// Indicates whether the badge view should be drawn with a shine
@property (assign,nonatomic) BOOL shine;

// The font to be used for drawing the numbers. NOTE: not all fonts are created equal for this purpose.
// Only "system fonts" should be used.
@property (retain,nonatomic) UIFont* font;

// The color used for the background of the badge.
@property (retain,nonatomic) UIColor* fillColor;

// The color to be used for drawing the stroke around the badge.
@property (retain,nonatomic) UIColor* strokeColor;

// The width for the stroke around the badge.
@property (assign,nonatomic) CGFloat strokeWidth;

// The color to be used for drawing the badge's numbers.
@property (retain,nonatomic) UIColor* textColor;

// How the badge image hould be aligned horizontally in the view.
@property (assign,nonatomic) NSTextAlignment alignment;

// Returns the visual size of the badge for the current value. Not the same hing as the size of the view's bounds.
// The badge view bounds should be wider than space needed to draw the badge.
@property (readonly,nonatomic) CGSize badgeSize;

// The number of pixels between the number inside the badge and the stroke around the badge. This value
// is approximate, as the font geometry might effectively slightly increase or decrease the apparent pad.
@property (nonatomic) NSUInteger pad;

// If YES, the badge will be hidden when the value is 0
@property (nonatomic) BOOL hideWhenZero;

@end