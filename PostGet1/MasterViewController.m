//
//  MasterViewController.m
//  PostGet1
//
//  Created by Mark on 8/22/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MasterViewController.h"
#import "PostsTableViewController.h"

NSString *const POSTGETURL = @"http://fermenticus.com/postget";

@interface MasterViewController () <PostsViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *postField;
@property (weak, nonatomic) PostsTableViewController *postsTableViewController;

@end

@implementation MasterViewController {
	NSURLConnection *_postConnection;
	NSMutableString *_postResponse;
	NSURLConnection *_getConnection;
	NSMutableData *_getResponse;
	NSURLConnection *_deleteConnection;
	NSMutableString *_deleteResponse;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UISwipeGestureRecognizer *rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedRight:)];
	[rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
	[rightSwipeRecognizer setNumberOfTouchesRequired:1];
	
	UISwipeGestureRecognizer *leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedLeft:)];
	[leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
	[leftSwipeRecognizer setNumberOfTouchesRequired:1];
	[self.view setGestureRecognizers:@[rightSwipeRecognizer, leftSwipeRecognizer]];
	
	[self refreshPostData];
	[self.postField becomeFirstResponder];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"EmbedPostsTableView"]){
		self.postsTableViewController = segue.destinationViewController;
		self.postsTableViewController.postsViewDelegate = self;
	}
}

- (void) swipedRight:(id)sender {

	
}

-(void) swipedLeft:(id)sender {

	
}

#pragma mark - Fun With Connections

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
	_postResponse = [[NSMutableString alloc] init];
	
	[self.activityIndicator startAnimating];
	
}

-(void) connection:(NSURLConnection *)conn didReceiveData:(NSData *)data {
	if (conn == _postConnection){
		NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[_postResponse appendString:responseString];
	} else if (conn == _getConnection){
		[_getResponse appendData:data];
	} else if (conn == _deleteConnection){
		NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[_deleteResponse appendString:responseString];
	}
}

-(void) connectionDidFinishLoading: (NSURLConnection *)conn {
	if (conn == _postConnection){
		self.postField.text = nil;
		self.postField.placeholder = _postResponse;
//		NSLog(@"%@",_postResponse);
		[self refreshPostData];
		
	} else if (conn == _getConnection){
		self.postsTableViewController.posts = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:_getResponse
																			  options:0
																				error:nil]];
		[self.postsTableViewController.tableView reloadData];
		[self.postsTableViewController didFinishLoading];
		[self.activityIndicator stopAnimating];
	} else if (conn == _deleteConnection){
		
		[self refreshPostData];
		self.postField.placeholder = _deleteResponse;
//		NSLog(@"%@",_deleteResponse);
		[self.postsTableViewController didFinishLoading];
		[self.activityIndicator stopAnimating];
	}
}

-(void) connection:(NSURLConnection *) connection didFailWithError:(NSError *)error {
	_postConnection = nil;
	_postResponse = nil;
	_getConnection = nil;
	_getResponse = nil;
	_deleteConnection = nil;
	_deleteResponse	= nil;
	
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

#pragma mark - PostsView Delegate

-(void) refreshWasRequested {
	[self refreshPostData];
}

-(void) deletePost:(NSDictionary *)postToDelete {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
									initWithURL:[NSURL URLWithString:[POSTGETURL stringByAppendingString:@"/delete.php"]]];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
	
	NSData *dataToDelete = [NSJSONSerialization dataWithJSONObject:postToDelete options:0 error:nil];
	
	[request setHTTPBody:dataToDelete];
	
	_deleteConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	_deleteResponse = [[NSMutableString alloc] init];
	
	[self.activityIndicator startAnimating];

}

-(IBAction)unwindToMainView: (UIStoryboardSegue *)segue{
	
}

@end
