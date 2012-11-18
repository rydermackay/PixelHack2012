//
//  PXHSelectActorViewController.h
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXHSelectActorViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

- (IBAction)tappedAddActor:(id)sender;
@property (nonatomic, copy) void (^completionBlock)(PXHSelectActorViewController *controller, UIImage *image);

@end
