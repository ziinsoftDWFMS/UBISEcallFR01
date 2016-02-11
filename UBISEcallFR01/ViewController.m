
#import "ViewController.h"
#import "CAllServer.h"
#import "IdentViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <CoreLocation/CoreLocation.h>
#import "GlobalData.h"
#import "GlobalDataManager.h"
#import "Commonutil.h"
#import "AppDelegate.h"
#import "ToastAlertView.h"


@interface ViewController ()

@end

@implementation ViewController{
    NSArray *_uuidList;
    //NSArray *_stateCategory;
}


NSString *beaconYN = @"Y";
NSString *bluetoothYN = @"N";
NSString *senderinfo = @"";
NSString *titleinfo = @"";
NSString *emcCode = @"";
NSString *beaconKey = @"";
NSString *action = @"1";
NSString *viewType = @"EMC";
NSMutableArray *beaconDistanceList;//Using the Beacon Value set set set~~~
NSMutableArray *beaconList;
NSMutableArray *beaconBatteryLevelList;
int seqBeacon = 0;
int beaconSkeepCount = 0;
int beaconSkeepMaxCount = 3;

CLBeaconRegion *beaconRegion;





BOOL navigateYN;
NSString* idForVendor;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //network check
    
    NSLog(@"Connection ststus : %@", [self connectedToNetwork] ? @"YES" : @"NO");
    
    //나중에 적용하자..Message Box
    //---------------------------------------------------------
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.main = self;
    
    
    
    //_locationTxt.delegate = self;
    [self.webView setDelegate:self];
    
    
    
    UIDevice *device = [UIDevice currentDevice];
    idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    
    [param setValue:@"S" forKey:@"gubun"];
    [param setValue:[GlobalData getEmcCode] forKey:@"code"];
    
    [param setObject:idForVendor forKey:@"deviceId"];
    
    //deviceId
    
    //R 수신
    
    NSString* str = [res stringWithUrl:@"getEmcUserInfo.do" VAL:param];
    
    NSLog(@" ,login?? %@",str);
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSLog(str);
    
    
    
    emcCode = [GlobalData getEmcCode];
    if ([emcCode isEqual : @"FR01"]) {
        action = @"1";
    } else if ([emcCode isEqual : @"WT01"]) {
        action = @"2";
    } else if ([emcCode isEqual : @"KW01"]) {
        action = @"3";
    } else if ([emcCode isEqual : @"HA01"]) {
        action = @"4";
    } else if ([emcCode isEqual : @"GS01"]) {
        action = @"5";
    } else if ([emcCode isEqual : @"EV01"]) {
        action = @"6";
    } else if ([emcCode isEqual : @"EM01"]) {
        action = @"7";
    }
    NSString *urlParam=@"";
    NSString *server = [GlobalData getServerIp];
    NSString *pageUrl = [NSString stringWithFormat:@"/emcSendDetail.do?action=%@", action];
    NSString *callUrl = @"";

    
    if([str  isEqual: @"{}"]){
        
        
        
        // [tempViewCon.view setBackgroundColor:[UIColor whiteColor]];
        
        
        
        // [[self navigationController] pushViewController:tempViewCon animated: YES];
        
        
        
        NSLog(@">>31231>>>1234%@",idForVendor);
        
        
        
        // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"  bundle:[NSBundle mainBundle]];
        
        
        
        //IdentViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
        
        // [self presentModalViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"IdentView"] animated:YES];
        
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //UIViewController *identViewController = [storyboard instantiateViewControllerWithIdentifier:@"IdentViewController"];
        
        //self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
        //[self presentViewController:identViewController animated:NO completion:nil];
        
        //  identViewController.view.alpha = 0;
        //  [UIView animateWithDuration:0.5 animations:^{
        //      identViewController.view.alpha = 1;
        //  } completion:^(BOOL finished) {
        //         }];
        navigateYN = YES;
        
    }else{
        
        
        [GlobalDataManager initgData:(jsonInfo)];
        
        
        beaconYN = [jsonInfo valueForKey:@"BEACON_YN"];
        
        callUrl = [NSString stringWithFormat:@"%@%@",server,pageUrl];
        
        _uuidList = @[
                      [[NSUUID alloc] initWithUUIDString:[jsonInfo valueForKey:@"BEACON_UUID"]]];
        
        [_uuidList enumerateObjectsUsingBlock:^(NSUUID *uuid, NSUInteger idx, BOOL *stop) {
            NSString *identifier = @"us.iBeaconModules";
            
            [self registerBeaconRegionWithUUID:uuid andIdentifier:identifier];
        }];
        //Beacon set-------------------------------------------------------------------

        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedAlways:
                NSLog(@"Authorized Always");
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                NSLog(@"Authorized when in use");
                break;
            case kCLAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            case kCLAuthorizationStatusNotDetermined:
                NSLog(@"Not determined");
                break;
            case kCLAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
                
            default:
                break;
        }
        self.locationManager = [[CLLocationManager alloc] init];
        if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        }
        self.locationManager.distanceFilter = YES;
        
        self.locationManager.delegate = self;
        self.locationManager.pausesLocationUpdatesAutomatically = YES;//pause상태에서의 스캔여부
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        [self.locationManager startUpdatingLocation];

        //------------------------------------------------------------------------------
        
        

        
        
        
        NSLog(@">>4566>>>1234%@",idForVendor);
        navigateYN = NO;
        
        NSLog(@"??callurl:%@",callUrl);
        
        NSURL *url=[NSURL URLWithString:callUrl];
        NSMutableURLRequest *requestURL=[[NSMutableURLRequest alloc]initWithURL:url];
        [requestURL setHTTPMethod:@"POST"];
        [requestURL setHTTPBody:[urlParam dataUsingEncoding:NSUTF8StringEncoding]];
        [self.webView loadRequest:requestURL];
        NSLog(@"??????? urlParam %@",urlParam);

    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated {
    
    if (navigateYN) {
        navigateYN = NO;
        [self performSegueWithIdentifier:@"showIdentiview" sender:self];
    }
}








