//
//  PXHMainSceneViewController.m
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHMainSceneViewController.h"
#import "PXHSelectImageViewController.h"
#import "PXHSelectActorViewController.h"

@interface PXHMainSceneViewController ()

@property (nonatomic, strong) UIPopoverController *currentPopoverController;

@end

@implementation PXHMainSceneViewController


- (IBAction)selectBackground:(id)sender
{
    if (self.currentPopoverController != nil) {
        [self.currentPopoverController dismissPopoverAnimated:YES];
        self.currentPopoverController = nil;
    } else {
        PXHSelectImageViewController *selectImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectImagesController"];
        selectImageViewController.delegate = self;
        self.currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:selectImageViewController];
        [self.currentPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)addActor:(id)sender {
    if (self.currentPopoverController != nil) {
        [self.currentPopoverController dismissPopoverAnimated:YES];
        self.currentPopoverController = nil;
    } else {
        PXHSelectActorViewController *addViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectActorController"];
//        addViewController.delegate = self;
        self.currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:addViewController];
        [self.currentPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }    
}

- (void)selectImageViewController:(PXHSelectImageViewController *)controller didSelectImage:(UIImage *)image
{
    self.backgroundView.image = image;
    [self.currentPopoverController dismissPopoverAnimated:YES];
    self.currentPopoverController = nil;
}

@end
