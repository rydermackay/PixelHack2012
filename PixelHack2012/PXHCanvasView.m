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
#import "PXHImageView.h"
#import "PXHImageCycleMotor.h"

@interface PXHCanvasView () <UIGestureRecognizerDelegate>

@end



@implementation PXHCanvasView {
    NSMutableArray *_motors;
    CADisplayLink *_displayLink;
    CGFloat _averageSample;
    UIView *_trackingView;
    NSMutableArray *_actors;
    CGPoint _trackingViewCenter;
    CGFloat _angle;
    CGFloat _scale;
    UIView *_selectedView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _actors = [NSMutableArray new];
    _scale = 1.0f;
    _angle = 0.0f;
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    panRecognizer.delegate = self;
    panRecognizer.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(didRotate:)];
    rotationRecognizer.delegate = self;
    [self addGestureRecognizer:rotationRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
    pinchRecognizer.delegate = self;
    [self addGestureRecognizer:pinchRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tapRecognizer.delegate = self;
    [self addGestureRecognizer:tapRecognizer];
}

- (IBAction)didPan:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self];
    _trackingView.center = CGPointMake(_trackingViewCenter.x + translation.x, _trackingViewCenter.y + translation.y);
    
    switch (sender.state) {
        case UIGestureRecognizerStateCancelled: {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 _trackingView.center = _trackingViewCenter;
                                 _trackingView.alpha = 1.0f;
                             }];
            _trackingView = nil;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [UIView animateWithDuration:0.2f
                             animations:^{
                                 _trackingView.alpha = 1.0f;
                             }];
            _trackingView = nil;
            break;
        }
        default:
            break;
    }
}

- (IBAction)didRotate:(UIRotationGestureRecognizer *)sender
{
    CGFloat rotation = sender.rotation;
    CGFloat deltaAngle = rotation - _angle;
    
    NSUInteger index = [_motors indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ([[obj linkedView] isEqual:_trackingView]) {
            return YES;
        } else {
            return NO;
        }
    }];
    
    CGAffineTransform transform = CGAffineTransformMakeRotation(deltaAngle);

    if (index == NSNotFound) {
        _trackingView.transform = CGAffineTransformConcat(_trackingView.transform, transform);
    } else {
        PXHRotateMotor *motor = _motors[index];
        transform = CGAffineTransformConcat(transform, [motor.originalValue CGAffineTransformValue]);
        [motor setValue:[NSValue valueWithCGAffineTransform:transform] forKey:@"originalValue"];
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _angle = rotation;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            _angle = 0;
            break;
        default:
            break;
    }
}

- (IBAction)didPinch:(UIPinchGestureRecognizer *)sender
{
    CGFloat scale = sender.scale;
    CGFloat deltaScale = scale - _scale + 1;
    NSUInteger index = [_motors indexOfObjectPassingTest:^BOOL(PXHMotor *motor, NSUInteger idx, BOOL *stop) {
        return [motor.linkedView isEqual:_trackingView];
    }];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(deltaScale, deltaScale);
    
    if (index == NSNotFound) {
        _trackingView.transform = CGAffineTransformConcat(_trackingView.transform, transform);
    } else {
        PXHScaleMotor *motor = _motors[index];
        transform = CGAffineTransformConcat(transform, [motor.originalValue CGAffineTransformValue]);
        [motor setValue:[NSValue valueWithCGAffineTransform:transform] forKey:@"originalValue"];
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            _scale = scale;
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            _scale = 1.0f;
            break;
        default:
            break;
    }
}

