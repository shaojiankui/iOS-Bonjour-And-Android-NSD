//
//  RootViewController.m
//  iOS-Bonjour-Demo
//
//  Created by Jakey on 2018/11/16.
//  Copyright © 2018 Jakey. All rights reserved.
//

#import "RootViewController.h"
#import "SFBonjourServer.h"
#import "SFBonjourClient.h"

@interface RootViewController ()
{
    SFBonjourServer *_server;
    SFBonjourClient *_client;

}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self class] requestNetPermission];
    // Do any additional setup after loading the view from its nib.
}
+(void)requestNetPermission{
    
    // 1. 创建请求对象（可变）
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://dev.skyfox.org"]];
    // 2. 设置请求方法为 POST 请求
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [@"type=focus-c" dataUsingEncoding:NSUTF8StringEncoding];
    
    // 1. 初始化 NSURLSessionDataTask 对象
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
//        NSLog(@"response:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }];
    
    [dataTask resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)bonjourServerCreateTouched:(id)sender {
    _server = [[SFBonjourServer alloc] initWithType:@"dlna"];
}

- (IBAction)bonjourServerStartTouched:(id)sender {
    [_server start];

}

- (IBAction)bonjourServerStopTouched:(id)sender {
    [_server stop];
}

- (IBAction)bonjourClientCreateTouched:(id)sender {
    _client = [[SFBonjourClient alloc] initWithType:@"dlna"];
}

- (IBAction)bonjourClientStartBrowserTouched:(id)sender {
    [_client start];
}

- (IBAction)bonjourClientStopBrowerTouched:(id)sender {
    [_client stop];
}
@end
