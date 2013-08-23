//
//  PostsTableViewController.h
//  PostGet1
//
//  Created by Mark on 8/23/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *posts;

- (void) didFinishLoading;

@end
