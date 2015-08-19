//
//  SignUpViewController.h
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordFiedl;

@property (weak, nonatomic) IBOutlet UITextField *emailField;


- (IBAction)signup:(id)sender;

@end
