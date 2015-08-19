//
//  CameraViewController.m
//  Ribbit
//
//  Created by Sunshine Yang on 5/31/15.
//  Copyright (c) 2015 SunshineYang. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.recipients = [[NSMutableArray alloc]init];


	
}
- (void) viewWillAppear:(BOOL)animated {
	self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
	[super viewWillAppear:animated];
	if (self.image == nil && [self.videoFilePath length] ==0 ) {
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
		if (self.image == nil && [self.videoFilePath length]== 0) {
			self.imagePicker = [[UIImagePickerController alloc]init];
			self.imagePicker.delegate = self;
			self.imagePicker.allowsEditing = NO;
			self.imagePicker.videoMaximumDuration = 10;
			if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
				self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
			}
			else {
				self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
			}
			self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType ];
			[self presentViewController:self.imagePicker animated:NO completion:nil];
		}
		
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
	if ([self.recipients containsObject:user.objectId]) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else
		cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - did select

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
	PFUser *user = self.friends[indexPath.row];
	if (cell.accessoryType ==UITableViewCellAccessoryNone) {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
		[self.recipients addObject:user.objectId];
		
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryNone;
		[self.recipients removeObject:user.objectId];
	}
}


- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[self dismissViewControllerAnimated:NO completion:nil];
	[self.tabBarController setSelectedIndex:0];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
	if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
		self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
		if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
			UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
		}
	}
	else {
		self.videoFilePath =(__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL]path]);
		if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
			if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
				UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
			}
		}
	}
	[self dismissViewControllerAnimated:YES completion:nil];

	
}
#pragma mark - IBAction


- (IBAction)cancel:(id)sender {
	[self reset];
	[self.tabBarController setSelectedIndex:0];
	
	
}

- (IBAction)send:(id)sender {
	if (self.image == nil && [self.videoFilePath length]==0) {
		UIAlertView *alertView = [[UIAlertView init] initWithTitle:@"Try Again"
														   message:@"Please capture or select picture/video for sure!"
														  delegate:nil
												 cancelButtonTitle:nil otherButtonTitles:nil];
		[alertView show];
		[self presentViewController:self.imagePicker animated:NO completion:nil];
	}else {
		[self uploadMessage];
		[self.tabBarController setSelectedIndex:0];
		
	}
}
#pragma mark- Helper methods

- (UIImage *) resizeImage: (UIImage *) image toWidth:(float)width andHeight:(float ) height{
	CGSize newSize = CGSizeMake(width, height);
	CGRect newRect = CGRectMake(0, 0, width, height);
	UIGraphicsBeginImageContext(newSize);
	[image drawInRect:newRect];
	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resizedImage;
	
	
}

- (void) uploadMessage {
	
	NSData *fileData;
	NSString *fileName;
	NSString *fileType;
	
	if (self.image !=nil) {
		UIImage *newImage = [self resizeImage:self.image toWidth:320.0f andHeight:480.0f];
		fileData = UIImagePNGRepresentation(newImage);
		fileName = @"image.png";
		fileType = @"image";
		
	}else {
		fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
		fileName = @"video.mov";
		fileType = @"video";
	}
	PFFile *file = [PFFile fileWithName:fileName data:fileData];
	[file saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
		if (error) {
			UIAlertView *alertView = [[UIAlertView init] initWithTitle:@"An error occured"
															   message:@"Please try sending your message again"
															  delegate:nil
													 cancelButtonTitle:nil otherButtonTitles:nil];
			[alertView show];
		} else {
			PFObject *message = [PFObject objectWithClassName:@"Messages"];
			[message setObject:file forKey:@"file"];
			[message setObject:fileType forKey:@"fileType"];
			[message setObject:self.recipients forKey:@"recipientIds"];
			[message setObject:[[PFUser currentUser] objectId] forKey:@"senderId"];
			[message setObject:[[PFUser currentUser] username] forKey:@"senderName" ];
			[message saveInBackgroundWithBlock:^(BOOL succeed, NSError *error){
				if (error) {
					UIAlertView *alertView = [[UIAlertView init] initWithTitle:@"An error occured"
																	   message:@"Please try sending your message again"
																	  delegate:nil
															 cancelButtonTitle:nil otherButtonTitles:nil];
					[alertView show];
				}else {
					[self reset];

				}
			}];
			
			
			
		}
	}];
	
	
	
}
- (void)reset {
	self.image = nil;
	self.videoFilePath = nil;
	[self.recipients removeAllObjects];
}


@end