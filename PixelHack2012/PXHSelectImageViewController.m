//
//  PXHSelectImageViewController.m
//  PixelHack2012
//
//  Created by Mark H Pavlidis on 11/17/2012.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHSelectImageViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PXHSelectImageCell.h"
#import <PXAPI.h>

@interface PXHPhoto : NSObject

- (id)initWithAsset:(ALAsset *)asset;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) ALAsset *asset;

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSURL *thumbnailURL;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;

@end



@implementation PXHPhoto

- (id)initWithAsset:(ALAsset *)asset
{
    if (self = [super init]) {
        _asset = asset;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        NSArray *images = dictionary[@"images"];
        _thumbnailURL = [NSURL URLWithString:images[0][@"url"]];
        _URL = [NSURL URLWithString:images[1][@"url"]];
    }
    
    return self;
}

- (UIImage *)image
{
    if (_image == nil) {
        if (self.URL.isFileURL) {
            _image = [[UIImage alloc] initWithContentsOfFile:self.thumbnailURL.path];
        }
        else if (self.asset != nil) {
            ALAssetRepresentation *assetRepresentation = _asset.defaultRepresentation;
            UIImage *image = [UIImage imageWithCGImage:assetRepresentation.fullResolutionImage
                                                 scale:assetRepresentation.scale
                                           orientation:assetRepresentation.orientation];
            _image = image;
        }
        else {
            // start download
            NSData *data = [NSData dataWithContentsOfURL:self.URL];
            _image = [UIImage imageWithData:data];
        }
    }
    
    return _image;
}

- (UIImage *)thumbnail
{
    if (_thumbnail == nil) {
        if (self.thumbnailURL.isFileURL) {
            _thumbnail = [[UIImage alloc] initWithContentsOfFile:self.thumbnailURL.path];
        }
        else if (self.asset != nil) {
            _thumbnail = [UIImage imageWithCGImage:self.asset.thumbnail];
        }
        else {
            NSData *data = [NSData dataWithContentsOfURL:self.thumbnailURL];
            _thumbnail = [UIImage imageWithData:data];
            // start download
        }
    }
    
    return _thumbnail;
}

@end



@interface PXHReusableSearchBarView : UICollectionReusableView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@end

@implementation PXHReusableSearchBarView
@end

@interface PXHSelectImageViewController () <UISearchBarDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
- (IBAction)cameraButtonTapped:(id)sender;

@end

@implementation PXHSelectImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!self.assetsLibrary) {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    if (!self.groups) {
        self.groups = [[NSMutableArray alloc] init];
    } else {
        [self.groups removeAllObjects];
    }
    
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group) {
            NSMutableArray *groupAssets = [NSMutableArray arrayWithCapacity:group.numberOfAssets];
            [self.groups addObject:groupAssets];
            ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result) {
                    PXHPhoto *photo = [[PXHPhoto alloc] initWithAsset:result];
                    [groupAssets insertObject:photo atIndex:0];
                } else {
                    [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                }
            };
            
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        }
    };
        
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream | ALAssetsGroupSavedPhotos;
    [self.assetsLibrary enumerateGroupsWithTypes:groupTypes usingBlock:listGroupBlock failureBlock:nil];
}

- (PXHPhoto *)photoAtIndexPath:(NSIndexPath *)indexPath
{
    return self.groups[indexPath.section][indexPath.row];
}

#pragma mark - UICollectionView methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.groups.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groups[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PXHSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    PXHPhoto *photo = [self photoAtIndexPath:indexPath];
    cell.imageView.image = photo.thumbnail;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0 && [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        PXHReusableSearchBarView *searchBarView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"searchBarIdentifier" forIndexPath:indexPath];
        searchBarView.searchBar.delegate = self;
        return searchBarView;
    }
    else {
        return nil;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PXHPhoto *photo = [self photoAtIndexPath:indexPath];
    UIImage *image = photo.image;
    
    if ([self.delegate conformsToProtocol:@protocol(PXHSelectImageDelegate)]) {
        [self.delegate selectImageViewController:self didSelectImage:image];
    }
}

#pragma mark - UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [PXRequest setConsumerKey:@"J1RYU84XKaJuglDuy6gNQYbajZVLBp4hZyXr8YSs" consumerSecret:@"wxRAKNRvZyC7V08yRC3PH0HmPySE1gCVIchwzz9c"];
    
    // search and display results
    [PXRequest requestForSearchTerm:searchBar.text
                               page:1
                     resultsPerPage:100
                         photoSizes:PXPhotoModelSizeExtraLarge | PXPhotoModelSizeThumbnail
                             except:0
                         completion:^(NSDictionary *results, NSError *error) {
                             if (results) {
                                 NSMutableArray *photos = [NSMutableArray new];
                                 for (NSDictionary *dictionary in results[@"photos"]) {
                                     PXHPhoto *photo = [[PXHPhoto alloc] initWithDictionary:dictionary];
                                     [photos addObject:photo];
                                 }
                                 
                                 self.groups = [@[photos] mutableCopy];
                                 
                                 [self.collectionView reloadData];
                             }
                             else {
                                 NSLog(@"%@", error);
                             }
                         }];
}

- (IBAction)cameraButtonTapped:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // write to saved photos

    [picker dismissViewControllerAnimated:YES completion:^{
        [self.delegate selectImageViewController:self didSelectImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
