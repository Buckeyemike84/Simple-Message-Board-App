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

@interface PostsTableViewController () <UIAlertViewDelegate>

@end

@implementation PostsTableViewController 

-(id) initWithCoder:(NSCoder *)aDecoder	{
	if (self = [super initWithCoder:aDecoder]){
		_posts = [[NSMutableArray alloc] init];
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
	[self.postsViewDelegate refreshWasRequested];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PostCell";
    ViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
	
	NSDictionary *post = self.posts[indexPath.row];
	NSString *postString = [NSString stringWithFormat:@"%@: %@",post[@"name"],post[@"content"]];
	cell.contentLabel.text = postString;
	cell.dateLabel.text = post[@"timestamp"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        NSDictionary *deletedPost = self.posts[indexPath.row];
		
		[self.posts removeObjectAtIndex:indexPath.row];
		[self.postsViewDelegate deletePost:deletedPost];
		
		[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSDictionary *post = self.posts[indexPath.row];
	NSString *alertString = [NSString stringWithFormat:@"%@\n%@",post[@"content"],post[@"timestamp"]];
	[[[UIAlertView alloc] initWithTitle:post[@"name"] message:alertString delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil] show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


@end
