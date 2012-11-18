//
//  PXHEditViewController.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHEditViewController.h"
#import "PXHPathControl.h"
#import "PXHPhotoEditorController.h"
#import <QuartzCore/QuartzCore.h>

@interface PXHEditViewController () <AFPhotoEditorControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)cancelButtonTapped:(id)sender;
- (IBAction)doneButtonTapped:(id)sender;
- (IBAction)filtersButtonTapped:(id)sender;
@property (strong, nonatomic) IBOutlet PXHPathControl *pathControl;
- (IBAction)pathControlChanged:(id)sender;

- (void)updateInterface;

@end



@implementation PXHEditViewController

- (IBAction)cancelButtonTapped:(id)sender
{
    __weak PXHEditViewController *blockSelf = self;
    if (self.completionBlock) {
        self.completionBlock(blockSelf, nil);
    }
}

- (IBAction)doneButtonTapped:(id)sender
{
    UIImage *image;
    UIBezierPath *path = self.pathControl.path;
    if (path.isEmpty || path == nil) {
        image = self.image;
    }
    else {
        image = [self clippedImage];
    }
    
    __weak PXHEditViewController *blockSelf = self;
    if (self.completionBlock) {
        self.completionBlock(blockSelf, image);
    }
}

- (UIImage *)clippedImage
{
    UIBezierPath *path = self.pathControl.path;
    CGRect pathBounds = path.bounds;
    
    UIGraphicsBeginImageContextWithOptions(pathBounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-CGRectGetMinX(pathBounds), -CGRectGetMinY(pathBounds));
    [path applyTransform:transform];
    [path addClip];
    
    // image rect
    CGRect imageViewBounds = self.imageView.bounds;
    CGSize imageSize = self.imageView.image.size;
    
    CGFloat widthScale = CGRectGetWidth(imageViewBounds) / imageSize.width;
    CGFloat heightScale = CGRectGetHeight(imageViewBounds) / imageSize.height;
    CGFloat scale = MIN(widthScale, heightScale);
    
    CGRect imageFrame = CGRectMake(floorf((CGRectGetWidth(imageViewBounds) - imageSize.width * scale) / 2.0f),
                                   floorf((CGRectGetHeight(imageViewBounds) - imageSize.height * scale) / 2.0f),
                                   imageSize.width * scale,
                                   imageSize.height * scale);
    imageFrame = CGRectOffset(imageFrame, -CGRectGetMinX(pathBounds), -CGRectGetMinY(pathBounds));
    [self.image drawInRect:imageFrame blendMode:kCGBlendModeCopy alpha:1];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (IBAction)filtersButtonTapped:(id)sender
{
    PXHPhotoEditorController *controller = [[PXHPhotoEditorController alloc] initWithImage:self.image options:nil];
    controller.delegate = self;
    controller.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)pathControlChanged:(id)sender
{
    [self updateInterface];
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
    
    [self updateInterface];
}

- (void)updateInterface
{
    self.imageView.image = self.image;
}

- (void)setImage:(UIImage *)image
{
    if (_image == image) {
        return;
    }
    
    _image = image;

    [self updateInterface];
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
