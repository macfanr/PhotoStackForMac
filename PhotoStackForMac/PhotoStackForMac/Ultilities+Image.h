//
//  Ultilities+Image.h
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/30/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

//release the return value
CGImageRef CGImageFromNSImage(NSImage*);
NSImage *NSImageFromCGImage(CGImageRef);