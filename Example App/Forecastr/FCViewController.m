//
//  FCViewController.m
//  Forecastr
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "FCViewController.h"
#import "Forecastr.h"

static float kDemoLatitude = 45.5081; // South is negative
static float kDemoLongitude = -73.5550; // West is negative
static double kDemoDateTime = 1364991687; // EPOCH time

@interface FCViewController ()
{
    Forecastr *forecastr;
}
@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Get a reference to the Forecastr singleton and set the API key
    // (You only have to set the API key once since it's a singleton)
    forecastr = [Forecastr sharedManager];
    forecastr.apiKey = @"";
    
    // Uncomment to change basic caching properties
    //forecastr.cacheEnabled = NO; // Enabled by default
    //forecastr.cacheExpirationInMinutes = 10; // 30 minutes by default
    
    // A note about caching: Forecastr caches based on the URL used to make the request
    // so all params should be properly returned from the cached item just like they
    // were originally requested
    
    // Kick off asking for weather data for Montreal on 2013-04-03 12:21:27 +0000
    [self forecastWithTime];
    
    // Kick off asking for weather without specifying a time
    [self forecastWithoutTime];
    
    // Kick off asking for weather while specifying exclusions
    [self forecastWithExclusions];
    
    // Kick off asking for weather while specifying exclusions, SI units, and JSONP callback
    [self forecastWithMultipleOptions];
    
    // Kick off asking for weather for a bad latitude/longitude
    [self forecastWithBadInputs];
    
    // Remove a cached item prematurely (before it expires)
    [self removeCachedItemPrematurely];
    
    // Kick off asking for weather with extended hourly option
    [self forecastWithExtendHourly];
    
    // Kick off asking for weather in another language
    [self forecastInFrench];
}

// Kick off asking for weather data for Montreal on 2013-04-03 12:21:27 +0000
- (void)forecastWithTime
{
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:[NSNumber numberWithDouble:kDemoDateTime] exclusions:nil extend:nil success:^(id JSON) {
        NSLog(@"JSON Response (for %@) was: %@", [NSDate dateWithTimeIntervalSince1970:kDemoDateTime], JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

// Kick off asking for weather without specifying a time
- (void)forecastWithoutTime
{
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:nil extend:nil success:^(id JSON) {
        NSLog(@"JSON Response was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

// Kick off asking for weather while specifying exclusions
// Currently, the exclusions can be: currently, minutely, hourly, daily, alerts, flags
- (void)forecastWithExclusions
{
    NSArray *tmpExclusions = @[kFCAlerts, kFCFlags, kFCMinutelyForecast, kFCHourlyForecast, kFCDailyForecast];
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:tmpExclusions extend:nil success:^(id JSON) {
        NSLog(@"JSON Response (w/ exclusions: %@) was: %@", tmpExclusions, JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

// Kick off asking for weather while specifying exclusions, SI units, and JSONP callback
- (void)forecastWithMultipleOptions
{
    forecastr.units = kFCSIUnits;
    forecastr.callback = @"someJavascriptFunctionName";
    NSArray *tmpExclusions = @[kFCAlerts, kFCFlags, kFCMinutelyForecast, kFCHourlyForecast, kFCDailyForecast];
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:tmpExclusions extend:nil success:^(id JSON) {
        NSLog(@"JSON Response (w/ SI units, JSONP callback, and exclusions: %@) was: %@", tmpExclusions, JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
    forecastr.callback = nil;
}

// Kick off asking for weather for a bad latitude/longitude
- (void)forecastWithBadInputs
{
    [forecastr getForecastForLatitude:999999.99 longitude:999999.99 time:nil exclusions:nil extend:nil success:^(id JSON) {
        // It won't be successful
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast (don't worry, we forced this error on purpose): %@", [forecastr messageForError:error withResponse:response]);
    }];
}

// Remove a cached item prematurely (before it expires)
- (void)removeCachedItemPrematurely
{
    // We will be removing the item that was cached in the `forecastWithoutTime` method
    // You might have to run this app twice for it to be cached first (since the requests are async)
    [forecastr removeCachedForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:nil extend:nil language:nil];
}

// Kick off asking for weather with extended hourly option
- (void)forecastWithExtendHourly
{
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:nil extend:kFCExtendHourly success:^(id JSON) {
        NSLog(@"JSON Response (w/ extended hourly) was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

// Kick off asking for weather in another language
- (void)forecastInFrench {
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:nil extend:nil language:kFCLanguageFrench success:^(id JSON) {
        NSLog(@"JSON Response (en française) was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

@end
