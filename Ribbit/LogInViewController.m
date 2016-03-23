//
//  LogInViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import <VungleSDK/VungleSDK.h>
@interface LogInViewController () <VungleSDKDelegate>

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
}

//Vungle Ad

- (IBAction)playAd:(id)sender {
	UIAlertController * alert= [UIAlertController
								alertControllerWithTitle:@"Play Ad"
								message:@"You are going to watch an Ad!"
								preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction* yesButton = [UIAlertAction
								actionWithTitle:@"Yes, please"
								style:UIAlertActionStyleDefault
								handler:^(UIAlertAction * action)
								{
									VungleSDK *sdk = [VungleSDK sharedSDK];
									[sdk setDelegate:self];
									[sdk setMuted:NO];
									[sdk setLoggingEnabled:YES];
									NSDictionary* options = @{VunglePlayAdOptionKeyIncentivized: @YES,
															VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"If the video isn't completed you won't get your reward! Are you sure you want to close early?",
													    VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"Close",
														VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"Continue",
														
														VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"Attention!"};
									NSError *error;
									[sdk playAd:self withOptions:options error:&error];
									if (error) {
										NSLog(@"Error encouterd while playing Ad:%@",error);
									}

									
								}];
	UIAlertAction* noButton = [UIAlertAction
							   actionWithTitle:@"No, thanks"
							   style:UIAlertActionStyleDefault
							   handler:^(UIAlertAction * action)
							   {
							   }];
	
	[alert addAction:yesButton];
	[alert addAction:noButton];
	
	[self presentViewController:alert animated:YES completion:nil];

}
#pragma mark - Delegate

- (void)vungleSDKwillShowAd {
	
	NSLog(@"Ad is about to play!");

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
