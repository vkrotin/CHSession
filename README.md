# CHSession

[![Version](https://img.shields.io/cocoapods/v/CHSession.svg?style=flat)](http://cocoapods.org/pods/CHSession)
[![License](https://img.shields.io/cocoapods/l/CHSession.svg?style=flat)](http://cocoapods.org/pods/CHSession)
[![Platform](https://img.shields.io/cocoapods/p/CHSession.svg?style=flat)](http://cocoapods.org/pods/CHSession)

This Manager is designed for ease of cache management requests NSURLSession.
Valid GET, POST, HEAD requests.
It is possible to set the size of the allocated memory for the cache. 
It is also possible to set the size of the allocated space for the cache on disk.
Cache management:
*entry
*reading
*cleaning

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
```objective-c

#import "CHSessionManager.h"
// install Cash size
// AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [CHSessionManager setDefaultCapacity];
    ...
 
// Request in some class

// GET
[CHSessionManager getUrl:someURL
                  parameters:dict params, maybe nil
             timeoutInterval:HTTP_DEFAULT_TIMEOUT
                  cachPolicy:CHRequestReturnCacheDataElseLoad
           completionHandler:^(NSData *data, NSURLResponse *response){
               // do something with data or responce out code
           }errorHandler:^(NSError *error){
               // cath the error
           }];

// POST, while no cache
[CHSessionManager postUrl:someURL
                   parameters:dict params, maybe nil
              timeoutInterval:HTTP_DEFAULT_TIMEOUT
            completionHandler:^(NSData *data, NSURLResponse *response){
                // do something with data or responce out code
            } errorHandler:^(NSError *error){
               // cath the error
            }];

// HEAD
[CHSessionManager headUrl:someURL
                   parameters:nil
              timeoutInterval:HTTP_DEFAULT_TIMEOUT
            completionHandler:^(NSDictionary *headDictionary, NSURLResponse *responce){
                // do something with HEAD dictionary or responce out code
            }errorHandler:nil];
           
           
```


## Installation

CHSession is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CHSession"
```

## Author

Aleksey Anisimov, vkrotin.ios@gmail.com

## License

CHSession is available under the MIT license. See the LICENSE file for more info.
