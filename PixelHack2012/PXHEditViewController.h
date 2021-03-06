//
//  PXHEditViewController.h
//  PixelHack2012
//
//  Created by Ryder Mackay on 2012-11-17.
//  Copyright (c) 2012 Angry Marsupial. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PXHEditViewController : UIViewController

- (id)initWithImage:(UIImage *)image;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void (^completionBlock)(PXHEditViewController *controller, UIImage *image);

@end
