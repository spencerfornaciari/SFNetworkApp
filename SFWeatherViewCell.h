//
//  SFWeatherViewCell.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/17/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFWeatherViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *cityName;
@property (strong, nonatomic) IBOutlet UILabel *cityTemperature;
@property (strong, nonatomic) IBOutlet UILabel *cityDescription;

@end
