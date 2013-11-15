//
//  SFChooseViewController.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/14/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFChooseViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *weatherButton;
@property (strong, nonatomic) IBOutlet UIButton *flickrPhotosButton;

- (IBAction)pickWeather:(id)sender;

- (IBAction)pickFlickrPhotos:(id)sender;

@end
