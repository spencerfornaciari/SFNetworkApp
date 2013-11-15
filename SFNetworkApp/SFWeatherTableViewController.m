//
//  SFWeatherTableViewController.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/14/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFWeatherTableViewController.h"

@interface SFWeatherTableViewController () <NSURLSessionDataDelegate>

@end

@implementation SFWeatherTableViewController
{
    NSURL *_jsonURL;
    NSArray *_array;
    NSURLSessionDataTask *_weatherDataTask;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.seattleWeather = [[SFWeatherModel alloc] init];

    _array = [[NSMutableArray alloc] init];
    
    [self refreshWeatherTable];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _array.count;;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [_array[indexPath.row] cityName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_array[indexPath.row] weatherTemperature]];
    
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

-(void)weatherCollection:(NSURL *)weatherLocation
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration
                                                          delegate:self
                                                     delegateQueue:nil];
    
    _weatherDataTask = [session dataTaskWithURL:weatherLocation
                              completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                  
                                  //Parse JSON to Dictionary
                                  NSDictionary *dictionary = [data objectFromJSONData];
                                  
                                  //Parse Dictionary to Weather Model Object
                                  self.seattleWeather.cityName = [dictionary objectForKey:@"name"];
                                  self.seattleWeather.weatherTemperature = [dictionary valueForKeyPath:@"main.temp"];
                                  self.seattleWeather.weatherDescription = [[[dictionary objectForKey:@"weather"] lastObject] objectForKey:@"description"];
                                  
                                  //Test Weather Model Values for validity
                                  //                                                NSLog(@"%@", self.seattleWeather.cityName);
                                  //                                                NSLog(@"%@", self.seattleWeather.weatherTemperature);
                                  //                                                NSLog(@"%@", self.seattleWeather.weatherDescription);
                                  //NSLog(@"%@ %@", api_key, user_id);
                                  NSArray *array = [NSArray arrayWithObject:self.seattleWeather];
                                  
                                  _array = array;
                                  NSLog(@"%@",[_array[0] cityName]);
                                  NSLog(@"%@",[_array[0] weatherTemperature]);
                                  NSLog(@"%@", [_array[0] weatherDescription]);
                                  
                                  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                      
                                      [self.tableView reloadData];                                                }];
                                  
                              }];
    
    [_weatherDataTask resume];
    
}

-(void)refreshWeatherTable
{
    _jsonURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
    if (_weatherDataTask && _weatherDataTask.state != NSURLSessionTaskStateCompleted) {
        [_weatherDataTask cancel];
    }
    [self weatherCollection:_jsonURL];
}

- (IBAction)refreshJSON:(id)sender
{
    [self refreshWeatherTable];
}

@end
