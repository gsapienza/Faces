//
//  FaceDetectionModelBridge.h
//  Faces
//
//  Created by Gregory Sapienza on 12/15/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <opencv2/opencv.hpp>

@interface FaceDetectionModel : NSObject

/**
 Finds rects of faces within Mat image.
 
 @return Vector of rects containing positions and sizes of faces found.
 */
- (cv::vector<cv::Rect>)getFaceFramesForImage:(cv::Mat)image;

@end
