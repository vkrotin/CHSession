//
//  CHSessionManager.h
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHSessionRequest.h"

@interface CHSessionManager : NSObject

/**
 *  Default cache (memory size - 4 Mb, disk size - 20 Mb)
 */
+ (void)setDefaultCapacity;

/**
 *
 *  @param memoryCapacity  memory space
 *  @param diskCapacity    size of the disk cache
 *
 */
+ (void)setMaxMemoryCapacity:(NSUInteger)memoryCapacity maxDiskCapacity:(NSUInteger)diskCapacity;

/**
 *  Buffer size
 *
 *  @return : return size buffer
 */
+ (NSUInteger)getCacheCapacity;

/**
 *  Removing a value from the buffer
 *
 *  @param request  request for remove cache
 */
+ (void)removeCachedResponseForRequest:(NSURLRequest *)request;

/**
 *  To clear the entire buffer.
 */
+ (void)removeAllCachedResponses;

/**
 *  Remove at the appointed date, before writing to the buffer.
 *
 *  @param date  appointed date
 */
+ (void)removeCachedResponsesSinceDate:(NSDate *)date;

/**
 *  get Request
 *
 *  @param uri               RequestURL
 *  @param parameters        Request parameters,NSData(POST) or NSDictionary
 *  @param timeoutInterval   RequestTimeout
 *  @param cachPolicy        Type cache Policy
 *  @param completionHandler Query result
 *  @param errorHandler      error
 */
+ (void) getUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval cachPolicy:(CHRequestCachePolicy)cachPolicy completionHandler:(void (^)(NSData *data, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler;

/**
 *  post Request
 *
 *  @param uri               PostRequestURL
 *  @param parameters        Request parameters,NSData(POST) or NSDictionary
 *  @param timeoutInterval   RequestTimeout
 *  @param completionHandler Query result
 *  @param errorHandler      error
 */
+ (void) postUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSData *data, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler;

/**
 *  head Request
 *
 *  @param uri               HeadRequestURL
 *  @param parameters        Request parameters,NSData(POST) or NSDictionary
 *  @param timeoutInterval   RequestTimeout
 *  @param completionHandler Query HEAD data result
 *  @param errorHandler      error
 */
+ (void) headUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSDictionary *headDictionary, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler;


@end
