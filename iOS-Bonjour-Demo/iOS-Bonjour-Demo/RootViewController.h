//
//  RootViewController.h
//  iOS-Bonjour-Demo
//
//  Created by Jakey on 2018/11/16.
//  Copyright © 2018 Jakey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RootViewController : UIViewController

- (IBAction)bonjourServerCreateTouched:(id)sender;
- (IBAction)bonjourServerStartTouched:(id)sender;
- (IBAction)bonjourServerStopTouched:(id)sender;


- (IBAction)bonjourClientCreateTouched:(id)sender;
- (IBAction)bonjourClientStartBrowserTouched:(id)sender;
- (IBAction)bonjourClientStopBrowerTouched:(id)sender;
@end

NS_ASSUME_NONNULL_END
