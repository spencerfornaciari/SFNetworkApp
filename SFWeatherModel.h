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
@property (nonatomic) NSDecimalNumber *weatherTemperature;
@property (nonatomic, strong) NSString *cityName;

@end
