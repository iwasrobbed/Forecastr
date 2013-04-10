//
//  Forecastr.m
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

#import "Forecastr.h"
#import "AFNetworking.h"

/**
 * A common area for changing the names of all constants used in the JSON response
 */

// Unit types
NSString *const kFCUSUnits = @"us";
NSString *const kFCSIUnits = @"si";
NSString *const kFCUKUnits = @"uk";

// Forecast names used for the data block hash keys
NSString *const kFCCurrentlyForecast = @"currently";
NSString *const kFCMinutelyForecast = @"minutely";
NSString *const kFCHourlyForecast = @"hourly";
NSString *const kFCDailyForecast = @"daily";

// Additional names used for the data block hash keys
NSString *const kFCAlerts = @"alerts";
NSString *const kFCFlags = @"flags";
NSString *const kFCLatitude = @"latitude";
NSString *const kFCLongitude = @"longitude";
NSString *const kFCOffset = @"offset";
NSString *const kFCTimezone = @"timezone";

// Names used for the data point hash keys
NSString *const kFCCloudCover = @"cloudCover";
NSString *const kFCCloudCoverError = @"cloudCoverError";
NSString *const kFCHumidity = @"humidity";
NSString *const kFCHumidityError = @"humidityError";
NSString *const kFCIcon = @"icon";
NSString *const kFCPrecipAccumulation = @"precipAccumulation";
NSString *const kFCPrecipIntensity = @"precipIntensity";
NSString *const kFCPrecipProbability = @"precipProbability";
NSString *const kFCPrecipType = @"precipType";
NSString *const kFCPressure = @"pressure";
NSString *const kFCPressureError = @"pressureError";
NSString *const kFCSummary = @"summary";
NSString *const kFCSunriseTime = @"sunriseTime";
NSString *const kFCSunsetTime = @"sunsetTime";
NSString *const kFCTemperature = @"temperature";
NSString *const kFCTemperatureMax = @"temperatureMax";
NSString *const kFCTemperatureMaxError = @"temperatureMaxError";
NSString *const kFCTemperatureMaxTime = @"temperatureMaxTime";
NSString *const kFCTemperatureMin = @"temperatureMin";
NSString *const kFCTemperatureMinError = @"temperatureMinError";
NSString *const kFCTemperatureMinTime = @"temperatureMinTime";
NSString *const kFCTime = @"time";
NSString *const kFCVisibility = @"visibility";
NSString *const kFCVisibilityError = @"visibilityError";
NSString *const kFCWindBearing = @"windBearing";
NSString *const kFCWindSpeed = @"windSpeed";
NSString *const kFCWindSpeedError = @"windSpeedError";

// Names used for weather icons
NSString *const kFCIconClearDay = @"clear-day";
NSString *const kFCIconClearNight = @"clear-night";
NSString *const kFCIconRain = @"rain";
NSString *const kFCIconSnow = @"snow";
NSString *const kFCIconSleet = @"sleet";
NSString *const kFCIconWind = @"wind";
NSString *const kFCIconFog = @"fog";
NSString *const kFCIconCloudy = @"cloudy";
NSString *const kFCIconPartlyCloudyDay = @"partly-cloudy-day";
NSString *const kFCIconPartlyCloudyNight = @"partly-cloudy-night";
NSString *const kFCIconHail = @"hail";
NSString *const kFCIconThunderstorm = @"thunderstorm";
NSString *const kFCIconTornado = @"tornado";
NSString *const kFCIconHurricane = @"hurricane";

@interface Forecastr ()
{
    
}
@end

@implementation Forecastr

@synthesize apiKey = _apiKey;
@synthesize units = _units;
@synthesize callback = _callback;

# pragma mark - Singleton Methods

