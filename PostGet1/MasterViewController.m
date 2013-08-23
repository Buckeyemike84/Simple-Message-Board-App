//
//  MasterViewController.m
//  PostGet1
//
//  Created by Mark on 8/22/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "MasterViewController.h"
#import "PostsTableViewController.h"

NSString *const POSTGETURL = @"http://fermenticus.com/postget";

@interface MasterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *postField;
@property (weak, nonatomic) PostsTableViewController *postsTableViewController;

@end

@implementation MasterViewController {
	NSURLConnection *_postConnection;
	NSString *_postResponse;
	NSURLConnection *_getConnection;
	NSMutableData *_getResponse;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(refreshPostData)
												 name:@"Refresh Requested"
											   object:nil];
	[self refreshPostData];
	[self.postField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"EmbedPostsTableView"]){
		self.postsTableViewController = segue.destinationViewController;
	}
}

- (void)refreshPostData {
	NSURL *url = [NSURL URLWithString:[POSTGETURL stringByAppendingString:@"/get.php"]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	_getConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
	_getResponse = [[NSMutableData alloc] init];
}

- (IBAction)postButtonPressed:(id)sender {
	[self.postField resignFirstResponder];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
									initWithURL:[NSURL URLWithString:[POSTGETURL stringByAppendingString:@"/post.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"text/xml" forHTTPHeaderField:@"Content-type"];
	NSString *textString = self.postField.text;
	
	[request setValue:[NSString stringWithFormat:@"%d",textString.length] forHTTPHeaderField:@"Content-length"];
	
	[request setHTTPBody:[textString dataUsingEncoding:NSUTF8StringEncoding]];

	_postConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	_postResponse = [[NSString alloc] init];
	
	[self.activityIndicator startAnimating];
	
}

-(void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	if (conn == _postConnection){
		NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		_postResponse = [_postResponse stringByAppendingString:responseString];
	} else if (conn == _getConnection){
		[_getResponse appendData:data];
	}
}

-(void) connectionDidFinishLoading: (NSURLConnection *)conn {
	if (conn == _postConnection){
		self.postField.text = nil;
		self.postField.placeholder = _postResponse;
		[self refreshPostData];
		
	} else if (conn == _getConnection){
		self.postsTableViewController.posts = [NSJSONSerialization JSONObjectWithData:_getResponse
																			  options:0
																				error:nil];
		[self.postsTableViewController.tableView reloadData];
		[self.postsTableViewController didFinishLoading];
		[self.activityIndicator stopAnimating];
	}
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error {
	_postConnection = nil;
	_postResponse = nil;
	_getConnection = nil;
	_getResponse = nil;
	NSString *errorString = [NSString stringWithFormat:@"Error! %@",[error localizedDescription]];
	
	[self.activityIndicator stopAnimating];
	[self.postsTableViewController didFinishLoading];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
													message:errorString
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
}


@end