- (void)didTap:(UITapGestureRecognizer *)sender
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    CGPoint point = [sender locationInView:self];
    
    UIView *view = [self hitTest:point withEvent:nil];
    if ([view isEqual:self]) {
        _selectedView = nil;
        return;
    }
    
    _selectedView = view;
    
    if ([_actors containsObject:view]) {
        NSIndexSet *indexSet = [_motors indexesOfObjectsPassingTest:^BOOL(PXHMotor *motor, NSUInteger idx, BOOL *stop) {
            return [motor.linkedView isEqual:view];
        }];
        
        NSMutableArray *menuItems = [NSMutableArray new];
        
        BOOL hasMotor = indexSet.count > 0;

        if (hasMotor) {
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Remove Motors" action:@selector(removeMotors:)]];
        }
        else {
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Add Scale" action:@selector(addScaleMotor:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Add Rotate" action:@selector(addRotateMotor:)]];
            [menuItems addObject:[[UIMenuItem alloc] initWithTitle:@"Add Translate" action:@selector(addTranslateMotor:)]];
        }

        
        [self becomeFirstResponder];
        UIMenuController *controller = [UIMenuController sharedMenuController];
        controller.menuItems = menuItems;
        [controller setTargetRect:view.frame inView:self];
        [controller update];
        [controller setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    // start tracking view in first touch
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if ([_actors containsObject:view] && [view isEqual:_trackingView] == NO) {
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             _trackingView.alpha = 1.0f;
                         }];
        
        _trackingView = view;
        _trackingViewCenter = view.center;
        [self bringSubviewToFront:view];
        
        [UIView animateWithDuration:0.2f
                         animations:^{
                             view.alpha = 0.5f;
                         }];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if ([[[touches anyObject] view] isEqual:_trackingView]) {
        [UIView animateWithDuration:0.2f
                         animations:^{
                             _trackingView.alpha = 1.0f;
                         }];
        _trackingView = nil;
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (self.window != nil) {
        _motors = [NSMutableArray new];
//        [self testMotors];
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
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0f
                                               green:arc4random_uniform(255)/255.0f
                                                blue:arc4random_uniform(255)/255.0f
                                               alpha:1.0f];
        
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
        [_actors addObject:view];
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

- (void)insertActorWithImage:(UIImage *)image
{
    PXHImageView *imageView = [[PXHImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
    imageView.center = self.center;
    [self addSubview:imageView];
    [_actors addObject:imageView];
}

- (void)insertFaceWithImages:(NSArray *)images
{
    PXHImageView *imageView = [[PXHImageView alloc] initWithImage:images[0]];
    imageView.animationImages = images;
    imageView.userInteractionEnabled = YES;
    imageView.center = self.center;
    [self addSubview:imageView];
    [_actors addObject:imageView];
    PXHImageCycleMotor *motor = [[PXHImageCycleMotor alloc] init];
    motor.linkedView = imageView;
    [_motors addObject:motor];
}

- (IBAction)addTranslateMotor:(id)sender
{
    PXHTranslateMotor *motor = [[PXHTranslateMotor alloc] init];
    CGFloat x = arc4random_uniform(100);
    CGFloat y = arc4random_uniform(100);
    motor.translation = CGPointMake(x, y);
    motor.linkedView = _selectedView;
    motor.amplitude = arc4random_uniform(40) / 10.0f - 2.0f;
    [_motors addObject:motor];
}

- (IBAction)addRotateMotor:(id)sender
{
    PXHRotateMotor *motor = [[PXHRotateMotor alloc] init];
    motor.linkedView = _selectedView;
    motor.amplitude = arc4random_uniform(40) / 10.0f - 2.0f;
    [_motors addObject:motor];
}

- (IBAction)addScaleMotor:(id)sender
{
    PXHScaleMotor *motor = [[PXHScaleMotor alloc] init];
    motor.linkedView = _selectedView;
    motor.amplitude = arc4random_uniform(40) / 10.0f - 2.0f;
    [_motors addObject:motor];
}

- (void)removeMotorsOfClass:(Class)motorClass linkedToView:(UIView *)linkedView
{
    for (PXHMotor *motor in [_motors copy]) {
        if ([motor isMemberOfClass:motorClass] && [motor.linkedView isEqual:linkedView]) {
            [motor.linkedView setValue:motor.originalValue forKey:motor.linkedValueKeyPath];
            [_motors removeObject:motor];
        }
    }
}

- (IBAction)removeMotors:(id)sender
{
    for (PXHMotor *motor in [_motors copy]) {
        if ([motor.linkedView isEqual:_selectedView]) {
            [motor.linkedView setValue:motor.originalValue forKey:motor.linkedValueKeyPath];
            [_motors removeObject:motor];
        }
    }
}

- (IBAction)removeScaleMotor:(id)sender
{
    [self removeMotorsOfClass:[PXHScaleMotor class] linkedToView:_selectedView];
}

- (IBAction)removeTranslateMotor:(id)sender
{
    [self removeMotorsOfClass:[PXHTranslateMotor class] linkedToView:_selectedView];
}

- (IBAction)removeRotateMotor:(id)sender
{
    [self removeMotorsOfClass:[PXHRotateMotor class] linkedToView:_selectedView];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(delete:)) {
        return _selectedView != nil;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (IBAction)delete:(id)sender
{
    [self removeMotors:sender];
    
    [_actors removeObject:_selectedView];
    [_selectedView removeFromSuperview];
    _selectedView = nil;
}

@end
