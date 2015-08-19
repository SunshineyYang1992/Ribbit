//
//  LogInViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>

@interface LogInViewController ()

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
}



- (IBAction)login:(id)sender {
	
	NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	if ([username length] == 0 || [password length] == 0 ) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Make sure you enter a username, password and !" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
		[alertView show];
	}
	else {
		[PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
			if (error) {
				UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"]
																   delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil];
				[alertView show];
			}
			else {
				[self.navigationController popToRootViewControllerAnimated:YES];
			}
		}];
		
	}
	
}
@end
