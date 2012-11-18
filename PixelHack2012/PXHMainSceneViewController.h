//
//  PXHMainSceneViewController.h
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXHSelectImageDelegate.h"

@interface PXHMainSceneViewController : UIViewController <PXHSelectImageDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *backgroundView;

- (IBAction)selectBackground:(id)sender;
- (IBAction)addActor:(id)sender;
- (IBAction)togglePlayback:(id)sender;

@end
