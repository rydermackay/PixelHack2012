//
//  PXHEditViewController.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHEditViewController.h"
//#import "AFPhotoEditorController.h"
#import "PXHPhotoEditorController.h"

@interface PXHEditViewController () <AFPhotoEditorControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)filtersButtonTapped:(id)sender;
@end



@implementation PXHEditViewController

- (IBAction)filtersButtonTapped:(id)sender
{
    PXHPhotoEditorController *controller = [[PXHPhotoEditorController alloc] initWithImage:self.image options:nil];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

- (id)initWithImage:(UIImage *)image
{
    self = [[UIStoryboard storyboardWithName:@"PXHEditViewController" bundle:nil] instantiateInitialViewController];
    if (self != nil) {
        _image = image;
    }
    
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.imageView.image = self.image;
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        return;
    }
    
    _image = image;
    self.imageView.image = _image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AFPhotoEditorControllerDelegate methods

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    self.image = image;
    [editor dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    [editor dismissViewControllerAnimated:YES completion:nil];
}

@end
