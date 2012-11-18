//
//  PXHSelectActorViewController.m
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHSelectActorViewController.h"
#import "PXHSelectImageCell.h"
#import "PXHSelectImageViewController.h"

@interface PXHSelectActorViewController ()
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation PXHSelectActorViewController

- (IBAction)tappedAddActor:(id)sender {
//    PXHSelectImageViewController *selectImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"selectImagesController"];
//    selectImageViewController.delegate = self;
//
//    self.currentPopoverController = [[UIPopoverController alloc] initWithContentViewController:selectImageViewController];
//    [self.currentPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


#pragma mark - UICollectionView Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PXHSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
