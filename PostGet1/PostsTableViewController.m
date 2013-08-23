//
//  PostsTableViewController.m
//  PostGet1
//
//  Created by Mark on 8/23/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PostsTableViewController.h"
#import "ViewCell.h"

@implementation PostsTableViewController 

-(id) initWithCoder:(NSCoder *)aDecoder	{
	if (self = [super initWithCoder:aDecoder]){
		_posts = [[NSArray alloc] init];
	}
	return self;
}

#pragma mark - Table view data source

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.layer.borderColor = [UIColor blackColor].CGColor;
	self.tableView.layer.borderWidth = 1.0f;
	
	self.refreshControl = [[UIRefreshControl alloc] init];
	[self.refreshControl addTarget:self action:@selector(refreshRequested:) forControlEvents:UIControlEventValueChanged];
}

- (void) refreshRequested: (id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh Requested" object:nil];
}

- (void) didFinishLoading {
	[self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	NSDictionary *post = self.posts[indexPath.row];
	cell.contentLabel.text = post[@"content"];
	cell.dateLabel.text = post[@"timestamp"];
    
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

@end
