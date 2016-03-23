//
//  InboxViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 5/30/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"
@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	

	self.moviePlayer = [[MPMoviePlayerController alloc] init];
	
	PFUser *currentUser = [PFUser currentUser];
	if (currentUser) {
		NSLog(@"%@",currentUser.username);
	}
	else {
		[self performSegueWithIdentifier:@"showLogin" sender:self];

	}
	
	
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
	[query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
	[query orderByDescending:@"createdAt"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
		if (error) {
			NSLog(@"Error: %@ %@",error,[error userInfo]);
		}else {
			self.messages = objects;
			[self.tableView reloadData];
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.messages.count;
}

#pragma mark -Table view delegate 

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	
	PFObject *message = self.messages[indexPath.row];
	cell.textLabel.text = [message objectForKey:@"senderName"];
	NSString *fileType = [message objectForKey:@"fileType"];
	if ([fileType isEqualToString:@"image"]) {
		cell.imageView.image = [UIImage imageNamed:@"icon_image"];
	}
	else {
		cell.imageView.image = [UIImage imageNamed:@"icon_video"];
	}
	return cell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedMessage = self.messages[indexPath.row];
	NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
	if ([fileType isEqualToString:@"image"]) {
		[self performSegueWithIdentifier:@"showImage" sender:self];
	}
	else {
		PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
		NSURL *fileURL = [NSURL URLWithString:videoFile.url];
		self.moviePlayer.contentURL = fileURL;
		[self.moviePlayer prepareToPlay];
		[self.view addSubview:self.moviePlayer.view];
		[self.moviePlayer setFullscreen:YES animated:YES]; 
	}
	NSMutableArray *recipientsIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
	if (recipientsIds.count == 1) {
		[self.selectedMessage deleteInBackground];
	} else {
		[recipientsIds removeObject:[[PFUser currentUser] objectId]];
		[self.selectedMessage setObject:recipientsIds forKey:@"recipientIds"];
		[self.selectedMessage saveInBackground];
	}
									 
}


- (IBAction)logout:(id)sender {
	[PFUser logOut];
	[self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showLogin"]) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
	} else if ([segue.identifier isEqualToString:@"showImage"]) {
		[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
		ImageViewController *imageVIewController = (ImageViewController *) segue.destinationViewController;
		imageVIewController.messages = self.selectedMessage;
		

	}
}





@end
