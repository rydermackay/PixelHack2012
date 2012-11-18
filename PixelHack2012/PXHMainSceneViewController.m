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
#import "PXHAudio.h"

@interface PXHMainSceneViewController ()

@property (nonatomic, strong) UIPopoverController *currentPopoverController;

@end

@implementation PXHMainSceneViewController {
    __weak UIPopoverController *_imagePopoverController;
    __weak UIPopoverController *_actorPopoverController;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL shouldPerform = YES;
    if ([identifier isEqualToString:@"selectImageSegue"] && _imagePopoverController != nil) {
        shouldPerform = NO;
    }
    else if ([identifier isEqualToString:@"selectActorSegue"] && _actorPopoverController != nil) {
        shouldPerform = NO;
    }
        
    [_currentPopoverController dismissPopoverAnimated:YES];
    _currentPopoverController = nil;
    
    return shouldPerform;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self.currentPopoverController dismissPopoverAnimated:YES];
    self.currentPopoverController = nil;
    
    if ([segue.identifier isEqualToString:@"selectImageSegue"]) {
        PXHSelectImageViewController *controller = [(PXHSelectImageViewController *)segue.destinationViewController childViewControllers][0];
        NSParameterAssert([controller isKindOfClass:[PXHSelectImageViewController class]]);
        NSParameterAssert([segue isKindOfClass:[UIStoryboardPopoverSegue class]]);
        controller.delegate = self;

        _imagePopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.currentPopoverController = _imagePopoverController;
    }
    else if ([segue.identifier isEqualToString:@"selectActorSegue"]) {
        PXHSelectActorViewController *controller = [(PXHSelectActorViewController *)segue.destinationViewController childViewControllers][0];
        NSParameterAssert([controller isKindOfClass:[PXHSelectActorViewController class]]);
        NSParameterAssert([segue isKindOfClass:[UIStoryboardPopoverSegue class]]);

        _actorPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.currentPopoverController = _actorPopoverController;
    }
}

- (IBAction)togglePlayback:(UIButton *)sender
{
    PXHAudio *audio = [PXHAudio sharedInstance];
    audio.playing = !audio.isPlaying;
    
    NSString *title = audio.isPlaying ? @"Pause" : @"Play";
    [sender setTitle:title forState:UIControlStateNormal];
}

- (void)selectImageViewController:(PXHSelectImageViewController *)controller didSelectImage:(UIImage *)image
{
    self.backgroundView.image = image;
    [self.currentPopoverController dismissPopoverAnimated:YES];
    self.currentPopoverController = nil;
}

@end
