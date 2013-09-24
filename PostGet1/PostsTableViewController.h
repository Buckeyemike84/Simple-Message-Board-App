//
//  PostsTableViewController.h
//  PostGet1
//
//  Created by Mark on 8/23/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

@class PostsTableViewController;
@protocol PostsViewDelegate <NSObject>
- (void)refreshWasRequested;
- (void)deletePost:(NSDictionary *)postToDelete;
@end

@interface PostsTableViewController : UITableViewController

@property (nonatomic, weak) id <PostsViewDelegate> postsViewDelegate;
@property (nonatomic, strong) NSMutableArray *posts;

- (void) didFinishLoading;

@end
