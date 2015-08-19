//
//  EditFriendsTableViewController.h
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsTableViewController : UITableViewController

@property (nonatomic,strong) NSArray *allUsers;

@property (nonatomic,strong) PFUser *currentUser;

- (BOOL) isFriend:(PFUser *)user ;

@property (nonatomic,strong) NSMutableArray *friends;

@end
