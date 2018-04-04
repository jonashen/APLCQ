//
//  SharedData.m
//  UILibraryDemo
//
//  Created by Jonathon Shen on 1/31/18.
//  Copyright © 2018 DJI. All rights reserved.
// https://developer.dji.com/api-reference/android-api/Components/FlightController/DJIFlightController_DJIFlightControllerCurrectState.html
// https://developer.dji.com/iframe/mobile-sdk-doc/android/reference/dji/sdk/FlightController/DJIFlightController.html
// https://developer.dji.com/iframe/mobile-sdk-doc/android/reference/dji/sdk/FlightController/DJIFlightControllerDataType.DJIFlightControllerCurrentState.html
// https://github.com/dji-sdk/Mobile-SDK-Doc/blob/master/source/ios-tutorials/PanoDemo.md


#import <Foundation/Foundation.h>
#import "SharedDJIData.h"

@implementation SharedDJIData

// Ability to do sharedDJIData.roll = 1.0;
@synthesize roll, pitch, yaw, throttle;

-(id)init
{
    self = [super init];
    roll = pitch = yaw = throttle = velocityX = velocityY = velocityZ = 0;
    [DJISDKManager registerAppWithDelegate:self];

    self.aircraftLocation = kCLLocationCoordinate2DInvalid;

    return self;
}

#pragma mark - FCD methods

-(NSArray *) getFCD
{
    [_lock lock];
    
//    [array release];    // To deallocate the array
    NSArray *fcd = [[NSArray alloc] initWithObjects:
                  [NSNumber numberWithFloat:roll],
                  [NSNumber numberWithFloat:pitch],
                  [NSNumber numberWithFloat:yaw],
                  [NSNumber numberWithFloat:throttle],
                  nil];
    
    [_lock unlock];
    return fcd;
}


-(void) setFCD:(NSArray *)array
{
    [_lock lock];
    
    roll = [[array objectAtIndex:0] floatValue];
    pitch = [[array objectAtIndex:1] floatValue];
    yaw = [[array objectAtIndex:2] floatValue];
    throttle = [[array objectAtIndex:3] floatValue];
    
    [_lock unlock];
}

-(void) updateFCD
{
    [_lock lock];
    
    DJIVirtualStickFlightControlData djiData;
    roll = djiData.roll;
    pitch = djiData.pitch;
    yaw = djiData.yaw;
    throttle = djiData.verticalThrottle;
    
    [_lock unlock];
}

-(void) printFCD {
    printf("FCD Data:\n");
    printf("Roll: %f\n", roll);
    printf("Pitch: %f\n", pitch);
    printf("Yaw: %f\n", yaw);
    printf("Throttle: %f\n", throttle);
}

#pragma mark - Velocity methods

-(NSArray *) getVelocity
{
    [_lock lock];
    
    //    [array release];    // To deallocate the array
    NSArray *vel = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:velocityX],
                    [NSNumber numberWithFloat:velocityY],
                    [NSNumber numberWithFloat:velocityZ], nil];
    [_lock unlock];
    return vel;
}

-(void) setVelocity:(NSArray *)array
{
    [_lock lock];
    
    velocityX = [[array objectAtIndex:0] floatValue];
    velocityY = [[array objectAtIndex:1] floatValue];
    velocityZ = [[array objectAtIndex:2] floatValue];
    
    [_lock unlock];
}

#pragma mark - IMU states

-(void) getIMUState {
    DJIIMUState *imuState;
    
    /* DJIIMUCalibrationStateNone    IMU not in calibration; no calibration is executing.
     DJIIMUCalibrationStateCalibrating    IMU calibration is in progress.
     DJIIMUCalibrationStateSuccessful    IMU calibration succeeded.
     DJIIMUCalibrationStateFailed    IMU calibration failed.
     DJIIMUCalibrationStateUnknown    Unknown calibration status.
     */
    /*
     DJIIMUSensorStateDisconnected    The IMU sensor is disconnected from the flight controller.
     DJIIMUSensorStateCalibrating    The IMU sensor is calibrating
     DJIIMUSensorStateCalibrationFailed    Calibrate of the IMU sensor failed.
     DJIIMUSensorStateDataException    The IMU sensor has a data exception. Calibrate the IMU and restart the aircraft. If afterwards the status still exists, you may need to contact DJI for further assistance.
     DJIIMUSensorStateWarmingUp    The IMU sensor is warming up.
     DJIIMUSensorStateInMotion    The IMU sensor is not static; the aircraft may not be stable enough to calculate sensor data correctly.
     DJIIMUSensorStateNormalBias    The IMU's bias value is normal; the aircraft can safely take off.
     DJIIMUSensorStateMediumBias    The IMU's bias value is medium; the aircraft can safely take off.
     DJIIMUSensorStateLargeBias    The IMU's bias value is large; the aircraft cannot take off. IMU calibration is needed.
     DJIIMUSensorStateUnknown    The IMU sensor's status is unknown.
     */
    if(imuState.calibrationState == DJIIMUSensorStateUnknown) {
        return;
    }
}

