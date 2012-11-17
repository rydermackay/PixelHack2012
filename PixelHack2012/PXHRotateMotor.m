//
//  PXHRotateMotor.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHRotateMotor.h"

@implementation PXHRotateMotor

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
    CGFloat scale = self.amplitude * M_PI * sample;
    CGAffineTransform transform = CGAffineTransformMakeRotation(scale);
    return [NSValue valueWithCGAffineTransform:transform];
}

@end
