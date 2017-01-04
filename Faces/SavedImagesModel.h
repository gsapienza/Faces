//
//  SavedImagesModel.h
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <opencv2/opencv.hpp>

@interface SavedImagesModel : NSObject

/**
 Last image displayed on screen. Stored here in case user wants to save it to disk.
 */
@property (nonatomic) cv::Mat lastImage;

/**
 Saves last image to disk with face paths and updates user defaults to contain the lastest number of images saved to disk.
 */
- (void)saveLastImage;

/**
 Gets an image from disk.

 @param index Index of image used for its name.
 @return Image on disk for index.
 */
- (UIImage *)getImageForIndex:(int)index;

@end
