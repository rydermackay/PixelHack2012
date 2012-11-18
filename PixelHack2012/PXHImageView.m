//
//  PXHImageView.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-18.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHImageView.h"
#import "UIImage+INKAlphaData.h"

@implementation PXHImageView

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    @autoreleasepool {
        BOOL pointInside = [super pointInside:point withEvent:event];
        if (pointInside) {
            pointInside = [self.image isPointOpaque:point];
        }
        
        return pointInside;
    }
}

@end
