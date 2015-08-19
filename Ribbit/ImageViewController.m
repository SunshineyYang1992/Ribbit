//
//  ImageViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 6/2/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	PFFile *imageFile = [self.messages objectForKey:@"file"];
	NSURL *imageFileURL = [[NSURL alloc] initWithString:imageFile.url];
	NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
	self.imageView.image = [UIImage imageWithData:imageData];
	NSString *senderName = [self.messages objectForKey:@"senderName" ];
	NSString *title = [NSString stringWithFormat:@"Sent From %@",senderName];
	self.navigationItem.title = title;
	
}
- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([self respondsToSelector:@selector(timeout)]) {
		
		[NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
	}else {
		NSLog(@"Error: selector missing");
	}
	

}
#pragma mark - Helper method

- (void) timeout {
	[self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
