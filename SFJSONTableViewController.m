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
{
    NSURL *_jsonURL, *_photoURL;
    NSArray *_array;
    UIImage *_imageDefault;
}

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
    _array = [[NSMutableArray alloc] init];
    
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _jsonURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?q=Seattle,us"];
/*    NSURL *photoURL = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&format=json&api_key=3bfca7acbc13885f9a02d1efdc32e592&user_id=62543166@N02&nojsoncallback=1"];*/
    
    _photoURL = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&format=json&api_key=3bfca7acbc13885f9a02d1efdc32e592&user_id=62543166@N02&per_page=25&nojsoncallback=1"];

    //[self weatherCollection:_jsonURL];
    [self photoCollection:_photoURL];

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
    //return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSURL *url = [NSURL URLWithString:[self.photoArray[indexPath.row] photoLocationSmall]];
    NSData *data = [NSData dataWithContentsOfURL:url];
//    
    UIImage *image = [UIImage imageWithData:data];
    
    //cell.textLabel.text = [_array[indexPath.row] cityName];
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [_array[indexPath.row] weatherTemperature]];
    cell.textLabel.text = [self.photoArray[indexPath.row] photoTitle];
    cell.imageView.image = image;


    
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


#pragma mark - Table view delegate methods

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // do a segue based on the indexPath or do any setup later in prepareForSegue
    [self performSegueWithIdentifier:@"fullPhoto" sender:self];
}

#pragma mark - Navigation


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"fullPhoto"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SFImageViewController *controller = segue.destinationViewController;
        controller.flickrImage = self.photoArray[indexPath.row];
        //NSLog(@"%ld", [self.tableView indexPathForSelectedRow]);
//
//
//        [self presentViewController:controller animated:YES completion:nil];
        
        // do some prep based on indexPath, if needed
        
    }
}





-(void)weatherCollection:(NSURL *)weatherLocation
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                          delegate: self
                                                     delegateQueue: nil];
    
   
    
    NSURLSessionDataTask *jsonData = [session dataTaskWithURL:weatherLocation
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                
                                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
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
                                                    [self.tableView reloadData];                                                }];
                                                
                                            }];
    
    if (session) {
        [jsonData cancel];
    }
    
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
                                                    
                                                   
                                                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                        //Parse JSON to Dictionary
                                                        NSDictionary *dictionary = [data objectFromJSONData];
                                                        
                                                        //Sort Dictionary into an array of SFPhotoModel Items
                                                        NSArray *array = [dictionary valueForKeyPath:@"photos.photo"];
                                                        for (int i = 0; i < array.count; i++)
                                                        {
                                                            SFPhotoModel *newItem = [[SFPhotoModel alloc] init];
                                                            newItem.photoOwner = [array[i] objectForKey:@"owner"];
                                                            newItem.photoID = [array[i] objectForKey:@"id"];
                                                            newItem.photoSecretID = [array[i] objectForKey:@"secret"];
                                                            newItem.photoFarm = [array[i] objectForKey:@"farm"];
                                                            newItem.photoServer = [array[i] objectForKey:@"server"];
                                                            newItem.photoTitle = [array[i] objectForKey:@"title"];
                                                            
                                                            [newItem createPhotoLocation];
                                                            
                                                            [self.photoArray addObject:newItem];
                                                        }
                                                        
                                                        
                                                        [self.tableView reloadData];

                                                    }];
                                        }];
        
        
        [jsonData resume];
}

- (IBAction)refreshJSON:(id)sender {
    [self weatherCollection:_jsonURL];
}

@end
