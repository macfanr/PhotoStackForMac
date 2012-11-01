//
//  DNPageControl.m
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/31/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNPageControl.h"

@implementation DNPageControl

@synthesize dataSource = dataSource;
@synthesize pageNumberOfSelected = pageNumberOfSelected;
@synthesize delegate = delegate;

- (NSRect)rectOfControls
{
    const int width = 100;
    const int height = NSHeight(self.bounds);
    
    return NSMakeRect((NSWidth(self.bounds) - width)/2.0,
                      (NSHeight(self.bounds) - height)/2.0,
                      width, height);
}

- (void)drawControlInRect:(NSRect)rect highlight:(BOOL)flag
{
    float w = rect.size.height;
    rect.origin.x += (NSWidth(rect) - w)/2.0;
    rect.size.width = w;
    
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithOvalInRect:rect];
    if(flag) [[NSColor darkGrayColor]setFill];
    else [[NSColor lightGrayColor]setFill];
    [bezierPath fill];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSUInteger num = [dataSource numberOfPagesInPageControl:self];
    NSRect controlsRect = [self rectOfControls];
    float widthEachControl = NSWidth(controlsRect)/(float)num;
    
    for(int i=0; i<num; i++) {
        NSRect controlRect = NSMakeRect(NSMinX(controlsRect) + i * widthEachControl,
                                        NSMinY(controlsRect),
                                        widthEachControl, NSHeight(controlsRect));
        [self drawControlInRect:controlRect
                      highlight:i==self.pageNumberOfSelected];
    }
}

- (void)setPageNumberOfSelected:(NSUInteger)num
{
    pageNumberOfSelected = num;
    [self setNeedsDisplay:YES];
}

- (void)mouseDown:(NSEvent *)theEvent
{
//    NSPoint pos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//    if(0) {
//        [delegate pageNumberShouldChangedPageControl:self atIndex:0];
//    }
}

@end