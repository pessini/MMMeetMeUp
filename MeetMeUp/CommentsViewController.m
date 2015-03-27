//
//  CommentsViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/24/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property NSArray *commentsArray;

@end

NSString * const API_URL_EVENT = @"https://api.meetup.com/2/event_comments?offset=0&sign=True&format=json&event_id=";

// 2/event_comments?offset=0&format=json&event_id=221063031&photo-host=public&page=20&order=time&desc=desc&sig_id=123701892&sig=3ec17eb4b18de94939e2a17b80a2344694e48a2a

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView Delegates
    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;

    [self apiRequestFromURL:[NSString stringWithFormat:@"%@%@&photo-host=public&page=1&order=time&desc=desc", API_URL_EVENT, self.eventID]];


    NSLog(@"%@", self.commentsArray);
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.commentsTableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    NSDictionary *comments = [self.commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [comments objectForKey:@"member_name"];
    cell.detailTextLabel.text = [comments objectForKey:@"comment"];

    return cell;
}

#pragma mark -Helper Methods

-(void)apiRequestFromURL: (NSString *)string
{
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
    {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&connectionError];
        NSLog(@"%@", dictionary);
        self.commentsArray = [dictionary objectForKey:@"results"];
        [self.commentsTableView reloadData];
    }];
}

@end