- (BOOL) connectedToNetwork {
    // 0.0.0.0 주소를 만든다.
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Reachability 플래그를 설정한다.
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        
        NSLog(@" Error. Could not recover network reachability flags");
        return 0;
    }
    
    // 플래그를 이용하여 각각의 네트워크 커넥션의 상태를 체크한다.
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
    
    return ((isReachable && !needsConnection) || nonWiFi) ? YES : NO;
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Clicked");
    // OK 버튼을 눌렀을 때 버튼Index가 1로 들어감
    
    if (buttonIndex == 1) {
        NSLog(@"Clicked YES");
        exit(0);
        
    }
}


- (void) beaconSet {
    
    if (beaconSkeepCount < beaconSkeepMaxCount) {
        
        beaconSkeepCount = beaconSkeepCount + 1;
        NSLog(@"Beacon Access Skeep ~~~~~~~~~~~~~~~~~~~~ [%d]", beaconSkeepCount);
        return;
    }
    beaconSkeepCount = 0;
    
    NSLog(@"beacon set ~!~~~~~~~~~");
    beaconDistanceList = [NSMutableArray array];
    beaconList = [NSMutableArray array];
    beaconBatteryLevelList = [NSMutableArray array];
    
    for (int i = 0 ; i < self.beacons.count ; i++) {
        CLBeacon *beacon = (CLBeacon*)[self.beacons  objectAtIndex:i];
        //CLBeacon *beacon = self.beacons.firstObject;
        NSString *proximityLabel = @"";
        
        switch (beacon.proximity) {
            case CLProximityFar:
                proximityLabel = @"Far";
                break;
            case CLProximityNear:
                proximityLabel = @"Near";
                break;
            case CLProximityImmediate:
                proximityLabel = @"Immediate";
                break;
            case CLProximityUnknown:
                proximityLabel = @"Unknown";
                break;
        }
        
        //NSLog(@"proximityLabel[%lu] : %@", (unsigned long)i, proximityLabel);
        
        //NSString *detailLabel = [NSString stringWithFormat:@"Major: %d, Minor: %d, RSSI: %d, UUID: %@, ACC: %2fm",
        //                         beacon.major.intValue, beacon.minor.intValue, (int)beacon.rssi, beacon.proximityUUID.UUIDString, beacon.accuracy];
        
        NSString *detailLabel = [NSString stringWithFormat:@"Major: %d, Minor: %d, RSSI: %d, ACC: %2fm",
                                 beacon.major.intValue, beacon.minor.intValue, (int)beacon.rssi, beacon.accuracy];
        
        //NSLog(@"beacon detail contents[%lu] : %@", (unsigned long)i, detailLabel);
        
        [beaconDistanceList insertObject:[NSString stringWithFormat:@"%2fm", beacon.accuracy] atIndex:i];
        [beaconList insertObject:[NSString stringWithFormat:@"%@%d%d", beacon.proximityUUID.UUIDString, beacon.major.intValue, beacon.minor.intValue] atIndex:i];
        
        
        
        
    }  
    if ([@"EMC" isEqual:viewType]) {
        [self getNearBeaconLocation];
    }

        //초기화
        beaconDistanceList = [NSMutableArray array];
        beaconList = [NSMutableArray array];
        beaconBatteryLevelList = [NSMutableArray array];

    self.beacons = nil;
    //NSLog(@"Beacon count [%lu]", (unsigned long)self.beacons.count);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //javascript => document.location = "somelink://yourApp/form_Submitted:param1:param2:param3";
    //scheme : somelink
    //absoluteString : somelink://yourApp/form_Submitted:param1:param2:param3
    
    NSString *requesturl1 = [[request URL] scheme];
    if([@"toapp" isEqual:requesturl1])
    {
        NSString *requesturl2 = [[request URL] absoluteString];
        NSString *decoded = [requesturl2 stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSArray* list = [decoded componentsSeparatedByString:@":"];
        NSString *type  = [list objectAtIndex:1];
        NSLog(@"?? %@",type);
        
        //Webview : web call case
        
        if([@"callImge" isEqual:type]){
            [self callImge:[decoded substringFromIndex:([type length]+7)]];
        }else if([@"setJobMode" isEqual:type]) {
            NSLog(@"############### ~~~ %@", [decoded substringFromIndex:([type length]+7)]);
            viewType = @"EMC";
        
        } else if ([@"getPageInfo" isEqual:type]) {
            NSString *scriptString = [NSString stringWithFormat:@"%@;", [decoded substringFromIndex:([type length]+7)]];
            NSLog(@"getPageInfo : call Script value : %@", scriptString);
        
            [self senderInfoText:[decoded substringFromIndex:([type length]+7)]];
        
            NSString *returnString = [NSString stringWithFormat:@"setSenderInfo('%@','%@');",titleinfo,senderinfo];
            NSLog(@"scriptString => %@", returnString);
            [webView stringByEvaluatingJavaScriptFromString:returnString];
        
            NSString *arg = [decoded substringFromIndex:([type length]+7)];
            if ([@"7" isEqual:arg]) {
                returnString = [NSString stringWithFormat:@"setLocationTitle('내용 : ');"];
            } else {
                returnString = [NSString stringWithFormat:@"setLocationTitle('장소 : ');"];
            }
            [webView stringByEvaluatingJavaScriptFromString:returnString];
        } else if ([@"sendEmc" isEqual:type]) {
            [self sendEmc:[decoded substringFromIndex:([type length]+7)]];
        } else if([@"sendCancel" isEqual:type]) {
            exit(0);
        }
            
    }


    return YES;
}
-(void) senderInfoText:(NSString*) arg{
    if ([@"1" isEqual:arg]) {
        senderinfo = @"[화재]";
        EmcCode = @"FR01";
    } else if ([@"2" isEqual:arg]) {
        senderinfo = @"[누수/동파]";
        EmcCode = @"WT01";
    } else if ([@"3" isEqual:arg]) {
        senderinfo = @"[정전/누전]";
        EmcCode = @"KW01";
    } else if ([@"4" isEqual:arg]) {
        senderinfo = @"[안전사고]";
        EmcCode = @"HA01";
    } else if ([@"5" isEqual:arg]) {
        senderinfo = @"[가스]";
        EmcCode = @"GS01";
    } else if ([@"6" isEqual:arg]) {
        senderinfo = @"[승강기고장]";
        EmcCode = @"EV01";
    } else if ([@"7" isEqual:arg]) {
        senderinfo = @"[긴급공지]";
        EmcCode = @"EM01";
    }
    titleinfo = [NSString stringWithFormat:@"%@%@", senderinfo, @"발신"];
    senderinfo = [NSString stringWithFormat:@"%@%@", senderinfo, [[GlobalDataManager getgData] empNo]];
    NSLog(@"~~~~~~~~~~~~~~~ titleinfo : %@", titleinfo);
    NSLog(@"~~~~~~~~~~~~~~~ senderinfo : %@", senderinfo);
}

//script => app funtion
-(void) sendEmc:(NSString*) data{
    NSLog(@"????? sendEmc data: %@",data);
    NSArray *locationImages = [data componentsSeparatedByString:@"//"];
    NSString *argLocation = [locationImages objectAtIndex:0];
    NSString *argImages = [locationImages objectAtIndex:1];
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    [param setValue:argLocation forKey:@"location"];
    [param setValue:argImages forKey:@"save_IMGS"];
    [param setValue:EmcCode forKey:@"code"];
    [param setValue:@"S" forKey:@"gubun"];
    [param setObject:idForVendor forKey:@"deviceId"];
    
    
    
    //deviceId
    
    //R 수신
    CAllServer *res = [CAllServer alloc];
    NSString* str = [res stringWithUrl:@"emcInfoPush.do" VAL:param];
    
    NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSLog(@"?? %@",str);
    
    if(     [@"SUCCESS"isEqual:[jsonInfo valueForKey:@"RESULT"] ] )
    {
        //전송완료 되었음.....
        [ToastAlertView showToastInParentView:self.view withText:@"전송이 완료되었습니다." withDuaration:3.0];
        
            NSString* callActionGuide = @"";
        
            if (![@"EM01" isEqual:emcCode]) {
                NSMutableDictionary *sessiondata =[GlobalDataManager getAllData];
                
                callActionGuide = [NSString stringWithFormat:@"%@/emcActionGuide.do?COMP_CD=%@&CODE=%@&BEACON_KEY=%@", [GlobalData getServerIp], [sessiondata valueForKey:@"session_COMP_CD"], [GlobalData getEmcCode], beaconKey];
            } else {
                callActionGuide = [NSString stringWithFormat:@"%@/#home", [GlobalData getServerIp]];
                
            }
        
        NSString *urlParam=@"";
        NSURL *url=[NSURL URLWithString:callActionGuide];
        NSMutableURLRequest *requestURL=[[NSMutableURLRequest alloc]initWithURL:url];
        [requestURL setHTTPMethod:@"POST"];
        [requestURL setHTTPBody:[urlParam dataUsingEncoding:NSUTF8StringEncoding]];
        [self.webView loadRequest:requestURL];
        
        NSLog(@"??????? urlParam %@",callActionGuide);
        
    }
}

-(void) callImge:(NSString*) data{
    NSLog(@"callimge??");
    NSArray* list = [data componentsSeparatedByString:@"&"];
    
    
    NSMutableDictionary * temp =[[NSMutableDictionary alloc] init];
    
    for(int i =0;i<[list count];i++){
        NSArray* listTemp =   [[list objectAtIndex:i] componentsSeparatedByString:@"="];
        [temp setValue:[listTemp objectAtIndex:1] forKey:[listTemp objectAtIndex:0]];
        
        NSLog(@" key %@  value %@ ",[listTemp objectAtIndex:0],[listTemp objectAtIndex:1]);
    }
    [[GlobalDataManager getgData]setCameraData:temp];
    
    [self performSegueWithIdentifier:@"CameraCall" sender:self];
}



- (void) setimage:(NSString*) path num:(NSString*)num{
    //       NSString * searchWord = @"/";
    //    NSString * replaceWord = @"\\\\";
    //    path =  [path stringByReplacingOccurrencesOfString:searchWord withString:replaceWord];
    NSLog(@"ddd path %@ num %@",path,num);
    
    NSString *scriptString = [NSString stringWithFormat:@"setimge('%@','%@');",path,num];
    NSLog(@"scriptString => %@", scriptString);
    [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
}



- (void)registerBeaconRegionWithUUID:(NSUUID *)proximityUUID andIdentifier:(NSString*)identifier {
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID identifier:identifier];
    
    //_rangedRegions[_Region] = [NSArray array];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"You entered the region.");
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"You exited the region.");
}

