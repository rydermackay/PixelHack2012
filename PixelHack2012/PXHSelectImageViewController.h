//
//  PXHSelectImageViewController.h
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXHSelectImageDelegate.h"

@interface PXHSelectImageViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) id<PXHSelectImageDelegate> delegate;

@end
