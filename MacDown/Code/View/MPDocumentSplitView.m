//
//  MPDocumentSplitView.m
//  MacDown
//
//  Created by Tzu-ping Chung on 13/12.
//  Copyright (c) 2014 Tzu-ping Chung . All rights reserved.
//

#import "MPDocumentSplitView.h"


static const CGFloat kPartMinimumVisualSize = 150.0; // must be ≥ `kPartSnapToZeroBelowSize`a
static const CGFloat kPartSnapToZeroBelowSize = 100.0; // must be ≤ `kPartMinimumVisualSize`
static const CGFloat kDividerStickAtHalfWayGap = 15.0; // Halfway point ± this many pixels



@implementation NSColor (Equality)

- (BOOL)isEqualToColor:(NSColor *)color
{
    NSColor *rgb1 = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    NSColor *rgb2 = [color colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
    return rgb1 && rgb2 && [rgb1 isEqual:rgb2];
}

@end


@implementation MPDocumentSplitView

@synthesize dividerColor = _dividerColor;

- (NSColor *)dividerColor
{
    if (_dividerColor)
        return _dividerColor;
    return [super dividerColor];
}

- (void)setDividerColor:(NSColor *)color
{
    if ([color isEqualToColor:_dividerColor])
        return;
    _dividerColor = color;
    [self setNeedsDisplay:YES];
}

- (CGFloat)normalizeSplitPosition:(CGFloat)splitPosition
{
    NSArray *parts = self.subviews;
    NSAssert1(parts.count == 2, @"%@ should only be used on two-item splits.",
              NSStringFromSelector(_cmd));
    
    CGFloat totalWidth = self.bounds.size.width;
    CGFloat usableWidth = totalWidth - self.dividerThickness;
    CGFloat halfwayPosition = usableWidth * 0.5;
    if (splitPosition < kPartMinimumVisualSize) {
        if (splitPosition < kPartSnapToZeroBelowSize)
            splitPosition = 0;
        else
            splitPosition = kPartMinimumVisualSize;
    }
    else if (splitPosition > usableWidth - kPartMinimumVisualSize) {
        if (splitPosition > usableWidth - kPartSnapToZeroBelowSize)
            splitPosition = usableWidth;
        else
            splitPosition = usableWidth - kPartMinimumVisualSize;
    }
    else if (splitPosition > (halfwayPosition - kDividerStickAtHalfWayGap) &&
             splitPosition < (halfwayPosition + kDividerStickAtHalfWayGap)) {
        splitPosition = halfwayPosition;
    }
    return splitPosition;
}

- (CGFloat)normalizeDividerLocation:(CGFloat)dividerLocation
{
    CGFloat usableWidth = self.bounds.size.width - self.dividerThickness;
    return [self normalizeSplitPosition:(dividerLocation / usableWidth)] * usableWidth;
}

- (CGFloat)dividerLocation
{
    NSArray *parts = self.subviews;
    NSAssert1(parts.count == 2, @"%@ should only be used on two-item splits.",
              NSStringFromSelector(_cmd));

    CGFloat totalWidth = self.frame.size.width - self.dividerThickness;
    CGFloat leftWidth = [parts[0] frame].size.width;
    return leftWidth / totalWidth;
}

- (void)setDividerLocation:(CGFloat)ratio
{
    NSArray *parts = self.subviews;
    NSAssert1(parts.count == 2, @"%@ should only be used on two-item splits.",
              NSStringFromSelector(_cmd));
    if (ratio < 0.0)
        ratio = 0.0;
    else if (ratio > 1.0)
        ratio = 1.0;
    CGFloat dividerThickness = self.dividerThickness;
    CGFloat totalWidth = self.frame.size.width - dividerThickness;
    CGFloat leftWidth = totalWidth * ratio;
    CGFloat rightWidth = totalWidth - leftWidth;
    NSView *left = parts[0];
    NSView *right = parts[1];

    left.frame = NSMakeRect(0.0, 0.0, leftWidth, left.frame.size.height);
    right.frame = NSMakeRect(leftWidth + dividerThickness, 0.0,
                             rightWidth, right.frame.size.height);
    [self setPosition:leftWidth ofDividerAtIndex:0];
}

- (void)swapViews
{
    NSArray *parts = self.subviews;
    NSView *left = parts[0];
    NSView *right = parts[1];
    self.subviews = @[right, left];
}


@end