/* https://developer.dji.com/api-reference/ios-api/Components/IMUState/DJIIMUState.html#djiimustate_djiimucalibrationstatus_inline */
-(bool) areIMUsCalibrated {
    DJIIMUState *imuState;
    return (imuState.calibrationState == DJIIMUCalibrationStateSuccessful
            && (imuState.accelerometerState == DJIIMUSensorStateNormalBias
                || imuState.accelerometerState == DJIIMUSensorStateMediumBias)
            && (imuState.gyroscopeState == DJIIMUSensorStateNormalBias
                || imuState.gyroscopeState == DJIIMUSensorStateMediumBias)
            && (imuState.calibrationProgress == 100)
            );
}

#pragma mark - Fetch methods

- (DJIFlightController*) fetchFlightController {
    if (![DJISDKManager product]) {
        return nil;
    }
    if ([[DJISDKManager product] isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)[DJISDKManager product]).flightController;
    }
    
    return nil;
}

- (DJICamera*) fetchCamera {
    if (![DJISDKManager product]) {
        return nil;
    }
    if ([[DJISDKManager product] isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)[DJISDKManager product]).camera;
    }
    else if ([[DJISDKManager product] isKindOfClass:[DJIHandheld class]]) {
        return ((DJIHandheld*)[DJISDKManager product]).camera;
    }
    
    return nil;
}


- (DJIGimbal*) fetchGimbal {
    if (![DJISDKManager product]) {
        return nil;
    }
    
    if ([[DJISDKManager product] isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)[DJISDKManager product]).gimbal;
    }
    else if ([[DJISDKManager product] isKindOfClass:[DJIHandheld class]]) {
        return ((DJIHandheld*)[DJISDKManager product]).gimbal;
    }
    
    return nil;
}

//- (void)setupFlightController {
//    DJIFlightController *flightController = [self fetchFlightController];
//    if (flightController) {
//        flightController.delegate = self;
//        [flightController setDelegate:self];
//        [flightController setRollPitchControlMode:DJIVirtualStickRollPitchControlModeAngle];
//        [flightController setYawControlMode:DJIVirtualStickYawControlModeAngle];
//        [flightController setRollPitchCoordinateSystem:DJIVirtualStickFlightCoordinateSystemBody];
//
//        [flightController setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"Enable VirtualStickControlMode Failed");
//            }
//        }];
//    }
//}

#pragma mark Gimbal methods

