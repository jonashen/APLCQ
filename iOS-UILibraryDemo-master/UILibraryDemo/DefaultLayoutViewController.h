//
//  DefaultLayoutViewController.h
//  UILibraryDemo
//
//  Created by DJI on 16/4/2017.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <DJIUILibrary/DJIUILibrary.h>

@interface DefaultLayoutViewController : DULDefaultLayoutViewController

-(void) displayData: (NSArray*)fcd : (NSArray*)velocities;
-(void) test;
- (void)showAlertViewWithMessage:(NSString *)message;
@end
