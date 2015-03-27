//
//  CommentsViewController.m
//  MeetMeUp
//
//  Created by Leandro Pessini on 3/24/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "CommentsViewController.h"
#import "ProfileViewController.h"

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property NSArray *commentsArray;
@property Comments *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // tableView Delegates
    self.commentsTableView.dataSource = self;
    self.commentsTableView.delegate = self;

    self.comments = [Comments new];
    [self getDataFromAPI];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.commentsTableView dequeueReusableCellWithIdentifier:@"CommentCell"];

    if (self.commentsArray.count > 0)
    {

        Comments *comment = [self.commentsArray objectAtIndex:indexPath.row];

        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",
                               comment.memberName,
                               [self convertStringTimestampToDate:comment.time]];
        cell.detailTextLabel.text = comment.comment;
    }
    else
    {
        cell.textLabel.text = @"This event has no comments.";
    }

    return cell;
}

- (void)getDataFromAPI
{
    [self.comments requestCommentsFromEventID:self.eventID withCompletionHandler:^(NSMutableArray *comments) {
        self.commentsArray = comments;
        [self.commentsTableView reloadData];
    }];
}

-(NSString *)convertStringTimestampToDate:(NSString *) string
{
    NSString *timeStampString = string;
    NSTimeInterval interval = [timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd 'at' HH:mm"];
    return [formatter stringFromDate:date];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell
{
    if ([segue.identifier isEqualToString:@"ShowProfileSegue"])
    {
        ProfileViewController *vc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.commentsTableView indexPathForCell:cell];
        Comments *comment = [self.commentsArray objectAtIndex:indexPath.row];
        vc.commentID = comment.commentID;
        vc.groupID = comment.groupID;
        vc.memberID = comment.memberID;
        vc.eventID = comment.eventID;
    }
}

@end
