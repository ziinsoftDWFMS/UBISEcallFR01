//
//  AppDelegate.h
//  DWFMS
//
//  Created by 김향기 on 2015. 5. 15..
//  Copyright (c) 2015년 DWFMS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ViewController.h"
#import "CameraViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    NSString *DEVICE_TOK;
    NSString *GRP_CD;
    NSString *EMC_ID;
    NSString *EMC_MSG;
    NSString *CODE;
    SystemSoundID ssid;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *DEVICE_TOK;
@property (strong, nonatomic) NSString *GRP_CD;
@property (strong, nonatomic) NSString *EMC_ID;
@property (strong, nonatomic) NSString *EMC_MSG;
@property (strong, nonatomic) NSString *CODE;
@property (weak, nonatomic) ViewController * main;
@property (weak, nonatomic) CameraViewController * camera;



@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLProximity lastProximity;


@end

