//
//  ShanYanNetworkStatusTool.m
//  ShanYanAppStoreDemo
//
//  Created by KevinChien on 2020/4/8.
//  Copyright © 2020 wanglijun. All rights reserved.
//

#import "ShanYanNetworkStatusTool.h"

/*
 * Level number for (get/set)sockopt() to apply to socket itself.
 */
#define SOL_SOCKET      0xffff          /* options for socket level */


/*
 * Address families.
 */
#define AF_UNSPEC       0               /* unspecified */
#define AF_UNIX         1               /* local to host (pipes) */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define AF_LOCAL        AF_UNIX         /* backward compatibility */
#endif  /* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
#define AF_INET         2               /* internetwork: UDP, TCP, etc. */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define AF_IMPLINK      3               /* arpanet imp addresses */
#define AF_PUP          4               /* pup protocols: e.g. BSP */
#define AF_CHAOS        5               /* mit CHAOS protocols */
#define AF_NS           6               /* XEROX NS protocols */
#define AF_ISO          7               /* ISO protocols */
#define AF_OSI          AF_ISO
#define AF_ECMA         8               /* European computer manufacturers */
#define AF_DATAKIT      9               /* datakit protocols */
#define AF_CCITT        10              /* CCITT protocols, X.25 etc */
#define AF_SNA          11              /* IBM SNA */
#define AF_DECnet       12              /* DECnet */
#define AF_DLI          13              /* DEC Direct data link interface */
#define AF_LAT          14              /* LAT */
#define AF_HYLINK       15              /* NSC Hyperchannel */
#define AF_APPLETALK    16              /* Apple Talk */
#define AF_ROUTE        17              /* Internal Routing Protocol */
#define AF_LINK         18              /* Link layer interface */
#define pseudo_AF_XTP   19              /* eXpress Transfer Protocol (no AF) */
#define AF_COIP         20              /* connection-oriented IP, aka ST II */
#define AF_CNT          21              /* Computer Network Technology */
#define pseudo_AF_RTIP  22              /* Help Identify RTIP packets */
#define AF_IPX          23              /* Novell Internet Protocol */
#define AF_SIP          24              /* Simple Internet Protocol */
#define pseudo_AF_PIP   25              /* Help Identify PIP packets */
#define AF_NDRV         27              /* Network Driver 'raw' access */
#define AF_ISDN         28              /* Integrated Services Digital Network */
#define AF_E164         AF_ISDN         /* CCITT E.164 recommendation */
#define pseudo_AF_KEY   29              /* Internal key-management function */
#endif  /* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */
#define AF_INET6        30              /* IPv6 */
#if !defined(_POSIX_C_SOURCE) || defined(_DARWIN_C_SOURCE)
#define AF_NATM         31              /* native ATM access */
#define AF_SYSTEM       32              /* Kernel event messages */
#define AF_NETBIOS      33              /* NetBIOS */
#define AF_PPP          34              /* PPP communication protocol */
#define pseudo_AF_HDRCMPLT 35           /* Used by BPF to not rewrite headers
                                     *  in interface output routine */
#define AF_RESERVED_36  36              /* Reserved for internal usage */
#define AF_IEEE80211    37              /* IEEE 802.11 protocol */
#define AF_UTUN         38
#define AF_MAX          40
#endif  /* (!_POSIX_C_SOURCE || _DARWIN_C_SOURCE) */


#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>


#include <ifaddrs.h>
#include <sys/socket.h>
#import <arpa/inet.h>
@implementation ShanYanNetworkStatusTool

#pragma mark 是否存在蜂窝网络检测
+ (BOOL)cellularMobileNetworkStatus {
    return ([self networkChecking_ipAddressWithIfaName:@"pdp_ip0"]);
}

#pragma mark 是否存在WLAN
+ (BOOL)wifiStatus {
    return ([self networkChecking_ipAddressWithIfaName:@"en0"]);
}

/*
CTRadioAccessTechnologyGPRS             2.5G
CTRadioAccessTechnologyEdge             2.75G

CTRadioAccessTechnologyWCDMA            3G
CTRadioAccessTechnologyHSDPA            3.5G
CTRadioAccessTechnologyHSUPA            3.5G

CTRadioAccessTechnologyCDMA1x           2G
CTRadioAccessTechnologyCDMAEVDORev0     3G
CTRadioAccessTechnologyCDMAEVDORevA     3.5G
CTRadioAccessTechnologyCDMAEVDORevB     3.5G
CTRadioAccessTechnologyeHRPD            3G 高通对EVDO的统称

CTRadioAccessTechnologyLTE              4G
⚠️：该方法只能检测当前信号类型，检测不出是否关闭蜂窝流量
*/
#pragma mark 当前蜂窝网络 名称
+ (NSString*)currentCellularMobileNetworkName{

    NSString *netName = [[CTTelephonyNetworkInfo alloc] init].currentRadioAccessTechnology;
    
    if ([netName isEqualToString:CTRadioAccessTechnologyGPRS] ||
        [netName isEqualToString:CTRadioAccessTechnologyEdge] ||
        [netName isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
        return @"2G";
    }
    
    if ([netName isEqualToString:CTRadioAccessTechnologyWCDMA] ||
        [netName isEqualToString:CTRadioAccessTechnologyHSDPA] ||
        [netName isEqualToString:CTRadioAccessTechnologyHSUPA] ||
        [netName isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0] ||
        [netName isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA] ||
        [netName isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB] ||
        [netName isEqualToString:CTRadioAccessTechnologyeHRPD]) {
        return @"3G";
    }
    
    if ([netName isEqualToString:CTRadioAccessTechnologyLTE]) {
        return @"4G";
    }

    return @"无网络或飞行模式";
}

#pragma mark 网络检测
+ (NSString *)networkChecking_ipAddressWithIfaName:(NSString *)name {
    if (name.length == 0) return nil;
    NSString *address = nil;
    struct ifaddrs *addrs = NULL;
    if (getifaddrs(&addrs) == 0) {
        struct ifaddrs *addr = addrs;
        while (addr) {
            if ([[NSString stringWithUTF8String:addr->ifa_name] isEqualToString:name]) {
                sa_family_t family = addr->ifa_addr->sa_family;
                switch (family) {
                    case AF_INET: { // IPv4
                        char str[INET_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in *)addr->ifa_addr)->sin_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    } break;
                        
                    case AF_INET6: { // IPv6
                        char str[INET6_ADDRSTRLEN] = {0};
                        inet_ntop(family, &(((struct sockaddr_in6 *)addr->ifa_addr)->sin6_addr), str, sizeof(str));
                        if (strlen(str) > 0) {
                            address = [NSString stringWithUTF8String:str];
                        }
                    }
                        
                    default: break;
                }
                if (address) break;
            }
            addr = addr->ifa_next;
        }
    }
    freeifaddrs(addrs);
    return address ? address : nil;
}

@end
