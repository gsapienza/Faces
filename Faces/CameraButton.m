//
//  CameraButton.m
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import "CameraButton.h"

@interface CameraButton ()

/**
 Circular outline border layer for button.
 */
@property (nonatomic) CALayer *outerButtonOutline;

/**
 Circular inner fill layer for button.
 */
@property (nonatomic) CALayer *innerButtonFill;

@end

@implementation CameraButton
@synthesize outerButtonOutline = _outerButtonOutline;
@synthesize innerButtonFill = _innerButtonFill;

#pragma mark Properties

- (CALayer *)outerButtonOutline {
    if ( _outerButtonOutline == nil ) {
        _outerButtonOutline = [[CALayer alloc] init];
        
        _outerButtonOutline.borderColor = [UIColor whiteColor].CGColor;
        _outerButtonOutline.borderWidth = 4;
    }
    
    return _outerButtonOutline;
}

- (CALayer *)innerButtonFill {
    if ( _innerButtonFill == nil ) {
        _innerButtonFill = [[CALayer alloc] init];
        
        _innerButtonFill.backgroundColor = [UIColor whiteColor].CGColor;
    }
    
    return _innerButtonFill;
}

#pragma mark Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer addSublayer:self.outerButtonOutline];
        [self.layer addSublayer:self.innerButtonFill];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layout];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if ( highlighted ) {
        self.innerButtonFill.opacity = 0.6;
    } else {
        self.innerButtonFill.opacity = 1;
    }
}

#pragma mark Private

- (void)layout {
    self.outerButtonOutline.frame = self.bounds;
    self.outerButtonOutline.cornerRadius = self.bounds.size.width / 2;
    
    self.innerButtonFill.frame = self.bounds;

    self.innerButtonFill.cornerRadius = self.innerButtonFill.bounds.size.width / 2;
    self.innerButtonFill.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
}

@end
