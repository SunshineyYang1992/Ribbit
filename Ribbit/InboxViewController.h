//
//  InboxViewController.h
//  Ribbit
//
//  Created by Sunshine Yang on 5/30/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>
@interface InboxViewController : UITableViewController

@property (nonatomic,strong) NSArray *messages;

@property (nonatomic,strong) PFObject *selectedMessage;

@property (nonatomic,strong) MPMoviePlayerController  *moviePlayer;
- (IBAction)logout:(id)sender;

@end
