//
//  DNPhotoStackView.h
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/16/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DNARCCompatible.h"

@class DNPhotoStackView;

@protocol PhotoStackViewDataSource <NSObject>

@required
- (NSUInteger)numberOfPhotosInPhotoStackView:(DNPhotoStackView *)photoStack;
- (NSImage *)photoStackView:(DNPhotoStackView *)photoStack photoForIndex:(NSUInteger)index;

@optional
- (NSSize)photoStackView:(DNPhotoStackView *)photoStack photoSizeForIndex:(NSUInteger)index;

@end


@protocol PhotoStackViewDelegate <NSObject>

@optional
-(void)photoStackView:(DNPhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index;
-(void)photoStackView:(DNPhotoStackView *)photoStackView willFlickAwayPhotoFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;
//-(void)photoStackView:(DNPhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index;
-(void)photoStackView:(DNPhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index;

@end


@interface DNPhotoStackView : NSView {
    id <PhotoStackViewDataSource> _dataSource;
    id <PhotoStackViewDelegate> _delegate;
}

@property (assign) IBOutlet id <PhotoStackViewDataSource> dataSource;
@property (assign) IBOutlet id <PhotoStackViewDelegate> delegate;

- (void)reloadData;

@end