- (void)locationManager:(CLLocationManager *)manager rangingDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"rangingDidFailForRegion: %@ error: %@", region.identifier, [error localizedDescription]);
    
}
-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSString *message = @"";
    
    self.beacons = beacons;
    [self beaconSet];
    
    
    
    if(beacons.count > 0) {
        
        message = @"~~~~~~Yes beacons are nearby";
    } else {
        message = @"~~~~~~No beacons are nearby";
    }
    
    NSLog(@"%@", message);
}




- (void) getNearBeaconLocation {
    NSLog(@"!!!!! getNearBeaconLocation Exec~~~");
    NSString *nearBeacon = [self getNearBeacon];
    
    if (![@"" isEqual:nearBeacon]) {
        beaconKey = [NSString stringWithFormat:@"%@", nearBeacon];;
        
        NSMutableDictionary *sessiondata =[GlobalDataManager getAllData];
        
        NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
        
        [param setValue:nearBeacon forKey:@"BEACON_KEY"];
        [param setValue:[sessiondata valueForKey:@"session_COMP_CD"] forKey:@"COMP_CD"];
        //R 수신
        CAllServer *res = [CAllServer alloc];
        NSString* str = [res stringWithUrl:@"getLocationName.do" VAL:param];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *jsonInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        NSLog(@"?? %@",str);
        
        if (![@"EM01" isEqual:EmcCode]) {
            
            NSString *locationName = [NSString stringWithFormat:@"%@",[jsonInfo valueForKey:@"LOCATION_NAME"]];
            if(![@""isEqual:locationName ])
            {
                NSString *scriptString = [NSString stringWithFormat:@"setLocationName('%@');",locationName];
                NSLog(@"scriptString => %@", scriptString);
                [self.webView stringByEvaluatingJavaScriptFromString:scriptString];
            }
        }
    } else {
        return;
    }
    
    
    
}

