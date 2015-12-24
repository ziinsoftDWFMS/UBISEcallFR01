//
//  ViewController.h
//  UbisEcallEV01
//
//  Created by youngseok Kim on 2015. 5. 10..
//  Copyright (c) 2015년 dwni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<CBCentralManagerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;




//@property (weak, nonatomic) IBOutlet UITextField *locationTxt;
@property (strong) NSArray *beacons;
@property (nonatomic, strong) CBCentralManager* blueToothManager;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property CLProximity lastProximity;

- (void) beaconSet;
//- (IBAction)click:(id)sender;
- (void)retunData:(NSDictionary*)data;
- (void) setimage:(NSString*) path num:(NSString*)num;

@end


@interface UIWebView(JavaScriptAlert)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame;
@end