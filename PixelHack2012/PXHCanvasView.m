//
//  PXHCanvasView.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHCanvasView.h"
#import <QuartzCore/QuartzCore.h>
#import "PXHAudio.h"
#import "PXHScaleMotor.h"
#import "PXHRotateMotor.h"
#import "PXHTranslateMotor.h"

@implementation PXHCanvasView {
    NSMutableArray *_motors;
    CADisplayLink *_displayLink;
    CGFloat _averageSample;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (self.window != nil) {
        _motors = [NSMutableArray new];
        [self testMotors];
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLink:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)testMotors
{
    for (int i = 0; i < 15; i++) {
        CGRect frame = CGRectMake(0, 0, 100, 100);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.center = CGPointRandomInRect(CGRectInset(self.bounds, 50, 50));
        view.backgroundColor = [UIColor redColor];
        
        PXHMotor *motor;
        
        switch (i % 3) {
            case 0:
                motor = [[PXHScaleMotor alloc] init];
                break;
            case 1:
                motor = [[PXHRotateMotor alloc] init];
                break;
            case 2: {
                PXHTranslateMotor *translateMotor = [[PXHTranslateMotor alloc] init];
                CGFloat x = arc4random_uniform(100);
                CGFloat y = arc4random_uniform(100);
                translateMotor.translation = CGPointMake(x, y);
                motor = translateMotor;
                break;
            }
        }
        
        motor.amplitude = arc4random_uniform(40) / 10.0f - 2.0f;
        motor.linkedView = view;
        
        [self addSubview:view];
        [_motors addObject:motor];
    }
}

static inline CGPoint CGPointRandomInRect(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect) + (CGFloat)arc4random_uniform(CGRectGetMaxX(rect)),
                       CGRectGetMinY(rect) + (CGFloat)arc4random_uniform(CGRectGetMaxY(rect)));
}

- (void)displayLink:(CADisplayLink *)sender
{
    __unused NSTimeInterval time = sender.duration;
    AudioSampleType sample = [[PXHAudio sharedInstance] averageSample];
    CGFloat ampedSample = sample * 4.0f;
    CGFloat normalizedSample = ampedSample / (CGFloat)INT16_MAX;
    
    CGFloat weight = 0.1f;
    _averageSample = _averageSample * (1 - weight) + normalizedSample * weight;
    
    for (PXHMotor *motor in _motors) {
        [motor updateLinkedViewWithSample:_averageSample];
    }
}

@end
