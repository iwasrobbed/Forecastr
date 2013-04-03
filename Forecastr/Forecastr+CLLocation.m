//
//  Forecastr+CLLocation.m
//  Forecastr
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

#import "Forecastr+CLLocation.h"

@implementation Forecastr (CLLocation)

// Request the forecast for the given CLLocation and optional time and/or exclusions
- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    [self getForecastForLatitude:latitude longitude:longitude time:time exclusions:exclusions success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
