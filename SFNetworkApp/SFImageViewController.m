//
//  SFImageViewController.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/13/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFImageViewController.h"

@interface SFImageViewController () <NSURLSessionDownloadDelegate>

@end

@implementation SFImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.flickrImage) {
        self.navigationItem.title = self.flickrImage.photoTitle;
        
        NSLog(@"%@", self.flickrImage.photoTitle);
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                              delegate: self
                                                         delegateQueue: nil];
        NSURL *downloadURL = [NSURL URLWithString:self.flickrImage.photoLocation];
        NSLog(@"%@", self.flickrImage.photoLocation);
        
       NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL: downloadURL];
        
        
        
        [downloadTask resume];

    }
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"URL Session did finish downloading URL: %@", location);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSData *fileData = [NSData dataWithContentsOfURL: location];
        UIImage *image = [UIImage imageWithData: fileData];
        [self.flickrFullPhoto setImage: image];
        [self.flickrFullPhoto setContentMode: UIViewContentModeScaleAspectFit];
        self.flickrFullPhoto.image = image;
        

    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    CGFloat percentComplete = (CGFloat)totalBytesWritten/totalBytesExpectedToWrite;
   NSLog(@"URL Session did write %lli of %lli (%f)", bytesWritten, totalBytesWritten, percentComplete * 100.f);
//    
//    if (percentComplete >= .7) {
//        [session invalidateAndCancel];
//    }
//    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        [self.progressBar setProgress: percentComplete animated: NO];
//    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"Did resume...");
}

- (IBAction)cancelPhoto:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
