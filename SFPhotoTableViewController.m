//
//  SFJSONTableViewController.m
//  SFNetworkApp
//
//  Created by Spencer Fornaciari on 11/12/13.
//  Copyright (c) 2013 Spencer Fornaciari. All rights reserved.
//

#import "SFPhotoTableViewController.h"

#define api_key @"3bfca7acbc13885f9a02d1efdc32e592"
#define user_id @"62543166@N02"
#define core_flickr @"http://api.flickr.com/services/rest/?&method="

@interface SFPhotoTableViewController () <NSURLSessionDataDelegate>

@end

@implementation SFPhotoTableViewController
{
    NSURL *_photoURL;
    NSURLSessionDataTask *_photoDataTask;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userPhotos = [[SFPhotoModel alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    
    [self refreshPhotoTable];

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
    NSURL *url = [NSURL URLWithString:[self.photoArray[indexPath.row] photoLocationSmall]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        controller.navigationItem.title = [self.photoArray[indexPath.row] photoTitle];
        //NSLog(@"%ld", [self.tableView indexPathForSelectedRow]);
//
//
//        [self presentViewController:controller animated:YES completion:nil];
        
        // do some prep based on indexPath, if needed
        
    }
}

#pragma mark - Photo JSON Methods

//Photo JSON get method
-(void)photoCollection:(NSURL *)photoLocation
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration: configuration
                                                          delegate: self
                                                     delegateQueue: nil];
    
    __block NSMutableArray *blockPhotoArray = [NSMutableArray new];
    
    _photoDataTask = [session dataTaskWithURL:photoLocation
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
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
                                                    
                                                    //Create small photo and large photo URL's
                                                    [newItem createPhotoLocation];
                                                    
                                                    [blockPhotoArray addObject:newItem];
                                                }

                                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                                    self.photoArray = [NSMutableArray arrayWithArray:blockPhotoArray];
                                                    [self.tableView reloadData];
                                                }];
                                    }];
    
    [_photoDataTask resume];
}


//Refresh photo table, check if task is in process, cancel if it is
-(void)refreshPhotoTable
{
    _photoURL = [NSURL URLWithString:@"http://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&format=json&api_key=3bfca7acbc13885f9a02d1efdc32e592&user_id=62543166@N02&per_page=25&nojsoncallback=1"];
    if (_photoDataTask && _photoDataTask.state != NSURLSessionTaskStateCompleted) {
        [_photoDataTask cancel];
    }
    [self photoCollection:_photoURL];
}


- (IBAction)refreshJSON:(id)sender
{
    [self refreshPhotoTable];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //scrollView.delegate = self;
    //NSLog(@"The table is scrolling: %@", [self.tableView indexPathsForVisibleRows];);
    //NSArray *array = [self.tableView visibleCells];
    
    //NSLog(@"%@", array[1]);
    
    
   // [self.tableView.visibleCells]
    
    
//    NSUInteger index = [self.photoArray indexOfObject:SFPhotoModel];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//    if ([self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                              withRowAnimation:UITableViewRowAnimationFade];
//        NSLog(@"%ld", (long)indexPath.row);
//    }
    
}

@end
