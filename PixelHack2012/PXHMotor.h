//
//  PXHMotor.h
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PXHMotor : NSObject

@property (nonatomic, weak) IBOutlet UIView *linkedView;
@property (nonatomic, strong, readonly) id originalValue;
@property (nonatomic, assign) CGFloat amplitude; // default is 1. multiplies effect.
- (void)updateLinkedViewWithSample:(CGFloat)sample; // 0 to 1.0

// subclasses override
@property (nonatomic, readonly) id linkedValueKeyPath;
- (id)valueForSample:(CGFloat)sample; // sample between 0 and 1.0

@end
