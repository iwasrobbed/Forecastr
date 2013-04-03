//
//  FCViewController.m
//  Forecastr Detailed
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

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

# pragma mark - FCLocationManagerDelegate Callbacks

// We successfully acquired the user's location
- (void)didAcquireLocation:(CLLocation *)location
{
    [forecastr getForecastForLocation:location time:nil exclusions:nil success:^(id JSON) {
        NSLog(@"JSON response was: %@", JSON);
    } failure:^(NSError *error) {
        NSLog(@"Error while retrieving forecast: %@", error.localizedDescription);
    }];
}

// There was an error that prevented us from acquiring the location
- (void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg
{
    [self showFatalErrorAlert:errorMsg];
}

@end
