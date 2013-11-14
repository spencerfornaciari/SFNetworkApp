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
    self.userPhotos = [[SFPhotoModel alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURL *jsonURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
/*    NSURL *photoURL = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&format=json&api_key=3bfca7acbc13885f9a02d1efdc32e592&user_id=62543166@N02&nojsoncallback=1"];*/
    
    NSURL *photoURL = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&format=json&api_key=3bfca7acbc13885f9a02d1efdc32e592&user_id=62543166@N02&per_page=25&nojsoncallback=1"];

    [self weatherCollection:jsonURL];
    [self photoCollection:photoURL];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.photoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSString *string = [NSString stringWithFormat:@"%i", indexPath.row];
    cell.textLabel.text = [self.photoArray[indexPath.row] photoTitle];

    
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
                                                [self.tableView reloadData];
                                            }];
    
    
    [jsonData resume];

}

-(void)photoCollection:(NSURL *)photoLocation
{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                              delegate: self
                                                         delegateQueue: nil];
        
        NSURLSessionDataTask *jsonData = [session dataTaskWithURL:photoLocation
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    
                                                    //Parse JSON to Dictionary
                                                    NSDictionary *dictionary = [data objectFromJSONData];
                                         
                                                    NSArray *array = [dictionary valueForKeyPath:@"photos.photo"];
                                                    //NSLog(@"%@", array);
                                                    
                                                    for (int i = 0; i < array.count; i++)
                                                    {
                                                        SFPhotoModel *newItem = [[SFPhotoModel alloc] init];
                                                        newItem.photoOwner = [array[i] objectForKey:@"owner"];
                                                        newItem.photoID = [array[i] objectForKey:@"id"];
                                                        newItem.photoSecretID = [array[i] objectForKey:@"secret"];
                                                        newItem.photoFarm = [array[i] objectForKey:@"farm"];
                                                        newItem.photoTitle = [array[i] objectForKey:@"title"];
                                                        
                                                        NSLog(@"%@", newItem.photoTitle);
                                                        
                                                        [self.photoArray addObject:newItem];
                                                    }
                                                    
                                                    NSLog(@"%i", self.photoArray.count);
                                                    
                                                    //Parse Dictionary to Weather Model Object
//                                                    self.uxserPhotos.photoID = [dictionary ]
//                                                    self.userPhotos.photoOwner =
//                                                    self.userPhotos.photoTitle =
                                                    
                                                    //Test Weather Model Values for validity
              
                                                    [self.tableView reloadData];
                                                }];
        
        
        [jsonData resume];
}

@end
