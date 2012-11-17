//
//  PXHSelectImageDelegate.h
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PXHSelectImageViewController;

@protocol PXHSelectImageDelegate <NSObject>

- (void)selectImageViewController:(PXHSelectImageViewController *)controller didSelectImage:(UIImage *)image;

@end
