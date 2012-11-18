//
//  UIImage+INKAlphaData.m
//  INKToolKit
//
//  Created by Ryder Mackay on 2012-08-03.
//  Copyright (c) 2012 Endloop Mobile. All rights reserved.
//

#import "UIImage+INKAlphaData.h"

@implementation UIImage (INKAlphaData)

+ (NSCache *)alphaCache
{
    static NSCache * _alphaCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _alphaCache = [[NSCache alloc] init];
        _alphaCache.name = @"com.inkrobin.INKToolKit.UIImage+AlphaData";
    });
    
    return _alphaCache;
}

- (NSData *)alphaData
{
    NSCache *cache = [[self class] alphaCache];
    NSData *data = [cache objectForKey:self];
    if (data)
        return data;
    
    CGImageRef image = [self CGImage];
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t size = width * height;
    void *bitmapData = malloc(size);
    
    // create alpha channel
    CGContextRef context = CGBitmapContextCreate (bitmapData,
                                                  width,
                                                  height,
                                                  8,
                                                  width,
                                                  NULL,
                                                  kCGImageAlphaOnly);
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(context, rect, image);
    
    data = [NSData dataWithBytes:bitmapData length:size];
    [cache setObject:data forKey:self];
    
    CGContextRelease(context);
    free(bitmapData);
    
    return data;
}

- (BOOL)isPointOpaque:(CGPoint)point
{
    NSData *data = [self alphaData];
    
    CGFloat scale = [self scale];
    CGPoint pointScaled = CGPointMake(point.x * scale, point.y * scale);
    CGFloat widthScaled = self.size.width * scale;
    NSUInteger idx = pointScaled.x + (pointScaled.y * widthScaled);
    unsigned char *bytes = (unsigned char *)[data bytes];

    return (bytes[idx] > 0);
}

@end
