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
#import "PXHEditViewController.h"

@interface PXHSelectActorViewController () <PXHSelectImageDelegate>
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@end

@implementation PXHSelectActorViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"selectImageSegue"]) {
        PXHSelectImageViewController *controller = (PXHSelectImageViewController *)segue.destinationViewController;
        NSParameterAssert([controller isKindOfClass:[PXHSelectImageViewController class]]);
        controller.delegate = self;
    }
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

#pragma mark - PXHSelectImageDelegate methods

- (void)selectImageViewController:(PXHSelectImageViewController *)controller didSelectImage:(UIImage *)image
{
    // present edit vc modally w/ image
    PXHEditViewController *editController = [[PXHEditViewController alloc] initWithImage:image];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
