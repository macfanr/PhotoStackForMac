//
//  AppDelegate.h
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/16/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DNPhotoStackView.h"
#import "DNPageControl.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet DNPhotoStackView *photoStackView;
@property (assign) IBOutlet DNPageControl *pageControl;

@end