-(void) rotateGimbalUp {
    DJIGimbal *gimbal = [self fetchGimbal];
    [gimbal resetWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"ResetGimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
    
    float rollAngle = 90;

    NSNumber *pitchRotation = @(0);
    NSNumber *rollRotation = @(rollAngle);
    NSNumber *yawRotation = @(0);
    
    DJIGimbalRotation *rotation = [DJIGimbalRotation gimbalRotationWithPitchValue:pitchRotation rollValue:rollRotation                                                        yawValue:yawRotation time:1 mode:DJIGimbalRotationModeAbsoluteAngle];
    
    [gimbal rotateWithRotation:rotation completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Rotate Gimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
}

-(void)rotateGimbalDown {
    DJIGimbal *gimbal = [self fetchGimbal];
    [gimbal resetWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"ResetGimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
    
    float rollAngle = -90;
    
    NSNumber *pitchRotation = @(0);
    NSNumber *rollRotation = @(rollAngle);
    NSNumber *yawRotation = @(0);
    
    DJIGimbalRotation *rotation = [DJIGimbalRotation gimbalRotationWithPitchValue:pitchRotation rollValue:rollRotation                                                        yawValue:yawRotation time:1 mode:DJIGimbalRotationModeAbsoluteAngle];
    
    [gimbal rotateWithRotation:rotation completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Rotate Gimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
}

#pragma mark TODO edit
-(void)rotateGimbalLeft {
//    gimbalRotationWithPitchValue:rollValue:yawValue:time:mode
    DJIGimbalRotation *gr = [DJIGimbalRotation gimbalRotationWithPitchValue:@(100) rollValue:0 yawValue:0 time:1 mode:DJIGimbalRotationModeRelativeAngle];
    DJIGimbal *g;
    [g rotateWithRotation:gr completion: nil];
}

-(void)rotateGimbalRight {
// rotate the gimbal clockwise
    float rollAngle = 0;

    NSNumber *pitchRotation = @(0);
    NSNumber *rollRotation = @(rollAngle);
    NSNumber *yawRotation = @(0);

    rollAngle += 45;
    if (rollAngle > 180.0) { //Filter the angle between -180 ~ 0, 0 ~ 180
        rollAngle = rollAngle - 360;
    }
    rollRotation = @(rollAngle);
    DJIGimbal *gimbal = [self fetchGimbal];
    DJIGimbalRotation *rotation = [DJIGimbalRotation gimbalRotationWithPitchValue:pitchRotation rollValue:rollRotation                                                        yawValue:yawRotation time:1 mode:DJIGimbalRotationModeAbsoluteAngle];
    [gimbal rotateWithRotation:rotation completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Rotate Gimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
    
    //    DJIGimbalRotation *gr = [DJIGimbalRotation gimbalRotationWithPitchValue:@(-100) rollValue:0 yawValue:0 time:1 mode:DJIGimbalRotationModeRelativeAngle];
    //    DJIGimbal *g;
    //    [g rotateWithRotation:gr completion: nil];
}


//- (void)rotateDrone:(NSTimer *)timer
-(void) rotateDroneLeft
{
//    NSDictionary *dict = [timer userInfo];
//    float yawAngle = [[dict objectForKey:@"YawAngle"] floatValue];
    float yawAngle = 45.0;
    
    DJIFlightController *flightController = [self fetchFlightController];
    
    DJIVirtualStickFlightControlData vsFlightCtrlData;
    vsFlightCtrlData.pitch = 0;
    vsFlightCtrlData.roll = 0;
    vsFlightCtrlData.verticalThrottle = 0;
    vsFlightCtrlData.yaw = yawAngle;
    
    flightController.isVirtualStickAdvancedModeEnabled = YES;
    
    [flightController sendVirtualStickFlightControlData:vsFlightCtrlData withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Send FlightControl Data Failed %@", error.description);
        }
    }];
}

-(void) rotateDroneRight
{
    float yawAngle = -45.0;
    
    DJIFlightController *flightController = [self fetchFlightController];
    
    DJIVirtualStickFlightControlData vsFlightCtrlData;
    vsFlightCtrlData.pitch = 0;
    vsFlightCtrlData.roll = 0;
    vsFlightCtrlData.verticalThrottle = 0;
    vsFlightCtrlData.yaw = yawAngle;
    
    flightController.isVirtualStickAdvancedModeEnabled = YES;
    
    [flightController sendVirtualStickFlightControlData:vsFlightCtrlData withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Send FlightControl Data Failed %@", error.description);
        }
    }];
}

#pragma mark - VirtualStick methods

-(void) enableVirtualStick {
    DJIFlightController *flightController = [self fetchFlightController];
    [flightController setYawControlMode:DJIVirtualStickYawControlModeAngle];
    [flightController setRollPitchCoordinateSystem:DJIVirtualStickFlightCoordinateSystemGround];
    [flightController setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Enable VirtualStickControlMode Failed");
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self executeVirtualStickControl];
        });
    }];
}

- (void) executeVirtualStickControl
{
    float mRoll = 0;
    float mPitch = 0;
    float mYaw = 0;
    float mThrottle = 0;
    
    DJIVirtualStickFlightControlData ctrlData = {0};
    ctrlData.pitch = mPitch;
    ctrlData.roll = mRoll;
    ctrlData.yaw = mYaw;
    ctrlData.verticalThrottle = mThrottle;
    
    DJIFlightController* fc = [self fetchFlightController];
    fc.isVirtualStickAdvancedModeEnabled = YES;
    
    if (fc && fc.isVirtualStickControlModeAvailable) {
        [fc sendVirtualStickFlightControlData:ctrlData withCompletion:^(NSError * _Nullable error) {
            NSLog(@"Send FlightControl Data Failed %@", error.description);
        }];
    }
}

-(void) disableVirtualStick {
    DJIFlightController *flightController = [self fetchFlightController];
    [flightController setVirtualStickModeEnabled:NO withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Disable VirtualStickControlMode Failed");
            DJIFlightController *flightController = [self fetchFlightController];
            [flightController setVirtualStickModeEnabled:NO withCompletion:nil];
        }
    }];
}

