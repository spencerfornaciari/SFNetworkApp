//
//  SFChooseViewController.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/14/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFChooseViewController.h"

@interface SFChooseViewController ()

@end

@implementation SFChooseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.weatherButton.backgroundColor = [UIColor redColor];
    self.weatherButton.layer.cornerRadius = 5.f;
    self.weatherButton.tintColor = [UIColor whiteColor];
    
    self.flickrPhotosButton.backgroundColor = [UIColor redColor];
    self.flickrPhotosButton.layer.cornerRadius = 5.f;
    self.flickrPhotosButton.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickWeather:(id)sender {
}

- (IBAction)pickFlickrPhotos:(id)sender {
}
@end
