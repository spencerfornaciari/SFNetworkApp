//
//  SFJSONTableViewController.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/12/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit.h>
#import "SFWeatherModel.h"
#import "SFPhotoModel.h"
#import "SFImageViewController.h"

@interface SFPhotoTableViewController : UITableViewController

@property (nonatomic, strong) SFPhotoModel *userPhotos;
@property (nonatomic, strong) NSMutableArray *photoArray;

-(void)photoCollection:(NSURL *)photoLocation;
- (IBAction)refreshJSON:(id)sender;

@end
