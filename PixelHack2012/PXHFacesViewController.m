//
//  PXHFacesViewController.m
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-18.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import "PXHFacesViewController.h"
#import "PXHSelectImageCell.h"

@interface PXHFace : NSObject
- (id)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, copy) NSArray *images;
@end

@implementation PXHFace
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}
@end



@interface PXHFacesViewController ()

@property (nonatomic, copy) NSArray *faces;

@end

@implementation PXHFacesViewController

- (NSArray *)faces
{
    if (_faces == nil) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Faces" ofType:@"plist"]];
        NSMutableArray *faces = [[NSMutableArray alloc] init];
        for (NSDictionary *dictionary in array) {
            [faces addObject:[[PXHFace alloc] initWithDictionary:dictionary]];
        }
        
        _faces = [faces copy];
    }
    return _faces;
}

- (PXHFace *)faceAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.faces objectAtIndex:indexPath.row];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.faces.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PXHSelectImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    PXHFace *face = [self faceAtIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:face.images[0]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.completionBlock) {
        PXHFace *face = [self.faces objectAtIndex:indexPath.row];
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (NSString *imageName in face.images) {
            [images addObject:[UIImage imageNamed:imageName]];
        }
        self.completionBlock(self, images);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
