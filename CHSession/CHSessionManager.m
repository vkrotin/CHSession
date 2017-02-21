//
//  CHSessionManager.m
//  CacheManager
//
//  Created by Aleksey Anisimov on 21.02.17.
//  Copyright © 2017 vkrotin LLC. All rights reserved.
//

#import "CHSessionManager.h"

@implementation CHSessionManager


+ (void)setDefaultCapacity
{
    [CHSessionManager setMaxMemoryCapacity:50 maxDiskCapacity:100];
    
    
}

+ (void)setMaxMemoryCapacity:(NSUInteger)memoryCapacity maxDiskCapacity:(NSUInteger)diskCapacity
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:memoryCapacity*1024*1024 diskCapacity:diskCapacity*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

+ (NSUInteger)getCacheCapacity
{
    NSUInteger cacheCapacity = [NSURLCache sharedURLCache].currentDiskUsage;
    return cacheCapacity;
}

+ (void)removeCachedResponseForRequest:(NSURLRequest *)request
{
    @synchronized([NSURLCache sharedURLCache]) {
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    }
}

+ (void)removeAllCachedResponses
{
    @synchronized([NSURLCache sharedURLCache]) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

+ (void)removeCachedResponsesSinceDate:(NSDate *)date
{
    @synchronized([NSURLCache sharedURLCache]) {
        [[NSURLCache sharedURLCache] removeCachedResponsesSinceDate:date];
    }
}

+ (void) getUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval cachPolicy:(CHRequestCachePolicy)cachPolicy completionHandler:(void (^)(NSData *data, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler
{
    NSMutableURLRequest *request = CHRequestWithURL(uri, nil, parameters, timeoutInterval, YES, cachPolicy);
    if (request == nil || [request isEqual:[NSNull null]]) {
        dispatch_async_safe_main_queue(^{
            NSError *error;
            if (errorHandler)
                errorHandler(error);
        });
        return;
    }
    //  NSLog(@"get url:%@", request.URL);
    
    if (cachPolicy != CHRequestIgnoringLocalCacheData) {
        NSCachedURLResponse* response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        //Определить, если любой из буферов.
        if (response != nil) {
           // NSLog(@"Наличие буфера.");
        }
    }else{
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [CHSessionManager removeCachedResponseForRequest:request];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if ((error == nil || [error isEqual:[NSNull null]])&& data != nil) {
                                                dispatch_async_safe_main_queue(^{
                                                    completionHandler(data,response);
                                                });
                                                if (cachPolicy == CHRequestIgnoringLocalCacheData) {
                                                    //Игнорировать буфер, удалить буфер.
                                                    [CHSessionManager removeCachedResponseForRequest:request];
                                                }
                                            }else{
                                                dispatch_async_safe_main_queue(^{
                                                    errorHandler(error);
                                                });
                                                //Ошибка запроса, очистка буфера.
                                                [CHSessionManager removeCachedResponseForRequest:request];
                                            }
                                        }];
    [task resume];
}


+ (void) headUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSDictionary *headDictionary, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler{
    NSMutableURLRequest *request = CHRequestWithURL(uri, @"HEAD", parameters, timeoutInterval, YES,CHRequestIgnoringLocalCacheData);
    if (request == nil || [request isEqual:[NSNull null]]) {
        
        dispatch_async_safe_main_queue(^{
            NSError *error;
            if (errorHandler)
                errorHandler(error);
        });
        return;
    }
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
                                            if ((error == nil || [error isEqual:[NSNull null]])&& headers != nil) {
                                                dispatch_async_safe_main_queue(^{
                                                    completionHandler(headers,response);
                                                });
                                            }else{
                                                dispatch_async_safe_main_queue(^{
                                                    errorHandler(error);
                                                });
                                                [CHSessionManager removeCachedResponseForRequest:request];
                                            }
                                        }];
    [task resume];
    
    
}

+ (void) postUrl:(NSString *)uri parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSData *data, NSURLResponse *response))completionHandler errorHandler:(void (^)(NSError *error))errorHandler
{
    NSMutableURLRequest *request = CHRequestWithURL(uri, @"POST", parameters, timeoutInterval, YES,CHRequestIgnoringLocalCacheData);
    if (request == nil || [request isEqual:[NSNull null]]) {
        dispatch_async_safe_main_queue(^{
            NSError *error;
            if (errorHandler)
                errorHandler(error);
        });
        return;
    }
    NSLog(@"post url:%@", request.URL);
    //post пока не использует буфер.
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if ((error == nil || [error isEqual:[NSNull null]])&& data != nil) {
                                                dispatch_async_safe_main_queue(^{
                                                    completionHandler(data,response);
                                                });
                                            }else{
                                                dispatch_async_safe_main_queue(^{
                                                    errorHandler(error);
                                                });
                                                [CHSessionManager removeCachedResponseForRequest:request];
                                            }
                                        }];
    [task resume];
}


@end
