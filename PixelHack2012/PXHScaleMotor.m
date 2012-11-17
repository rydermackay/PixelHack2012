//
//  PXHScaleMotor.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHScaleMotor.h"

@implementation PXHScaleMotor

- (id)linkedValueKeyPath
{
    return @"transform";
}

- (void)updateLinkedViewWithSample:(CGFloat)sample
{
    CGAffineTransform transform = [[self valueForSample:sample] CGAffineTransformValue];
    self.linkedView.transform = CGAffineTransformConcat([self.originalValue CGAffineTransformValue], transform);
}

- (id)valueForSample:(CGFloat)sample
{
    CGFloat scale = self.amplitude * (1 + sample);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    return [NSValue valueWithCGAffineTransform:scaleTransform];
}

@end
