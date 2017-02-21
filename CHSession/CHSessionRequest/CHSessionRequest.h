//
//  CHSessionRequest.h
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_DEFAULT_TIMEOUT    20

#define MA_IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#define dispatch_async_safe_main_queue(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

typedef NS_ENUM(NSUInteger, CHRequestCachePolicy)
{
    /*
     *  Ignore buffer, and restart request
     */
    CHRequestIgnoringLocalCacheData  = NSURLRequestReloadIgnoringCacheData,
    /*
     *  Use buffer. If there's no buffer, just to repeat the request
     */
    CHRequestReturnCacheDataElseLoad = NSURLRequestReturnCacheDataElseLoad,
    /*
     *  Use buffer. If there's no buffer -  the request for error handling (for off-line model)
     */
    CHRequestReturnCacheDataDontLoad = NSURLRequestReturnCacheDataDontLoad,
};

/*
 *  NSURLRequest
 *
 *  @param urlPath    RequestUrl
 *  @param method     Type request（default GET）
 *  @param parameters Parameters request
 *  @param timeout    timeoutInterval
 *  @param encoding   Decoding
 *  @param cachPolicy Buffer type
 *
 *  @return NSMutableURLRequest
 */
NSMutableURLRequest *CHRequestWithURL(NSString *urlPath,NSString *method,id parameters,NSTimeInterval timeout, BOOL encoding, CHRequestCachePolicy cachPolicy);


@interface CHSessionRequest : NSObject

@end
