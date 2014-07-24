//
// Created by Adam Miskiewicz on 12/19/13.
// Copyright (c) 2013 WeGo. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if(self) {
        self.alpha = 1.f;
    }

    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *startColor;
    if (self.baseColor) {
        startColor = self.baseColor;
    }
    else {
        startColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
    }
    NSArray *gradientColors = [NSArray arrayWithObjects:(id) startColor.CGColor, (id) [UIColor clearColor].CGColor, nil];

    CGFloat gradientLocations[] = {1, 0.05, 0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint startPoint, endPoint;
    if (self.top) {
        startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
        endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    }
    else {
        startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
        endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    }

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

@end