//
//  Forecastr+CLLocation.m
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

#import "Forecastr+CLLocation.h"

@implementation Forecastr (CLLocation)

// Requests the forecast for the given CLLocation and optional time and/or exclusions
- (void)getForecastForLocation:(CLLocation *)location
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    [self getForecastForLatitude:latitude longitude:longitude time:time exclusions:exclusions success:^(id JSON) {
        success(JSON);
    } failure:^(NSError *error, id response) {
        failure(error, response);
    }];
}

// Removes a cached forecast in case you want to refresh it prematurely
- (void)removeCachedForecastForLocation:(CLLocation *)location
                                   time:(NSNumber *)time
                             exclusions:(NSArray *)exclusions
{
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    [self removeCachedForecastForLatitude:latitude longitude:longitude time:time exclusions:exclusions];
}

@end
