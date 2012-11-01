//
//  DNPageControl.h
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/31/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DNPageControlDataSource, DNPageControlDelegate;

@interface DNPageControl : NSView
{
    id <DNPageControlDataSource> dataSource;
    id <DNPageControlDelegate> delegate;
    
    NSUInteger pageNumberOfSelected;
}

@property (nonatomic, assign) IBOutlet id <DNPageControlDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id <DNPageControlDelegate> delegate;
@property (nonatomic, assign) NSUInteger pageNumberOfSelected;

@end

@protocol DNPageControlDataSource <NSObject>

@required
- (NSUInteger)numberOfPagesInPageControl:(DNPageControl *)pageControl;

@end


@protocol DNPageControlDelegate <NSObject>

@optional

- (BOOL)pageNumberShouldChangedPageControl:(DNPageControl *)pageControl atIndex:(NSUInteger)index;

@end