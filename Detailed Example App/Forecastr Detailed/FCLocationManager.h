//
//  FCLocationManager.h
//  Forecastr Detailed
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol FCLocationManagerDelegate <NSObject>
- (void)didAcquireLocation:(CLLocation *)location;
- (void)didFailToAcquireLocationWithErrorMsg:(NSString *)errorMsg;
@end

@interface FCLocationManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, weak) id <FCLocationManagerDelegate>delegate;

+ (id)sharedManager;
- (void)startUpdatingLocation;

@end
