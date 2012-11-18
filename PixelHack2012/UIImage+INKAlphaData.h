//
//  UIImage+INKAlphaData.h
//  INKToolKit
//
//  Created by Ryder Mackay on 2012-08-03.
//  Copyright (c) 2012 Endloop Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (INKAlphaData)

- (NSData *)alphaData;
- (BOOL)isPointOpaque:(CGPoint)point;

@end
