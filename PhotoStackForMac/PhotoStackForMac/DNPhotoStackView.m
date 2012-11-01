//
//  DNPhotoStackView.m
//  PhotoStackForMac
//
//  Created by Xu Jun on 10/16/12.
//  Copyright (c) 2012 Xu Jun. All rights reserved.
//

#import "DNPhotoStackView.h"
#import <QuartzCore/QuartzCore.h>

#import "Ultilities+Image.h"
#import "Ultilities+Math.h"

static BOOL const BorderVisibilityDefault = YES;
static CGFloat const BorderWidthDefault = 5.0f;
static CGFloat const PhotoRotationOffsetDefault = 4.0f;

#define CenterLayer(_layer, _superLayer)\
    do {\
        _layer.position = _superLayer.position;\
    }while(0)

#define ShadowLayer(_layer) \
    do {\
        CGColorRef color = NULL;\
        _layer.shadowRadius = 3;\
        _layer.shadowOpacity = 0.8;\
        _layer.shadowOffset = CGSizeMake(1, -1);\
        CGPathRef pathRef = CGPathCreateWithRect(_layer.bounds, NULL);\
        _layer.shadowPath = pathRef;\
        CGPathRelease(pathRef);\
        color = CGColorCreateGenericRGB(0.1, 0.1, 0.1, 1);\
        _layer.shadowColor = color;\
        CGColorRelease(color);\
    }while(0)

void f(CALayer *_layer, CALayer *_superLayer)
{
    
}

@interface DNImageLayer : CALayer {
    int tag;
}

@property (nonatomic, assign) int tag;

- (void)setImage:(NSImage*)aImage;

@end

@implementation DNImageLayer

@synthesize tag;

+ (DNImageLayer*)layer
{
    CGColorRef color = NULL;
    DNImageLayer *imageLayer = [[DNImageLayer alloc]init];

    //border
    imageLayer.tag = -1;
    imageLayer.borderWidth = 5;
    color = CGColorCreateGenericRGB(1, 1, 1, 1);
    imageLayer.borderColor = color;
    CGColorRelease(color);
        
    
    return [imageLayer autorelease];
}

- (void)setImage:(NSImage*)aImage
{
    CGImageRef imageRef = CGImageFromNSImage(aImage);
    self.contents = (id)imageRef;
    self.frame = CGRectMake(0, 0, aImage.size.width, aImage.size.height);
    CGImageRelease(imageRef);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"DNImageLayer(%@)", self.name];
}

@end

@interface DNPhotoStackView()

@property (assign) CALayer *containerLayer;
@property (assign) CALayer *touchedLayer;
@property (assign) NSPoint touchedLocation;

@end

@implementation DNPhotoStackView

@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(self) {
        [self _setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self _setup];
    }
    return self;
}

- (void)_setup
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setWantsLayer:YES];
        
        CALayer *container = [CALayer layer];
        container.frame = self.bounds;
        container.name = @"PhotoContainer";
        container.autoresizingMask = kCALayerWidthSizable|kCALayerHeightSizable;
#if 0
        container.borderWidth = 2;
        CGColorRef color = CGColorCreateGenericRGB(1, 1, 0, 1);
        container.borderColor = color; CGColorRelease(color);
#endif
        self.containerLayer = container;
        [self.layer addSublayer:container];
        
    });
}

- (CALayer*)photoContainerLayer {return [self containerLayer];}

- (void)reloadData
{
    NSUInteger numberOfImage = [self.dataSource numberOfPhotosInPhotoStackView:self];
    for(NSUInteger i=0; i<numberOfImage; i++) {
        NSImage *image = [self.dataSource photoStackView:self photoForIndex:i];
        
        if([self.dataSource respondsToSelector:@selector(photoStackView:photoSizeForIndex:)]) {
            NSSize newSize = [self.dataSource photoStackView:self photoSizeForIndex:i];
            [image setScalesWhenResized:YES];
            [image setSize:newSize];
        }
        
        DNImageLayer *imageLayer = [DNImageLayer layer];
        [imageLayer setImage:image];
        imageLayer.tag = i;
        imageLayer.name = [NSString stringWithFormat:@"%lu", i+1];
        imageLayer.transform = CATransform3DMakeRotation(-FloatRandom(0.0, 0.15), 0, 0, 1);
        imageLayer.autoresizingMask = kCALayerWidthSizable;
        CenterLayer(imageLayer, self.photoContainerLayer);
        ShadowLayer(imageLayer);
        
        [self.photoContainerLayer insertSublayer:imageLayer atIndex:0];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoStackView:didSelectPhotoAtIndex:)])
        [self.delegate photoStackView:self didSelectPhotoAtIndex:0];
}


