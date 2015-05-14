//
//  ViewController.h
//  UbisEcallEV01
//
//  Created by youngseok Kim on 2015. 5. 10..
//  Copyright (c) 2015년 dwni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *locationTxt;

- (IBAction)click:(id)sender;
- (void)retunData:(NSDictionary*)data;

@end
