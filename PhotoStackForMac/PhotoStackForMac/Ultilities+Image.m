//
//  Ultilities+Image.m
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/30/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "Ultilities+Image.h"

CGImageRef CGImageFromNSImage(NSImage* aImage)
{
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithData((CFDataRef)[aImage TIFFRepresentation], NULL);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, NULL);
    return imageRef;
}

NSImage *NSImageFromCGImage(CGImageRef imageRef)
{
    NSSize imageSize = NSMakeSize(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    NSImage *image = [[NSImage alloc]initWithCGImage:imageRef size:imageSize];
    
    return [image autorelease];
}