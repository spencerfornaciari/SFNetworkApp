//
//  SFPhotoModel.h
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/13/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFPhotoModel : NSObject

@property (nonatomic, strong) NSString *photoOwner;
@property (nonatomic, strong) NSString *photoID;
@property (nonatomic, strong) NSString *photoFarm;
@property (nonatomic, strong) NSString *photoServer;
@property (nonatomic, strong) NSString *photoTitle;
@property (nonatomic, strong) NSString *photoSecretID;

@property (nonatomic, strong) NSString *photoLocation;

-(void)createPhotoLocation;

@end