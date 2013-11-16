Forecastr
=========

A simple Objective-C wrapper to make asynchronous requests to the [Forecast.io API version 2](https://developer.forecast.io/docs/v2)

**Note:** You will need to [request an API key](https://developer.forecast.io) and set that key when you first instantiate Forecastr, otherwise an exception will be thrown.

**Updated to match the Forecast.io API as of August 4, 2013**

## Quick Examples ##

The code base comes with two examples:
* **Example App**: A simple example showing how to use all of the different options available through the API request
* **Detailed Example App**: An example app that uses CoreLocation to get the user's current location and then uses that to make a basic forecast request

And here is a very basic example:

```objc
#import "FCViewController.h"
#import "Forecastr.h"

@interface FCViewController ()
{
    Forecastr *forecastr;
}
@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get a reference to the Forecastr singleton
    forecastr = [Forecastr sharedManager];
    forecastr.apiKey = @""; // You will need to set the API key here (only set it once in the entire app)

    [forecastr getForecastForLatitude:45.5081 longitude:-73.5550 time:nil exclusions:nil extend:nil success:^(id JSON) {
        NSLog(@"JSON Response was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

@end
```

## Supports ##
* Basic, asynchronous caching of the requests based on the URL used to make the request.  This is to prevent unnecessary data usage and round trips to Forecast.io
* Specifying `US`, `SI`, `UK`, or `CA` units
* Specifying a JSONP callback method name (e.g. `someJavascriptMethodName({jsonResponseGoesHere})`)
* Specifying exclusions in the response (e.g. leaving out `currently`, `minutely`, `hourly`, `daily`, `alerts`, or `flags`)
* Canceling any existing forecast requests with `[forecastr cancelAllForecastRequests];`
* Specifying `extend` hourly options to return hourly data for the next seven days rather than the next two
* iOS 7+ since it requires AFNetworking 2.0.  Please use one of the previous releases if you need support for iOS 5 or 6 (all releases are tagged)

## Options ##
* If you want to use a `CLLocation` object instead of pure latitude/longitude, import `Forecastr+CLLocation.h` instead of `Forecastr.h`

## Caching ##
* Caching is enabled by default, so you don't need to do anything to use it 
* You can disable cache by setting `forecastr.cacheEnabled = NO;` 
* You can change the cache expiration period by setting `forecastr.cacheExpirationInMinutes = 10;` or some other integer value
* You can remove an old cached item if you want to refresh it prematurely (see basic example app)
* You can flush all items from the cache with `[forecastr flushCache];` (might be a good idea to do this every time your app starts)

## Extras ##

The wrapper has a number of extras so please have a look at all of the source files included with it so you don't duplicate existing work.  For instance, there are constants created for all constant values in the API such as data block / point dictionary key names, weather icon names, unit types, etc.

Additionally, there are a few helper methods that were written to help with UI display of the JSON data:

* `descriptionForPrecipIntensity` will return a human readable description based on the precipitation intensity floating point value
* `imageNameForWeatherIconType` will return an image name based on the weather icon type specified in the forecast response
* `messageForError:withResponse:` will try and find the most human readable error description based on the response and then reverts to the error's localized description if nothing else is found

## API Errors ##

There are only two types of error responses: 400 errors (where you provide invalid input, such as an impossible latitude or longitude) or 500 errors (where something unexpected happened on the Forecast.io servers).  Both cases return a JSON object with a string "error" property that can be used to determine the cause of the error. In all other scenarios, an HTTP 200 is returned, but pieces of data may be lacking (even in circumstances of normal operation).  Therefore, you should always check that the properties you intend to use actually exist before using them, and in the event that they are missing, treat it as an error at your discretion.

One simple way of checking if a dictionary key exists is:

```objc
id temperature = [forecast objectForKey:kFCTemperature];
self.temperatureLabel.text = temperature ? [NSString stringWithFormat:@"%d°", [temperature intValue]] : @"N/A";
```

In this example, we simply check if the object is nil and return `N/A` if so, otherwise we return a formatted temperature value.

## License ##

Essentially, this code is free to use in commercial and non-commercial projects with no attribution necessary.

See the `LICENSE` file for more details.

## Thank You ##

A HUGE thank you to the following people for helping me improve and maintain Forecastr:  

* [Mark Rickert](https://github.com/markrickert)
* [Richard Fung](https://github.com/rhfung)
* [Matthew Morey](https://github.com/mmorey)
* [Joe](https://github.com/jregan)

If you'd like to help, please submit a pull request with tested code and please also update any examples that your code might affect.