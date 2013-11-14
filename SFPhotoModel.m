//
//  SFPhotoModel.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/13/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFPhotoModel.h"

@implementation SFPhotoModel

-(void)createPhotoLocation
{
    self.photoLocation = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", self.photoFarm, self.photoServer, self.photoID, self.photoSecretID];
                          
}


@end
