//
//  PXHPathView.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHPathView.h"

@implementation PXHPathView {
    NSMutableArray *_controlPoints;
    CGPoint _startPoint;
    CGPoint _lastPoint;
    UIBezierPath *_bezierPath;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self addGestureRecognizer:panRecognizer];
}

- (void)didPan:(UIPanGestureRecognizer *)sender
{
    CGPoint translation = [sender translationInView:self];
    CGPoint currentPoint = CGPointMake(_startPoint.x + translation.x, _startPoint.y + translation.y);
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            [_bezierPath addLineToPoint:currentPoint];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint midPoint = CGPointGetMidpoint(_lastPoint, currentPoint);
            [_bezierPath addQuadCurveToPoint:midPoint controlPoint:_lastPoint];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            [_bezierPath addLineToPoint:currentPoint];
            [_bezierPath closePath];
            [self setNeedsDisplay];
        }
        case UIGestureRecognizerStateFailed: {
            _controlPoints = nil;
            _startPoint = CGPointZero;
            _lastPoint = CGPointZero;
            break;
        }
        default:
            break;
    }
//    CGRect displayRect = CGRectMake(MIN(_lastPoint.x, currentPoint.x),
//                                    MIN(_lastPoint.y, currentPoint.y),
//                                    MAX(_lastPoint.x, currentPoint.y),
//                                    MAX(_lastPoint.y, currentPoint.y));
//    displayRect = CGRectInset(displayRect, -5, -5);
//    
//    [self setNeedsDisplayInRect:displayRect];
    [self setNeedsDisplay];
    
    _lastPoint = currentPoint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (touches.count == 1) {
        UITouch *touch = [touches anyObject];
        _startPoint = [touch locationInView:self];
        _bezierPath = [[UIBezierPath alloc] init];
        [_bezierPath moveToPoint:_startPoint];
        [self setNeedsDisplay];
        _lastPoint = _startPoint;
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
}

static inline CGPoint CGPointGetMidpoint(CGPoint p2, CGPoint p1) {
    return CGPointMake((p2.x + p1.x) / 2.0f, (p2.y + p1.y) / 2.0f);
}

- (void)displayImage:(UIImage *)image
{
    if (image == nil)
        return;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.alpha = 0.0f;
    imageView.frame = self.bounds;
    [self addSubview:imageView];
    
    const NSTimeInterval duration = 0.25f;
    [UIView animateWithDuration:duration
                     animations:^{
                         imageView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         if (!finished)
                             return;
                         
                         [UIView animateWithDuration:duration
                                               delay:duration
                                             options:0
                                          animations:^{
                                              imageView.alpha = 0.0f;
                                          }
                                          completion:^(BOOL finished) {
                                              if (!finished)
                                                  return;
                                              [imageView removeFromSuperview];
                                          }];
                     }];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetShadowWithColor(context, CGSizeZero, 10.0f, [lineColor CGColor]);
    [[UIColor colorWithRed:0 green:235.0f/255.0f blue:149.0f/255.0f alpha:1] set];
    _bezierPath.lineCapStyle = kCGLineCapRound;
    _bezierPath.lineJoinStyle = kCGLineJoinRound;
    _bezierPath.lineWidth = 3;
    CGContextClipToRect(context, rect);
    [_bezierPath stroke];
}

@end