- (void)_makeImageLayerBack:(CALayer*)layer
{
    CAKeyframeAnimation *transformAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    float x = layer.superlayer.position.x - layer.position.x;
    
    CATransform3D startingPos = CATransform3DTranslate(layer.transform, 0, 0, 2);
    CATransform3D movingPos = CATransform3DScale(CATransform3DTranslate(layer.transform, CGRectGetWidth(layer.bounds), 0, -2), 0.9, 0.9,1);
    CATransform3D endingPos = CATransform3DTranslate(layer.transform, x, 0, -2);
    
    NSArray *posValues = [NSArray arrayWithObjects:
                          [NSValue valueWithCATransform3D:startingPos],
                          [NSValue valueWithCATransform3D:movingPos],
                          [NSValue valueWithCATransform3D:endingPos], nil];
    [transformAnimation setValues:posValues];
    
    NSArray *times = [NSArray arrayWithObjects:
                      [NSNumber numberWithFloat:0.0f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:1.0f], nil];
    [transformAnimation setKeyTimes:times];
    
    
    NSArray *timingFunctions = [NSArray arrayWithObjects:
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],nil];
    [transformAnimation setTimingFunctions:timingFunctions];
    transformAnimation.fillMode = kCAFillModeForwards;
    transformAnimation.removedOnCompletion = NO;
    transformAnimation.duration = 0.5;
    transformAnimation.delegate = self;
    
    [layer addAnimation:transformAnimation forKey:@"makeback"];
}

- (void)_makeImageLayerAttention:(CALayer*)layer
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:layer.transform];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, 0, 0, 0,0)];
    animation.duration = 0.2;
    animation.removedOnCompletion = NO;
	animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [layer addAnimation:animation forKey:@"makerotate"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CALayer *toplayer = [[self.photoContainerLayer sublayers] lastObject];
    if(toplayer) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        [self.photoContainerLayer insertSublayer:toplayer atIndex:0];
        [toplayer removeAllAnimations];
        CenterLayer(toplayer, self.photoContainerLayer);
        [CATransaction commit];
        
        DNImageLayer *secondlayer = [[self.photoContainerLayer sublayers] lastObject];
        [self _makeImageLayerAttention:secondlayer];
        
        if(self.delegate && [self.delegate respondsToSelector:@selector(photoStackView:didSelectPhotoAtIndex:)])
            [self.delegate photoStackView:self didSelectPhotoAtIndex:secondlayer.tag];
    }
}

#pragma mark - mouse event

- (void)mouseDown:(NSEvent *)theEvent
{
    NSPoint mouseDownPos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    CALayer *touchLayer =  [self.photoContainerLayer hitTest:NSPointToCGPoint(mouseDownPos)];
    
    if([touchLayer isKindOfClass:[DNImageLayer class]]) {
        self.touchedLayer = touchLayer;
        if(self.delegate && [self.delegate respondsToSelector:@selector(photoStackView:willStartMovingPhotoAtIndex:)]) {
            [self.delegate photoStackView:self willStartMovingPhotoAtIndex:[(DNImageLayer*)self.touchedLayer tag]];
        }
    }
    else {
        self.touchedLayer = nil;
    }
    self.touchedLocation = mouseDownPos;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint mouseDownPos = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    if(self.touchedLayer) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        CGPoint originPoint = self.touchedLayer.position;
        CGPoint newPoint = CGPointMake(originPoint.x + mouseDownPos.x - self.touchedLocation.x, originPoint.y);
        
        if(CGRectContainsPoint(self.photoContainerLayer.bounds, newPoint)) {
            self.touchedLayer.position = newPoint;
        }
        
        [CATransaction commit];
    }
    self.touchedLocation = mouseDownPos;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(photoStackView:willFlickAwayPhotoFromIndex:toIndex:)]) {
        [self.delegate photoStackView:self willFlickAwayPhotoFromIndex:[(DNImageLayer*)self.touchedLayer tag] toIndex:0];
    }
    [self _makeImageLayerBack:self.touchedLayer];
    self.touchedLayer = nil;
}

@end
