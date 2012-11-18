//
//  PXHImageCycleMotor.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-18.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHImageCycleMotor.h"

@implementation PXHImageCycleMotor

- (id)linkedValueKeyPath
{
    return @"image";
}

- (UIImageView *)imageView
{
    UIImageView *imageView = (UIImageView *)self.linkedView;
    NSParameterAssert([imageView isKindOfClass:[UIImageView class]]);
    return imageView;
}

- (void)updateLinkedViewWithSample:(CGFloat)sample
{
    NSUInteger idx = [[self valueForSample:sample] unsignedIntegerValue];
    UIImageView *imageView = [self imageView];
    imageView.image = imageView.animationImages[idx];
}

- (id)valueForSample:(CGFloat)sample
{
    UIImageView *imageView = [self imageView];
    sample = sample * 5;
    if (sample > 1) {
        sample = 1;
    }
    NSUInteger idx = floorf((imageView.animationImages.count - 1) * sample);
    return @(idx);
}

@end