- (NSString *) getNearBeacon {
    int nearBeaconSeq = 0;
    NSString *nearBeaconValue = @"";
    if(beaconDistanceList.count > 0) {
        for (int i = 1 ; i < beaconDistanceList.count ; i++) {
            if ([beaconDistanceList objectAtIndex:nearBeaconSeq] > [beaconDistanceList objectAtIndex:i]) {
                nearBeaconSeq = i;
            }
        }
        nearBeaconValue = [beaconList objectAtIndex:nearBeaconSeq];
    }
    //초기화
    beaconDistanceList = [NSMutableArray array];
    beaconList = [NSMutableArray array];
    beaconBatteryLevelList = [NSMutableArray array];
    return nearBeaconValue;
}
//Error시 실행
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"IDI FAIL");
}

//WebView 시작시 실행
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"START LOAD");
    
    
}

//WebView 종료 시행
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"FNISH LOAD");
}

static BOOL diagStat = NO;
static NSInteger bIdx = -1;
- (BOOL)webView:(UIWebView *)sender runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(id)frame {
    UIAlertView *confirmDiag = [[UIAlertView alloc] initWithTitle:nil
                                                          message:message
                                                         delegate:self
                                                cancelButtonTitle:@"취소"
                                                otherButtonTitles:@"확인", nil];
    
    [confirmDiag show];
    bIdx = -1;
    
    while (bIdx==-1) {
        //[NSThread sleepForTimeInterval:0.2];
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1f]];
    }
    if (bIdx == 0){
        diagStat = NO;
    }
    else if (bIdx == 1) {
        diagStat = YES;
    }
    return diagStat;
}





@end
