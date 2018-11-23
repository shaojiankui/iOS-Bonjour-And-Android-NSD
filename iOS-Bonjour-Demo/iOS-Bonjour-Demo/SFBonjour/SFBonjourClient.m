//
//  SFBonjourClient.m
//  iOS-Bonjour-Demo
//
//  Created by Jakey on 2018/11/16.
//  Copyright © 2018 Jakey. All rights reserved.
//

#import "SFBonjourClient.h"
#include <arpa/inet.h>

NSString * const SFBonjourClientDefaultType = @"_SFBonjour._tcp.";
NSString * const SFBonjourClientErrorDomain = @"ServerErrorDomain";

@interface SFBonjourClient ()<NSNetServiceBrowserDelegate,NSNetServiceDelegate>
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSNetServiceBrowser *browser;
@property (nonatomic,strong) NSNetService *remoteService;
@end
@implementation SFBonjourClient
- (instancetype)init {
    return [self initWithType:SFBonjourClientDefaultType];
}


- (instancetype)initWithType:(NSString *)type {
    return [self initWithDomainName:@"local."
                               type:type
                               name:@""];
}

- (instancetype)initWithDomainName:(NSString *)domain
                              type:(NSString *)type
                              name:(NSString *)name{
    self = [super init];
    if (self) {
        self.domain = domain;
        self.type = [NSString stringWithFormat:@"_%@._tcp.", type];
        self.name = name;
    }
    return self;
}
- (BOOL)start{
    self.browser =[[NSNetServiceBrowser alloc] init];

    if (self.browser) {
       
        self.browser.delegate = self;
        [self.browser searchForServicesOfType:self.type inDomain:self.domain];
        [self.browser scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
        return  YES;
    }
    return NO;
}
- (BOOL)stop{
    [self.browser stop];
    [self.browser removeFromRunLoop:[NSRunLoop currentRunLoop]  forMode:NSRunLoopCommonModes];
    self.browser = nil;
    return YES;
}

#pragma --mark -- Browser delegate

/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    

}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    self.remoteService = service;
    self.remoteService.delegate = self;
    [self.remoteService resolveWithTimeout:20];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}
#pragma --mark server resolve

/* Sent to the NSNetService instance's delegate prior to resolving a service on the network. If for some reason the resolution cannot occur, the delegate will not receive this message, and an error will be delivered to the delegate via the delegate's -netService:didNotResolve: method.
 */
- (void)netServiceWillResolve:(NSNetService *)sender{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}

/* Sent to the NSNetService instance's delegate when one or more addresses have been resolved for an NSNetService instance. Some NSNetService methods will return different results before and after a successful resolution. An NSNetService instance may get resolved more than once; truly robust clients may wish to resolve again after an error, or to resolve more than once.
 */
- (void)netServiceDidResolveAddress:(NSNetService *)sender{
    NSLog(@"netServiceDidResolveAddress");
    NSData *data = [sender TXTRecordData];
    NSDictionary *info = [NSNetService dictionaryFromTXTRecordData:data];

    NSDictionary *ipInfo = [self parsingIP:sender];
    NSLog(@"parsingIP  : %@", ipInfo);
}
- (NSDictionary *)parsingIP:(NSNetService *)sender{
    int sPort = 0;
    NSString *ipv4;
    NSString *ipv6;
    
    for (NSData *address in [sender addresses]) {
        typedef union {
            struct sockaddr sa;
            struct sockaddr_in ipv4;
            struct sockaddr_in6 ipv6;
        } ip_socket_address;
        
        struct sockaddr *socketAddr = (struct sockaddr*)[address bytes];
        if(socketAddr->sa_family == AF_INET) {
            sPort = ntohs(((struct sockaddr_in *)socketAddr)->sin_port);
            struct sockaddr_in* pV4Addr = (struct sockaddr_in*)socketAddr;
            int ipAddr = pV4Addr->sin_addr.s_addr;
            char str[INET_ADDRSTRLEN];
            ipv4 = [NSString stringWithUTF8String:inet_ntop( AF_INET, &ipAddr, str, INET_ADDRSTRLEN )];
        }
        
        else if(socketAddr->sa_family == AF_INET6) {
            sPort = ntohs(((struct sockaddr_in6 *)socketAddr)->sin6_port);
            struct sockaddr_in6* pV6Addr = (struct sockaddr_in6*)socketAddr;
            char str[INET6_ADDRSTRLEN];
            ipv6 = [NSString stringWithUTF8String:inet_ntop( AF_INET6, &pV6Addr->sin6_addr, str, INET6_ADDRSTRLEN )];
        }
        else {
            NSLog(@"Socket Family neither IPv4 or IPv6, can't handle...");
        }
    }
    
    NSDictionary *data = @{@"type": [sender type],
                           @"domain": [sender domain],
                           @"name": [sender name],
                           @"ipv4": ipv4,
                           @"ipv6": ipv6,
                           @"port": [NSNumber numberWithInt:sPort]};
    return data;
}


/* Sent to the NSNetService instance's delegate when an error in resolving the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants).
 */
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    NSLog(@"%@",NSStringFromSelector(_cmd));

}
@end
