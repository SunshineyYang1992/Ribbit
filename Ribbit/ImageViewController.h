//
//  ImageViewController.h
//  Ribbit
//
//  Created by Sunshine Yang on 6/2/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ImageViewController : UIViewController

@property (strong,nonatomic) PFObject *messages;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
