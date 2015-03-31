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
@property (nonatomic)  NSArray *eventsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property Events *events;

@end

@implementation EventsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView Delegates
    self.eventsTableView.dataSource = self;
    self.eventsTableView.delegate = self;

    // Search Bar Delegate
    self.searchBar.delegate = self;

    self.events = [Events new];
    [self getDataFromAPI];
}

-(void)setEventsArray:(NSArray *)eventsArray
{
    _eventsArray = eventsArray;
    [self.eventsTableView reloadData];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchString = searchBar.text;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    if (![[searchString stringByTrimmingCharactersInSet:charSet] length] == 0)
    {
        [Events retrieveEventsUsingKeyword:searchString withCompletionHandler:^(NSMutableArray *searchArray) {
            self.eventsArray = searchArray;
        }];
    }
}

#pragma mark - Helper Method

- (void)getDataFromAPI {
    [Events retrieveEventsUsingKeyword:@"mobile" withCompletionHandler:^(NSMutableArray *searchArray) {
        self.eventsArray = searchArray;
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
        eventDetailViewController.event = event;
    }
}
@end
