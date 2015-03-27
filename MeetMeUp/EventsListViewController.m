//
//  ViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/23/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "EventsListViewController.h"
#import "EventDetailViewController.h"
#import "Events.h"

@interface EventsListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property NSArray *eventsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property Events *articles;

@end

NSString * const API_URL = @"https://api.meetup.com/2/open_events.json?zip=60604&text=mobile&time=,1w&key=679336f676c69291d1f183928375451";


@implementation EventsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView Delegates
    self.eventsTableView.dataSource = self;
    self.eventsTableView.delegate = self;

    // Search Bar Delegate
    self.searchBar.delegate = self;

    self.articles = [Events new];

    [self getDataFromAPI];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.eventsTableView dequeueReusableCellWithIdentifier:@"EventCell"];

    Events *article = [self.eventsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = article.eventName;
    cell.detailTextLabel.text = article.fullAddress;

    return cell;
}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = searchBar.text;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    if (![[searchString stringByTrimmingCharactersInSet:charSet] length] == 0) {
        [self.articles searchWithKeyword:searchString withCompletionHandler:^(NSMutableArray *searchArray) {
            self.eventsArray = searchArray;
            [self.eventsTableView reloadData];
        }];
    }
}

#pragma mark - Helper Method

- (void)getDataFromAPI {
    [self.articles searchWithKeyword:@"mobile" withCompletionHandler:^(NSMutableArray *searchArray) {
        self.eventsArray = searchArray;
        [self.eventsTableView reloadData];
    }];
}

#pragma mark -Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"EventDetailSegue"])
    {
        NSIndexPath *indexPath = [self.eventsTableView indexPathForCell:cell];
        UINavigationController *navigationController = segue.destinationViewController;
        EventDetailViewController *eventDetailViewController = navigationController.viewControllers[0];
        Events *event = [self.eventsArray objectAtIndex:indexPath.row];
        NSLog(@"%@", event);
        eventDetailViewController.event = event;
    }
}
@end
