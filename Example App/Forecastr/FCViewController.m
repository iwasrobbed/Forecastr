//
//  FCViewController.m
//  Forecastr
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

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
    forecastr.apiKey = @"abe9f926962c402b18e221b06e3cd8e8";
    
    // Kick off asking for weather data for Montreal on 2013-04-03 12:21:27 +0000
    [self forecastWithTime];
    
    // Kick off asking for weather without specifying a time
    [self forecastWithoutTime];
    
    // Kick off asking for weather while specifying exclusions
    [self forecastWithExclusions];
    
    // Kick off asking for weather while specifying exclusions, SI units, and JSONP
    [self forecastWithMultipleOptions];
}

// Kick off asking for weather data for Montreal on 2013-04-03 12:21:27 +0000
- (void)forecastWithTime
{
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:[NSNumber numberWithDouble:kDemoDateTime] exclusions:nil success:^(id JSON) {
        NSLog(@"JSON Response (for %@) was: %@", [NSDate dateWithTimeIntervalSince1970:kDemoDateTime], JSON);
    } failure:^(NSError *error) {
        NSLog(@"Error while retrieving forecast: %@", error.localizedDescription);
    }];
}

// Kick off asking for weather without specifying a time
- (void)forecastWithoutTime
{
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:nil success:^(id JSON) {
        NSLog(@"JSON Response was: %@", JSON);
    } failure:^(NSError *error) {
        NSLog(@"Error while retrieving forecast: %@", error.localizedDescription);
    }];
}

// Kick off asking for weather while specifying exclusions
// Currently, the exclusions can be: currently, minutely, hourly, daily, alerts, flags
- (void)forecastWithExclusions
{
    NSArray *tmpExclusions = [NSArray arrayWithObjects:kFCAlerts, kFCFlags, kFCMinutelyForecast, kFCHourlyForecast, kFCDailyForecast, nil];
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:tmpExclusions success:^(id JSON) {
        NSLog(@"JSON Response (w/ exclusions: %@) was: %@", tmpExclusions, JSON);
    } failure:^(NSError *error) {
        NSLog(@"Error while retrieving forecast: %@", error.localizedDescription);
    }];
}

// Kick off asking for weather while specifying exclusions, SI units, and JSONP
- (void)forecastWithMultipleOptions
{
    forecastr.units = kFCSIUnits;
    forecastr.jsonp = @"someJavascriptFunctionName";
    NSArray *tmpExclusions = [NSArray arrayWithObjects:kFCAlerts, kFCFlags, kFCMinutelyForecast, kFCHourlyForecast, kFCDailyForecast, nil];
    [forecastr getForecastForLatitude:kDemoLatitude longitude:kDemoLongitude time:nil exclusions:tmpExclusions success:^(id JSON) {
        NSLog(@"JSON Response (w/ SI units, JSONP callback, and exclusions: %@) was: %@", tmpExclusions, JSON);
    } failure:^(NSError *error) {
        NSLog(@"Error while retrieving forecast: %@", error.localizedDescription);
    }];
}

@end
