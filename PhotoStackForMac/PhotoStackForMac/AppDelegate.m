//
//  AppDelegate.m
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/16/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "AppDelegate.h"

@implementation NSImage(Rotated)
- (NSImage *)imageRotated:(float)degrees {
    if (0 != fmod(degrees,90.)) { NSLog( @"This code has only been tested for multiples of 90 degrees. (TODO: test and remove this line)"); }
    degrees = fmod(degrees, 360.);
    if (0 == degrees) {
        return self;
    }
    NSSize size = [self size];
    NSSize maxSize;
    if (90. == degrees || 270. == degrees || -90. == degrees || -270. == degrees) {
        maxSize = NSMakeSize(size.height, size.width);
    } else if (180. == degrees || -180. == degrees) {
        maxSize = size;
    } else {
        float maxLen = sqrt(powf(size.width, 2) + powf(size.height, 2));
        maxSize = NSMakeSize(maxLen, maxLen);
    }
    NSAffineTransform *rot = [NSAffineTransform transform];
    [rot rotateByDegrees:degrees];
    NSAffineTransform *center = [NSAffineTransform transform];
    [center translateXBy:maxSize.width / 2. yBy:maxSize.height / 2.];
    [rot appendTransform:center];
    
    NSImage *image = [[[NSImage alloc] initWithSize:maxSize] autorelease];
    [image lockFocus];
    [rot concat];
    NSRect rect = NSMakeRect(0, 0, size.width, size.height);
    NSPoint corner = NSMakePoint(-size.width / 2., -size.height / 2.);
    [self drawAtPoint:corner fromRect:rect operation:NSCompositeCopy fraction:1.0];
    [image unlockFocus];
    return image;
}

@end

@implementation AppDelegate

- (void)dealloc
{
    [super dealloc];
}

- (void)test
{
    //CATransform3D transform3d = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    //[self.imageView.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    //[self.imageView.layer setTransform:transform3d];
    //[self.imageView setFrameCenterRotation:-35];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.photoStackView reloadData];
}
- (NSUInteger)numberOfPagesInPageControl:(DNPageControl *)pageControl
{
    return 5;
}

- (NSUInteger)numberOfPhotosInPhotoStackView:(DNPhotoStackView *)photoStack
{
    return 5;
}
- (NSImage *)photoStackView:(DNPhotoStackView *)photoStack photoForIndex:(NSUInteger)index
{
    int arr[] = {1, 2, 3, 4, 5};
    return [NSImage imageNamed:[NSString stringWithFormat:@"photo%d.jpg", arr[index]]];
}

-(void)photoStackView:(DNPhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index
{
    self.pageControl.pageNumberOfSelected = index;
}

@end
