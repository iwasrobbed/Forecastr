Forecastr
=========

A simple Objective-C wrapper to make asynchronous requests to the [Forecast.io API version 2](https://developer.forecast.io/docs/v2)

**Note:** You will need to [request an API key](https://developer.forecast.io) and set that key when you first instantiate Forecastr, otherwise an exception will be thrown.

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

    [forecastr getForecastForLatitude:45.5081 longitude:-73.5550 time:nil exclusions:nil success:^(id JSON) {
        NSLog(@"JSON Response was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

@end
```

## Supports ##
* Basic caching of the requests based on the URL used to make the request.  This is to prevent unnecessary data usage and round trips to Forecast.io
* Specifying `US`, `SI`, or `UK` units
* Specifying a JSONP callback method name (e.g. `someJavascriptMethodName({jsonResponseGoesHere})`)
* Specifying exclusions in the response (e.g. leaving out `currently`, `minutely`, `hourly`, `daily`, `alerts`, or `flags`)

## Options ##
* If you want to use a `CLLocation` object instead of pure latitude/longitude, import `Forecastr+CLLocation.h` instead of `Forecastr.h`

## Caching ##
* Caching is enabled by default, so you don't need to do anything to use it 
* You can disable cache by setting `forecastr.cacheEnabled = NO;` 
* You can change the cache expiration period by setting `forecastr.cacheExpirationInMinutes = 10;` or some other integer value
* You can remove an old cached item if you want to refresh it prematurely (see basic example app)

## License ##

Essentially, this code is free to use in commercial and non-commercial projects with no attribution necessary.

See the `LICENSE` file for more details.