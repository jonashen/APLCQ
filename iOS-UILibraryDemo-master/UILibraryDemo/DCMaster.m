//
//  DCMaster.m
//  UILibraryDemo
//
//  Created by Christine Chen on 2/21/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "DCMaster.h"
#import <DJISDK/DJIFlightController.h>

@implementation DCMaster {
    BOOL userControl;
    DJIBaseProduct* product;
    DJIFlightController* flightController;
    DJIGimbal* gimbal;
    NSString* state;
}

-(id) init {
    self = [super init];
    userControl = true;
    product = [DJISDKManager product];
    flightController = [self fetchFlightController];
    if(flightController) {
        [flightController setDelegate:self];
    } else {
        NSLog(@"Can't find flight controller");
    }
    gimbal = [self fetchGimbal];
    state = @"FF";
    return self;
}


- (DJIFlightController*) fetchFlightController {
    if (![DJISDKManager product]) {
        return nil;
    }
    if ([[DJISDKManager product] isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)[DJISDKManager product]).flightController;
    }
    return nil;
}

- (DJIGimbal*) fetchGimbal {
    if (![DJISDKManager product]) {
        return nil;
    }
    return [DJISDKManager product].gimbal;
}

-(void)flightController:(DJIFlightController *_Nonnull)fc didUpdateState:(DJIFlightControllerState *_Nonnull)state {
    
}

-(BOOL) stateChange: (NSString*)newState{
    if([newState isEqualToString:@"FF"]) {
        [self enableUserControl];
    } else if([newState isEqualToString:@"TD"]) {
        
    } else if([newState isEqualToString:@"TS"]) {
        
    } else if([newState isEqualToString:@"DR"]) {
        [self positionCameraDown];
    } else if([newState isEqualToString:@"DRC"]) {
        [self hover];
    } else if([newState isEqualToString:@"Landing"]) {
        [self land];
    } else if([newState isEqualToString:@"Landed"]) {
        [self enableUserControl];
    } else {
        return false;
    }
    state = newState;
    return true;
}

-(void) positionCameraDown {
    // radians or degrees?
    DJIGimbalRotation *rotationAbsolute = [DJIGimbalRotation gimbalRotationWithPitchValue:@(90)
                                                                                rollValue:nil
                                                                                 yawValue:nil 
                                                                                     time:10
                                                                                     mode:DJIGimbalRotationModeAbsoluteAngle];
    DJIGimbalRotation *rotationSpeed = [DJIGimbalRotation gimbalRotationWithPitchValue:nil
                                                                             rollValue:nil
                                                                              yawValue:nil
                                                                                  time:5
                                                                                  mode:DJIGimbalRotationModeSpeed];
    [gimbal rotateWithRotation:rotationSpeed completion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Rotate Gimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
}

-(void) raiseCameraForLanding {
    [gimbal resetWithCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Reset Gimbal Failed: %@", [NSString stringWithFormat:@"%@", error.description]);
        }
    }];
}

-(void) hover {
    // is this needed or just default action for when there's no commands from the virtual stick?
}

-(void) land {
    
}

-(void) updateSensorData {
    // should be called periodically in a thread to update shared data structure
    //(void)flightController:(DJIFlightController *_Nonnull)fc didUpdateIMUState:(DJIIMUState *_Nonnull)imuState
    
//    DJIFlightControllerState.altitude
//    DJIFLightControllerState.attitude
//    DJIFlightControllerState.location
//    DJIFlightControllerState.velocityX
//    DJIFlightControllerState.velocityY
//    DJIFlightControllerState.velocityZ
//    DJIImuState.accelerometerState
    // wind warning?
}

-(void) disableUserControl {
    userControl = false;
    [flightController setVirtualStickModeEnabled:YES withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Enable VirtualStickControlMode Failed");
        }
    }];
}

-(void) enableUserControl {
    userControl = true;
    // enable control, hover in place if flying
    // check altitude
        // if greater than 0, initiate hover
//    if (flightController.altitude)
    [flightController setVirtualStickModeEnabled:NO withCompletion:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Disable VirtualStickControlMode Failed");
        }
    }];
    
}

@end


