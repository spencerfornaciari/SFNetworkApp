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
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                              delegate: self
                                                         delegateQueue: nil];
        
        NSURL *downloadURL = [NSURL URLWithString:self.flickrImage.photoLocationLarge];
        
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

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location
{
    NSData *fileData = [[NSData alloc ] initWithContentsOfURL:location];
    UIImage *image = [UIImage imageWithData: fileData];
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, 320, self.view.frame.size.height-115)];
        [imageView setImage: image];
        [imageView setContentMode: UIViewContentModeScaleAspectFit];
        [self.view addSubview:imageView];
//        self.flickrFullPhoto.image = image;
//        [self.flickrFullPhoto setContentMode:UIViewContentModeScaleAspectFit];
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
