//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsViewController : UITableViewController

@property (strong,nonatomic) PFRelation *friendsRelation;

@property (strong,nonatomic) NSArray *friends;



@end
