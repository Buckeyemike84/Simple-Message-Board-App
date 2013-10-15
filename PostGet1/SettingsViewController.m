//
//  SettingsViewController.m
//  PostGet1
//
//  Created by Mark on 8/23/13.
//  Copyright (c) 2013 Mark Hambly. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;

@end

@implementation SettingsViewController

-(void) viewDidLoad {
	self.nameField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (IBAction)saveButtonPressed:(id)sender {
	[[NSUserDefaults standardUserDefaults] setObject:self.nameField.text forKey:@"name"];
	[self performSegueWithIdentifier:@"UnwindToMainView" sender:self];
}

@end
