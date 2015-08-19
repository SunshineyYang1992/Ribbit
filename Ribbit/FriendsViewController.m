//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsTableViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];


}

- (void) viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];

	PFQuery *query = [ self.friendsRelation	query];
	[query orderByAscending:@"username"];
	[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
	 {
		 if (error) {
			 NSLog(@"Error: %@ %@",error,[error userInfo]);
		 }
		 else {
			 self.friends = objects;
			 [self.tableView reloadData];
		 }
		 
	 }];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"showEditFriends"]) {
		EditFriendsTableViewController *viewController = (EditFriendsTableViewController *)segue.destinationViewController;
		viewController.friends = [NSMutableArray arrayWithArray:self.friends];
		
	}
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
    return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	PFUser *user = self.friends[indexPath.row];
	cell.textLabel.text = user.username;
    return cell;
}




@end
