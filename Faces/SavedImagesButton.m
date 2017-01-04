//
//  SavedImagesButton.m
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import "SavedImagesButton.h"

@interface SavedImagesButton ()

@end

@implementation SavedImagesButton
@synthesize previewImageView = _previewImageView;

#pragma mark Properties

- (UIImageView *)previewImageView {
    if ( _previewImageView == nil ) {
        _previewImageView = [[UIImageView alloc] init];
        _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
        _previewImageView.clipsToBounds = YES;
    }
    
    return _previewImageView;
}

#pragma mark Public

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self layout];
    }
    return self;
}

#pragma mark Private

- (void)layout {
    [self addSubview:self.previewImageView];
    
    self.previewImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.previewImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}

@end
