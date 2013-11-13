//
//  SFJSONTableViewController.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/12/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFJSONTableViewController.h"

#define api_key @"3bfca7acbc13885f9a02d1efdc32e592"
#define user_id @"62543166@N02"
#define core_flickr @"http://api.flickr.com/services/rest/?&method="

@interface SFJSONTableViewController () <NSURLSessionDataDelegate>

@end

@implementation SFJSONTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.seattleWeather = [[SFWeatherModel alloc] init];
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURL *jsonURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
    [self weatherCollection:jsonURL];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
//                                                          delegate: self
//                                                     delegateQueue: nil];
//    
//    NSURLSessionDataTask *jsonData = [session dataTaskWithURL:jsonURL
//                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                            
//                                                //Parse JSON to Dictionary
//                                                NSDictionary *dictionary = [data objectFromJSONData];
//                                                
//                                                //Parse Dictionary to Weather Model Object
//                                                self.seattleWeather.cityName = [dictionary objectForKey:@"name"];
//                                                self.seattleWeather.weatherTemperature = [dictionary valueForKeyPath:@"main.temp"];
//                                                self.seattleWeather.weatherDescription = [[[dictionary objectForKey:@"weather"] lastObject] objectForKey:@"description"];
//                                                
//                                                //Test Weather Model Values for validity
//                                                NSLog(@"%@", self.seattleWeather.cityName);
//                                                NSLog(@"%@", self.seattleWeather.weatherTemperature);
//                                                NSLog(@"%@", self.seattleWeather.weatherDescription);
//                                                //NSLog(@"%@ %@", api_key, user_id);
//    
//    }];
//                                                                
//                                                                
//    [jsonData resume];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

//-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    NSLog(@"URL Session did finish downloading URL: %@", location);
//
//}

//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//
//}

//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
// didResumeAtOffset:(int64_t)fileOffset
//expectedTotalBytes:(int64_t)expectedTotalBytes
//{
//    NSLog(@"Did resume...");
//}

-(void)weatherCollection:(NSURL *)weatherLocation
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                          delegate: self
                                                     delegateQueue: nil];
    
    NSURLSessionDataTask *jsonData = [session dataTaskWithURL:weatherLocation
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                //Parse JSON to Dictionary
                                                NSDictionary *dictionary = [data objectFromJSONData];
                                                
                                                //Parse Dictionary to Weather Model Object
                                                self.seattleWeather.cityName = [dictionary objectForKey:@"name"];
                                                self.seattleWeather.weatherTemperature = [dictionary valueForKeyPath:@"main.temp"];
                                                self.seattleWeather.weatherDescription = [[[dictionary objectForKey:@"weather"] lastObject] objectForKey:@"description"];
                                                
                                                //Test Weather Model Values for validity
                                                NSLog(@"%@", self.seattleWeather.cityName);
                                                NSLog(@"%@", self.seattleWeather.weatherTemperature);
                                                NSLog(@"%@", self.seattleWeather.weatherDescription);
                                                //NSLog(@"%@ %@", api_key, user_id);
                                                
                                            }];
    
    
    [jsonData resume];

}

-(void)photoCollectino:(NSURL *)photoLocation
{
    
}

@end
