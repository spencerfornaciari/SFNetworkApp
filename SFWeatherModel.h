//
//  SFWeatherModel.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/12/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFWeatherModel : NSObject

@property (nonatomic, strong) NSString *weatherDescription;
@property (nonatomic) float weatherTemperature;
@property (nonatomic, strong) NSDecimalNumber *windSpeed;
@property (nonatomic, strong) NSString *cityName;

@end
