
#import "ViewController.h"
#import "CAllServer.h"
#import "IdentViewController.h"
@interface ViewController ()

@end

@implementation ViewController


BOOL navigateYN;
NSString* idForVendor;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIDevice *device = [UIDevice currentDevice];
    idForVendor = [device.identifierForVendor UUIDString];
    
    NSLog(@">>>>>%@",idForVendor);
    //서버에서 결과 리턴받기
    CAllServer* res = [CAllServer alloc];
    
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    
    //[param setValue:@"" forKey:@"hp"];
    
    [param setValue:@"S" forKey:@"gubun"];
    [param setObject:@"FR01" forKey:@"code"];
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
        [self performSegueWithIdentifier:@"showIdentiview" sender:self];
    }
}


- (IBAction)click:(id)sender {
    UIDevice *device = [UIDevice currentDevice];
    NSString* idForVendor = [device.identifierForVendor UUIDString];
    
    CAllServer* res = [CAllServer alloc];
    NSMutableDictionary* param = [[NSMutableDictionary alloc] init];
    [param setObject:@"FR01" forKey:@"code"];
    [param setObject:idForVendor forKey:@"deviceId"];
    [param setValue:self.locationTxt.text forKey:@"location"];
    
    NSString* str = [res stringWithUrl:@"emcInfoPush.do" VAL:param];
    
    NSLog(@" %@",str);
    //[res test:@"callTest.do"];
}



- (BOOL)locationTxt:(UITextField *)locationTxt shouldChangeCharactersInRange:
(NSRange)range replacementString:(NSString *)string
{
    //제한 할 글자 수
    int maxLength = 5;
    
    //string은 현재 키보드에서 입력한 문자 한개를 의미한다.
    if(string && [string length] && ([locationTxt.text length] >= maxLength))   return NO;
    
    return TRUE;
}


@end