+ (id)sharedManager
{
    static Forecastr *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    if (self = [super init]) {
        // Init code here
        
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

# pragma mark - Instance Methods

// Requests the specified forecast for the given location and optional time
- (void)getForecastForLatitude:(double)lat
                     longitude:(double)lon
                          time:(NSNumber *)time
                    exclusions:(NSArray *)exclusions
                       success:(void (^)(id JSON))success
                       failure:(void (^)(NSError *error, id response))failure
{
    // Check if we have an API key set
    [self checkForAPIKey];
    
    // Generate the URL string based on the passed in params
    NSString *urlString = [NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f", self.apiKey, lat, lon];
    if (time) urlString = [urlString stringByAppendingFormat:@",%.0f", [time doubleValue]];
    if (exclusions) urlString = [urlString stringByAppendingFormat:@"?exclude=%@", [self stringForExclusions:exclusions]];
    if (self.units) urlString = [urlString stringByAppendingFormat:@"%@units=%@", exclusions ? @"&" : @"?", self.units];
    if (self.callback) urlString = [urlString stringByAppendingFormat:@"%@callback=%@", (exclusions || self.units) ? @"&" : @"?", self.callback];
    
    // Asynchronously kick off the GET request on the API for the generated URL
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    if (self.callback) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            success([[NSString alloc] initWithData:responseObject encoding:NSASCIIStringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            failure(error, operation);
        }];
        [operation start];
    } else {
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            success(JSON);
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){
            failure(error, JSON);
        }];
        [operation start];
    }
}

// Generates a string from an array of exclusions
- (NSString *)stringForExclusions:(NSArray *)exclusions
{
    __block NSString *exclusionString = @"";
    [exclusions enumerateObjectsUsingBlock:^(id exclusion, NSUInteger idx, BOOL *stop) {
        exclusionString = [exclusionString stringByAppendingFormat:idx == 0 ? @"%@" : @",%@", exclusion];
    }];
    return exclusionString;
}

// Returns a description based on the precicipation intensity
- (NSString *)descriptionForPrecipIntensity:(float)precipIntensity
{
    if (precipIntensity < 0.002) { return @"None"; }
    if (precipIntensity < 0.017) { return @"Very light"; }
    if (precipIntensity < 0.1) { return @"Light"; }
    if (precipIntensity < 0.4) { return @"Moderate"; }
    else return @"Heavy";
}

// Returns an image name based on the weather icon type
- (NSString *)imageNameForWeatherIconType:(NSString *)iconDescription
{
    if ([iconDescription isEqualToString:kFCIconClearDay]) { return @"clearDay.png"; }
    else if ([iconDescription isEqualToString:kFCIconClearNight]) { return @"clearNight.png"; }
    else if ([iconDescription isEqualToString:kFCIconRain]) { return @"rain.png"; }
    else if ([iconDescription isEqualToString:kFCIconSnow]) { return @"snow.png"; }
    else if ([iconDescription isEqualToString:kFCIconSleet]) { return @"sleet.png"; }
    else if ([iconDescription isEqualToString:kFCIconWind]) { return @"wind.png"; }
    else if ([iconDescription isEqualToString:kFCIconFog]) { return @"fog.png"; }
    else if ([iconDescription isEqualToString:kFCIconCloudy]) { return @"cloudy.png"; }
    else if ([iconDescription isEqualToString:kFCIconPartlyCloudyDay]) { return @"partlyCloudyDay.png"; }
    else if ([iconDescription isEqualToString:kFCIconPartlyCloudyNight]) { return @"partlyCloudyNight.png"; }
    else if ([iconDescription isEqualToString:kFCIconHail]) { return @"hail.png"; }
    else if ([iconDescription isEqualToString:kFCIconThunderstorm]) { return @"thunderstorm.png"; }
    else if ([iconDescription isEqualToString:kFCIconTornado]) { return @"tornado.png"; }
    else if ([iconDescription isEqualToString:kFCIconHurricane]) { return @"hurricane.png"; }
    else return @"cloudy.png"; // Default in case nothing matched
}

// Check for an empty API key
- (void)checkForAPIKey
{
    if (!self.apiKey || !self.apiKey.length) {
        [NSException raise:@"Forecastr" format:@"Your Forecast.io API key must be populated before you can access the API.", nil];
    }
}

// Returns a string with the JSON error message, if given, or the appropriate localized description for the NSError object
- (NSString *)messageForError:(NSError *)error withResponse:(id)response
{
    if ([response isKindOfClass:[NSDictionary class]]) {
        NSString *errorMsg = [response objectForKey:@"error"];
        return (errorMsg.length) ? errorMsg : error.localizedDescription;
    } else if ([response isKindOfClass:[AFHTTPRequestOperation class]]) {
        AFHTTPRequestOperation *operation = (AFHTTPRequestOperation *)response;
        int statusCode = operation.response.statusCode;
        NSString *errorMsg = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        return [errorMsg stringByAppendingFormat:@" (code %d)", statusCode];
    } else {
        return error.localizedDescription;
    }
}

@end
