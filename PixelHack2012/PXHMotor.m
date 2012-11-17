//
//  PXHMotor.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHMotor.h"

@implementation PXHMotor

- (id)linkedValueKeyPath
{
    return nil;
}

- (void)setLinkedView:(UIView *)linkedView
{
    _linkedView = linkedView;
    _originalValue = [linkedView valueForKeyPath:self.linkedValueKeyPath];
}

- (void)updateLinkedViewWithSample:(CGFloat)sample
{
    
}

- (id)valueForSample:(CGFloat)sample
{
    return nil;
}

@end
