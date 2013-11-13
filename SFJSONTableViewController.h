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

@interface SFJSONTableViewController : UITableViewController

@property (nonatomic, strong) SFWeatherModel *seattleWeather;
@property (nonatomic, strong) NSString *name;

@end
