//
//  FCViewController.m
//  Forecastr Detailed
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

@interface FCViewController ()
{
    FCLocationManager *locationManager;
    Forecastr *forecastr;
}
@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Start updating the location
    locationManager = [FCLocationManager sharedManager];
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    
    // Get a reference to the Forecastr singleton
    forecastr = [Forecastr sharedManager];
    forecastr.apiKey = @"";
}

- (void)showFatalErrorAlert:(NSString *)alertMsg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Error"
                                                    message:alertMsg
                                                   delegate:self
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles: nil];
    [alert show];
}

// Basic forecast example
- (void)exampleForecastForLocation:(CLLocation *)location
{
    [forecastr getForecastForLocation:location time:nil exclusions:nil extend:nil language:nil success:^(id JSON) {
        NSLog(@"JSON response was: %@", JSON);
    } failure:^(NSError *error, id response) {
        NSLog(@"Error while retrieving forecast: %@", [forecastr messageForError:error withResponse:response]);
    }];
}

# pragma mark - FCLocationManagerDelegate Callbacks

// We successfully acquired the user's location
- (void)didAcquireLocation:(CLLocation *)location
{
    // Basic forecast example
    [self exampleForecastForLocation:location];
    
    // Set the location name
    [locationManager findNameForLocation:location];
}

// There was an error that prevented us from acquiring the location
- (void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg
{
    [self showFatalErrorAlert:errorMsg];
}

// We found the location name or defaulted to localized coordinates
- (void)didFindLocationName:(NSString *)locationName
{
    NSLog(@"Found location name to be: %@", locationName);
}

@end
