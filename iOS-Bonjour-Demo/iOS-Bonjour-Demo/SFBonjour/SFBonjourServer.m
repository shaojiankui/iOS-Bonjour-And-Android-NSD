//
//  SFBonjourServer.m
//  iOS-Bonjour-Demo
//
//  Created by Jakey on 2018/11/16.
//  Copyright © 2018 Jakey. All rights reserved.
//

#import "SFBonjourServer.h"
NSString * const SFBonjourDefaultType = @"_SFBonjour._tcp.";
NSString * const SFBonjourServerErrorDomain = @"ServerErrorDomain";
int   const SFBonjourDefaultPort = 2333;

@interface SFBonjourServer ()<NSNetServiceDelegate>
@property (nonatomic,copy) NSString *domain;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int port;
@property (nonatomic,strong) NSNetService *service;
@end
@implementation SFBonjourServer

- (instancetype)init {
    return [self initWithType:SFBonjourDefaultType];
}

- (instancetype)initWithType:(NSString *)type {
    return [self initWithDomainName:@"local."
                               type:type
                               name:@"SFBonjourServer"];
}

- (instancetype)initWithDomainName:(NSString *)domain
                          type:(NSString *)type
                              name:(NSString *)name {
    return [self initWithDomainName:domain
                               type:type
                               name:name
                               port:SFBonjourDefaultPort];
}
- (instancetype)initWithDomainName:(NSString *)domain
                              type:(NSString *)type
                              name:(NSString *)name
                              port:(int)port {
    self = [super init];
    if (self) {
        self.domain = domain;
        self.type = [NSString stringWithFormat:@"_%@._tcp.", type];
        self.name = name;
        self.port = port;
    }
    return self;
}
- (BOOL)start{
    self.service =[[NSNetService alloc] initWithDomain:self.domain type:self.type name:self.name port:self.port];
    
    if (self.service) {
        [self.service scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                   forMode:NSRunLoopCommonModes];
        NSData *data = [NSNetService dataFromTXTRecordDictionary:@{@"node":[NSNull null]}];
        [self.service setTXTRecordData:data];
        [self.service publish];
        self.service.delegate = self;
        return  YES;
    }
    return NO;
}
- (BOOL)stop{
    [self.service stop];
    [self.service removeFromRunLoop:[NSRunLoop currentRunLoop]  forMode:NSRunLoopCommonModes];
    self.service = nil;
    return YES;
}

#pragma --mark service delegate

/* Sent to the NSNetService instance's delegate prior to advertising the service on the network. If for some reason the service cannot be published, the delegate will not receive this message, and an error will be delivered to the delegate via the delegate's -netService:didNotPublish: method.
 */
- (void)netServiceWillPublish:(NSNetService *)sender{
    NSLog(@"netServiceWillPublish");
}

/* Sent to the NSNetService instance's delegate when the publication of the instance is complete and successful.
 */
- (void)netServiceDidPublish:(NSNetService *)sender{
    NSLog(@"netServiceDidPublish");

}

/* Sent to the NSNetService instance's delegate when an error in publishing the instance occurs. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a successful publication.
 */
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary<NSString *, NSNumber *> *)errorDict{
    NSLog(@"didNotPublish");

}


/* Sent to the NSNetService instance's delegate when the instance's previously running publication or resolution request has stopped.
 */
- (void)netServiceDidStop:(NSNetService *)sender{
    NSLog(@"netServiceDidStop");

}

/* Sent to the NSNetService instance's delegate when the instance is being monitored and the instance's TXT record has been updated. The new record is contained in the data parameter.
 */
- (void)netService:(NSNetService *)sender didUpdateTXTRecordData:(NSData *)data{
    NSLog(@"didUpdateTXTRecordData");

}


/* Sent to a published NSNetService instance's delegate when a new connection is
 * received. Before you can communicate with the connecting client, you must -open
 * and schedule the streams. To reject a connection, just -open both streams and
 * then immediately -close them.
 
 * To enable TLS on the stream, set the various TLS settings using
 * kCFStreamPropertySSLSettings before calling -open. You must also specify
 * kCFBooleanTrue for kCFStreamSSLIsServer in the settings dictionary along with
 * a valid SecIdentityRef as the first entry of kCFStreamSSLCertificates.
 */
- (void)netService:(NSNetService *)sender didAcceptConnectionWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream{
    NSLog(@"didAcceptConnectionWithInputStream");

}

@end
