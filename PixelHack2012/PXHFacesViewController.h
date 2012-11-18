//
//  PXHFacesViewController.h
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-18.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PXHFace;

@interface PXHFacesViewController : UICollectionViewController

@property (nonatomic, copy) void (^completionBlock)(PXHFacesViewController *controller, NSArray *faceImages);

@end
