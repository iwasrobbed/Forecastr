//
//  Forecastr.h
//  Forecastr
//
//  Created by Rob Phillips on 4/3/13.
//  Copyright (c) 2013 Rob Phillips. All rights reserved.
//

#import <Foundation/Foundation.h>

// Unit types
extern NSString *const kFCUSUnits;
extern NSString *const kFCSIUnits;
extern NSString *const kFCUKUnits;

// Forecast names used for the data block hash keys
extern NSString *const kFCCurrentlyForecast;
extern NSString *const kFCMinutelyForecast;
extern NSString *const kFCHourlyForecast;
extern NSString *const kFCDailyForecast;

// Additional names used for the data block hash keys
extern NSString *const kFCAlerts;
extern NSString *const kFCFlags;
extern NSString *const kFCLatitude;
extern NSString *const kFCLongitude;
extern NSString *const kFCOffset;
extern NSString *const kFCTimezone;

// Names used for the data point hash keys
extern NSString *const kFCCloudCover;
extern NSString *const kFCCloudCoverError;
extern NSString *const kFCHumidity;
extern NSString *const kFCHumidityError;
extern NSString *const kFCIcon;
extern NSString *const kFCPrecipAccumulation;
extern NSString *const kFCPrecipIntensity;
extern NSString *const kFCPrecipProbability;
extern NSString *const kFCPrecipType;
extern NSString *const kFCPressure;
extern NSString *const kFCPressureError;
extern NSString *const kFCSummary;
extern NSString *const kFCSunriseTime;
extern NSString *const kFCSunsetTime;
extern NSString *const kFCTemperature;
extern NSString *const kFCTemperatureMax;
extern NSString *const kFCTemperatureMaxError;
extern NSString *const kFCTemperatureMaxTime;
extern NSString *const kFCTemperatureMin;
extern NSString *const kFCTemperatureMinError;
extern NSString *const kFCTemperatureMinTime;
extern NSString *const kFCTime;
extern NSString *const kFCVisibility;
extern NSString *const kFCVisibilityError;
extern NSString *const kFCWindBearing;
extern NSString *const kFCWindSpeed;
extern NSString *const kFCWindSpeedError;

@interface Forecastr : NSObject

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSString *callback;

/**
 * Initializes and returns a new Forecastr singleton object
 *
 * @return a new singleton object
 */

+ (id)sharedManager;

/**
 * Request the forecast for the given location and optional time and/or exclusions
 *
 * @param lat The latitude of the location.
 * @param long The longitude of the location.
 * @param time (Optional) The desired time of the forecast in UNIX GMT format
 * @param exclusions (Optional) An array which specifies which data blocks you would like left off the response
 * @param success A block object to be executed when the operation finishes successfully.
 * @param failure A block object to be executed when the operation finishes unsuccessfully.
 *
 * @discussion for many locations, it can be 60 years in the past to 10 years in the future.
 */

- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error))failure;

@end
