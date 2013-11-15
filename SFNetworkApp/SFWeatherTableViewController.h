//
//  SFWeatherTableViewController.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/14/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONKit.h>
#import "SFWeatherModel.h"

@interface SFWeatherTableViewController : UITableViewController

@property (nonatomic, strong) SFWeatherModel *seattleWeather;

-(void)weatherCollection:(NSURL *)weatherLocation;

- (IBAction)refreshJSON:(id)sender;


@end
