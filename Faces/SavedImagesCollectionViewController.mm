//
//  SavedImagesCollectionViewController.m
//  Faces
//
//  Created by Gregory Sapienza on 12/16/16.
//  Copyright © 2016 The Oven. All rights reserved.
//

#import "SavedImagesCollectionViewController.h"
#import "SavedImagesModel.h"
#import "ImagePresentationViewController.h"

@interface SavedImagesCollectionViewController ()

@property (nonatomic) SavedImagesModel *savedImagesModel;

@end

@implementation SavedImagesCollectionViewController
@synthesize savedImagesModel = _savedImagesModel;

static NSString * const reuseIdentifier = @"PHOTO_CELL";

#pragma mark Properties

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (SavedImagesModel *)savedImagesModel {
    if ( _savedImagesModel == nil ) {
        _savedImagesModel = [[SavedImagesModel alloc] init];
    }
    
    return _savedImagesModel;
}

#pragma mark Public

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.bounces = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.navigationItem.title = @"Photos";
    self.navigationController.navigationBar.translucent = false;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:43/255.0f green:61/255.0f blue:79/255.0f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] init];
    closeBarButtonItem.title = @"Close";
    [closeBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    closeBarButtonItem.target = self;
    closeBarButtonItem.action = @selector(onCloseBarButton);
    self.navigationItem.leftBarButtonItem = closeBarButtonItem;
}

- (void)onCloseBarButton {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int lastImageIndexSaved = int([NSUserDefaults.standardUserDefaults integerForKey:@"LastImageIndexSaved"]); //Last file name saved to disk. That is the number of rows we need.

    return lastImageIndexSaved;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    //Set up for image view on cell.
    
    UIImageView *photoImageView = [[UIImageView alloc] init];
    UIImage *photo = [self.savedImagesModel getImageForIndex:int(indexPath.item + 1)];
    photoImageView.image = photo;
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    photoImageView.clipsToBounds = YES;
    
    [cell addSubview:photoImageView];
    
    photoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [cell addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *photo = [self.savedImagesModel getImageForIndex:int(indexPath.item + 1)];
    
    ImagePresentationViewController *imagePresentationViewController = [[ImagePresentationViewController alloc] init];
    imagePresentationViewController.imageView.image = photo;
    
    [self.navigationController pushViewController:imagePresentationViewController animated:YES];
}

@end
