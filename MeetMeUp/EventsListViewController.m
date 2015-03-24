//
//  ViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/23/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "EventsListViewController.h"
#import "EventDetailViewController.h"

@interface EventsListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property NSArray *eventsArray;
@property NSArray *searchResults;
@property (nonatomic, strong) UISearchController *searchController;

@end

NSString * const API_URL = @"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=679336f676c69291d1f183928375451";


@implementation EventsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView Delegates
    self.eventsTableView.dataSource = self;
    self.eventsTableView.delegate = self;

    // API Key
    // 679336f676c69291d1f183928375451
    // URL:  https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=679336f676c69291d1f183928375451

    [self apiRequestFromURL:API_URL];

    // search bar
    self.searchResults = [[NSArray alloc] initWithArray:self.eventsArray];


    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    // delegate
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;


    // make a searchBar object
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width,
                                                       44.0);
    self.eventsTableView.tableHeaderView = self.searchController.searchBar;

    self.definesPresentationContext = YES;
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active)
    {
        return self.searchResults.count;
    }
    else
    {
        return self.eventsArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.eventsTableView dequeueReusableCellWithIdentifier:@"EventCell"];
    NSDictionary *events;

    if (self.searchController.active)
    {
        events = [self.searchResults objectAtIndex:indexPath.row];
    }
    else
    {
        events = [self.eventsArray objectAtIndex:indexPath.row];
    }

//    NSURL *imageURL = [NSURL URLWithString:[events objectForKey:@"avatar_url"]];

    NSString *fullAddress;
    if ([[events valueForKey:@"venue"]
         objectForKey:@"address_1"])
    {
        fullAddress = [NSString stringWithFormat:@"%@ - %@/%@",
                             [[events valueForKey:@"venue"]
                              objectForKey:@"address_1"],
                             [[events valueForKey:@"venue"]
                              objectForKey:@"city"],
                             [[events valueForKey:@"venue"]
                              objectForKey:@"state"]];
    }
    else
    {
        fullAddress = @"No address";
    }

    cell.textLabel.text = [events objectForKey:@"name"];
    cell.detailTextLabel.text = fullAddress;
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];

    return cell;
}

#pragma mark -Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"EventDetailSegue"])
    {
        NSIndexPath *indexPath = [self.eventsTableView indexPathForCell:cell];
        EventDetailViewController *vc = segue.destinationViewController;

        if (self.searchController.active)
        {
            vc.eventDetails =  [self.searchResults objectAtIndex:indexPath.row];
        }
        else
        {
            vc.eventDetails =  [self.eventsArray objectAtIndex:indexPath.row];
        }
    }
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchString];
    self.searchResults = [self.eventsArray filteredArrayUsingPredicate:resultPredicate];
    [self.eventsTableView reloadData];
}

#pragma mark -UISearchControllerDelegate

-(void)willPresentSearchController:(UISearchController *)searchController
{
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    [self.eventsTableView scrollRectToVisible:searchBarFrame animated:NO];
}

#pragma mark -Helper Methods

-(void)apiRequestFromURL: (NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (!data) {
            NSLog(@"%s: sendAynchronousRequest error: %@", __FUNCTION__, connectionError);
            return;
        } else if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200) {
                NSLog(@"%s: sendAsynchronousRequest status code != 200: response = %@", __FUNCTION__, response);
                return;
            }
        }

        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
        if (!dictionary)
        {
            NSLog(@"%s: JSONObjectWithData error: %@; data = %@", __FUNCTION__, parseError, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            return;
        }

        self.eventsArray = [dictionary objectForKey:@"results"];
        [self.eventsTableView reloadData];

    }];
}

@end
