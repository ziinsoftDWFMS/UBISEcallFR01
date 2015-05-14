
#import "ViewController.h"
#import "CAllServer.h"
#import "IdentViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

@interface ViewController ()

@end

@implementation ViewController


BOOL navigateYN;
NSString* idForVendor;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //network check
    
    NSLog(@"Connection ststus : %@", [self connectedToNetwork] ? @"YES" : @"NO");
    
    //나중에 적용하자..Message Box
    //---------------------------------------------------------
    
    
    
    
    
    _locationTxt.delegate = self;
    UIDevice *device = [UIDevice currentDevice];
    idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    
    [param setValue:@"S" forKey:@"gubun"];
    [param setValue:@"FR01" forKey:@"code"];
    
    [param setObject:idForVendor forKey:@"deviceId"];
    
    //deviceId
    
    //R 수신
    
    NSString* str = [res stringWithUrl:@"getEmcUserInfo.do" VAL:param];
    
    //regEmcAppInstInfo.do
    
    //
    
    
    
    NSLog(@" ,login?? %@",str);
    
    
    
    
    
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
        
        
        
        
        
        NSLog(@">>4566>>>1234%@",idForVendor);
        navigateYN = NO;
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


- (IBAction)click:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    CAllServer* res = [CAllServer alloc];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:@"FR01" forKey:@"code"];
    [param setValue:@"S" forKey:@"gubun"];
    [param setObject:idForVendor forKey:@"deviceId"];
    [param setValue:self.locationTxt.text forKey:@"location"];
    
    self.locationTxt.text = @"";
    
    
    NSString* str = [res stringWithUrl:@"emcInfoPush.do" VAL:param];
    
    NSLog(@" %@",str);
    //[res test:@"callTest.do"];
}


- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)text{
    NSLog(@" %@",self.locationTxt.text);
    const char * _char = [text cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if(isBackSpace == -8){//백스페이스
        //is backspace
        return YES;
    }
    
    if([[self.locationTxt text] length] >= 6){//글자수 제한
        //  return NO;
    }
    
    return YES;
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

@end
