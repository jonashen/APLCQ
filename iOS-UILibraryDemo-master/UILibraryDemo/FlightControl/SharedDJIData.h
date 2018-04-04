//
//  SharedData.h
//  UILibraryDemo
//
//  Created by Jonathon Shen on 1/31/18.
//  Copyright © 2018 DJI. All rights reserved.
//

#import "DefaultLayoutViewController.h"
#import <Foundation/Foundation.h>
#import <DJISDK/DJISDK.h>
#import <DJISDK/DJIGimbal.h>
#import <DJISDK/DJIIMUState.h>
#import <DJISDK/DJISDKManager.h>
#import <DJISDK/DJIGimbalBaseTypes.h>
#import <DJISDK/DJIFlightControllerState.h>
// Declaring the new class "SharedDJIData" with PRIVATE variables
@interface SharedDJIData:NSObject<DJISDKManagerDelegate, DJIFlightControllerDelegate> {
    /* Lock to prevent race conditions */
    NSLock *_lock;
    
    /* (Virtual Stick) Flight control data */
    float roll, pitch, yaw, throttle;
    float velocityX, velocityY, velocityZ;
    double altitude;
    
    @public DefaultLayoutViewController *vc;
    
    /* Calibration data */
    
}

/*
 Property = must have setter and getter functions for the variable
 assign:
    Assign new value to your property at any time.
 nonatomic:
    Thread access faster, but can't simultaneously access and change property's value
 readonly:
    Can't directly assign property new values.
 copy:
    Value assigned to property can be copied and used for other purposes.
 readwrite:
    Read and change value of property.
 strong:
    Direct control over property.
 weak:
    Can still nullify property, but so can compiler.
 */
@property(assign) float roll, pitch, yaw, throttle;
@property (atomic) CLLocationCoordinate2D aircraftLocation;
@property (atomic) double aircraftAltitude;
@property (atomic) DJIGPSSignalLevel gpsSignalLevel;
@property (atomic) double aircraftYaw;

/*
 Methods
 - = instance methods, can ONLY be called by instance of class
 + = class methods
*/
-(NSArray *_Nonnull) getFCD;
-(NSArray *_Nonnull) getVelocity;
-(void) setFCD:(NSArray *_Nonnull)array;
-(void) setVelocity:(NSArray *_Nonnull)array;
-(void) updateFCD;
-(void) printFCD;
-(bool) areIMUsCalibrated;
-(void) rotateGimbalDown;
-(void) rotateGimbalUp;
-(void) rotateDroneLeft;
-(void) rotateDroneRight;
// DJIFlightControllerDelegate
-(void) flightController:(DJIFlightController *_Nonnull)fc didUpdateState:(DJIFlightControllerState *_Nonnull)state;
// DJISDKManagerDelegate
-(void) appRegisteredWithError:(NSError *_Nullable)error;
-(void) productConnected:(DJIBaseProduct *_Nullable)product;



// Must end interface with this
@end

void sharedDJIData();