#pragma mark - DJIFlightControllerDelegate Methods

-(void) flightController:(DJIFlightController *_Nonnull)fc didUpdateState:(DJIFlightControllerState *_Nonnull)state {
    
    self.aircraftLocation = CLLocationCoordinate2DMake(state.aircraftLocation.coordinate.latitude, state.aircraftLocation.coordinate.longitude);
    self.gpsSignalLevel = state.GPSSignalLevel;
    self.aircraftAltitude = state.altitude;
    self.aircraftYaw = state.attitude.yaw;
    
    DJIAttitude attitude = [state attitude];
    double altitude = [state altitude];
    float velocityX = [state velocityX], velocityY = [state velocityY], velocityZ = [state velocityZ];
    
    [self setFCD:@[@(attitude.roll), @(attitude.pitch), @(attitude.yaw), @(altitude)]];
    [self setVelocity:@[@(velocityX), @(velocityY), @(velocityZ)]];
    
    NSArray *fcd = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:state.attitude.roll],
                    [NSNumber numberWithFloat:state.attitude.pitch],
                    [NSNumber numberWithFloat:state.attitude.yaw],
                    [NSNumber numberWithFloat:state.altitude],
                    nil];
    NSArray *vel = [[NSArray alloc] initWithObjects:
                    [NSNumber numberWithFloat:state.velocityX],
                    [NSNumber numberWithFloat:state.velocityY],
                    [NSNumber numberWithFloat:state.velocityZ], nil];
    
    if(vc != NULL) {
//        [vc test];
        [vc displayData:fcd:vel];
    }
}


#pragma mark - DJISDKManagerDelegate Methods

- (void)appRegisteredWithError:(NSError *)error {
    
    NSString* message = @"Register App Successfully!";
    if (error) {
        message = @"Register App Failed! Please enter your App Key and check the network.";
    }else{
        NSLog(@"registerAppSuccess");
        
        [DJISDKManager startConnectionToProduct];
//        [[DJISDKManager videoFeeder].primaryVideoFeed addListener:self withQueue:nil];
//        [[VideoPreviewer instance] start];
    }
    [vc showAlertViewWithMessage:message];
//    [self showAlertViewWithTitle:@"Register App" withMessage:message];
    
}

- (void)productConnected:(DJIBaseProduct *)product
{
    if (product) {
        if(vc != NULL) {
            [vc test];
        }
//        DJICamera* camera = [self fetchCamera];
//        if (camera != nil) {
//            camera.delegate = self;
//            [camera.playbackManager setDelegate:self];
//        }
        DJIFlightController *flightController = [self fetchFlightController];
        if (flightController) {
            flightController.delegate = self;
            [flightController setDelegate:self];
            [flightController setRollPitchControlMode:DJIVirtualStickRollPitchControlModeAngle];
            [flightController setYawControlMode:DJIVirtualStickYawControlModeAngle];
            [flightController setRollPitchCoordinateSystem:DJIVirtualStickFlightCoordinateSystemBody];
            
            [flightController setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Enable VirtualStickControlMode Failed");
                }
            }];
        }
    }
}

@end

// [_elements addObject:element] = _elements.addObject(element)

//- (IBAction)onSendButtonClickedid)sender {
//    self.aircraft.flightController.yawControlMode = DJIVirtualStickYawControlModeAngle;
//    self.aircraft.flightController.rollPitchControlMode = DJIVirtualStickRollPitchControlModeAngle;
//    self.aircraft.flightController.verticalControlMode=DJIVirtualStickVerticalControlModePosition;
//    mPitch=[self.txPitch.text floatValue];
//    mYaw=[self.txYaw.text floatValue];
//    mRoll=[self.txRoll.text floatValue];
//    mThrottle=[self.txThrot.text floatValue];
//    [self updateJoystick];
//}

//-(void) updateJoystick
//{
//    DJIVirtualStickFlightControlData ctrlData = {0};
//    ctrlData.pitch = mPitch;
//    ctrlData.roll = mRoll;
//    ctrlData.yaw = mYaw;
//    ctrlData.verticalThrottle = mThrottle;
//    if (self.aircraft.flightController.isVirtualStickControlModeAvailable) {
//        NSLog(@"mThrottle: %f, mYaw: %f", mThrottle, mYaw);
//        [self.aircraft.flightController sendVirtualStickFlightControlData:ctrlData withCompletion:^(NSError * _Nullable error) {
//            NSLog(@"error:%@",error);
//        }];
//    }
//}

