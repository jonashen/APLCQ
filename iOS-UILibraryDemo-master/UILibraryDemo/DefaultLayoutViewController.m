//
//  DefaultLayoutViewController.m
//  UILibraryDemo
//
//  Created by DJI on 16/4/2017.
//  Copyright © 2017 DJI. All rights reserved.
//

#import "DroneControl.h"
#import "DefaultLayoutViewController.h"

//@interface DefaultLayoutViewController ()<DJISDKManagerDelegate>
@interface DefaultLayoutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *dataTextView;
@property (weak, nonatomic) IBOutlet UITextView *t2;

@end

@implementation DefaultLayoutViewController

static DroneControl * droneControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [DJISDKManager registerAppWithDelegate:self];
    droneControl = [[DroneControl alloc] init];
    droneControl->vc = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self registerApp];
}

//- (void)registerApp
//{
//    [DJISDKManager registerAppWithDelegate:self];
//}

- (void)showAlertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alertViewController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okAction];
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [rootViewController presentViewController:alertViewController animated:YES completion:nil];
    });
}

#pragma mark DJISDKManager Delegate Methods
//- (void)appRegisteredWithError:(NSError *)error
//{
//    if (!error) {
//        [self showAlertViewWithMessage:@"Registration Success"];
//        [DJISDKManager startConnectionToProduct];
//    }else
//    {
//        [self showAlertViewWithMessage:[NSString stringWithFormat:@"Registration Error:%@", error]];
//    }
//}

- (void)showAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
//
//- (void)productConnected:(DJIBaseProduct *)product
//{
//
//    //If this demo is used in China, it's required to login to your DJI account to activate the application. Also you need to use DJI Go app to bind the aircraft to your DJI account. For more details, please check this demo's tutorial.
//    [[DJISDKManager userAccountManager] logIntoDJIUserAccountWithAuthorizationRequired:NO withCompletion:^(DJIUserAccountState state, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"Login failed: %@", error.description);
//        }
//    }];
//}

-(BOOL) changeState:(NSString*) newState  {
    return [droneControl stateChange:newState];
}

- (IBAction)rotateGimbal:(id)sender {
    [droneControl rotateGimbalUp];
//    [droneControl rotateGimbalDown];
}

-(void) displayData: (NSArray*)fcd : (NSArray*)velocities {
    _dataTextView.text = [NSString stringWithFormat:@"Roll: %.02f, Pitch: %.02f, Yaw: %.02f, Throttle: %.02f\nVelocityX: %.02f, VelocityY: %.02f, VelocityZ: %.02f",
                          [fcd[0] floatValue], [fcd[1] floatValue], [fcd[2] floatValue], [fcd[3] floatValue], [velocities[0] floatValue], [velocities[1] floatValue], [velocities[2] floatValue]];
}

- (IBAction)rotateLeft:(id)sender {
    [droneControl rotateDroneLeft];
}
- (IBAction)rotateRight:(id)sender {
    [droneControl rotateDroneRight];
}

- (IBAction)roll:(id)sender {
    [droneControl updateJoystick:0];
}

- (IBAction)pitch:(id)sender {
    [droneControl updateJoystick:1];
}
- (IBAction)yaw:(id)sender {
    [droneControl updateJoystick:2];
}

- (IBAction)throttle:(id)sender {
    [droneControl updateJoystick:3];
}

- (IBAction)land:(id)sender {
//    [droneControl land];
    [droneControl autoLand:10];
}

- (IBAction)disable:(id)sender {
    [droneControl disableUserControl];
}

- (IBAction)enable:(id)sender {
    [droneControl enableUserControl];
}

-(void) test {
    _dataTextView.text = @"Working";
}

@end
