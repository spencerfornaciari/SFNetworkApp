//
//  SFImageViewController.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/13/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFPhotoModel.h"



@interface SFImageViewController : UIViewController

@property (strong, nonatomic) SFPhotoModel *flickrImage;


- (IBAction)cancelPhoto:(id)sender;

@end
