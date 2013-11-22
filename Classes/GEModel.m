//
//  GEModel.m
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GEModel.h"
#import "GEAPIClient.h"
#import "GEAPIRequest.h"

#import <CoreLocation/CoreLocation.h>

#define ToRad(deg) (deg*M_PI/180.0)

@interface GEModel() <CLLocationManagerDelegate>
-(void)calculateDistanceForHintArray:(NSArray*)hints;
-(void)getHintFor:(NSString*)query withCallback:(SEL)callback;
-(NSArray*)sortByDistance:(NSArray*)hints;
-(double)distanceOnEarthBetween:(CGPoint)origin and:(CGPoint)destination;
@end


@implementation GEModel 
{
    CLLocationManager* locationManager;
	CLLocation* currentLocation;
}
-(void)dealloc
{
    [_date release];
	[_originName release];
	[_destinationName release];
	[_originHints release];
	[_destinationHints release];
	[locationManager release];
	[currentLocation release];
	[super dealloc];
}
-(id)init
{
	if (self = [super init])
	{
		locationManager = [[[CLLocationManager alloc] init] autorelease];
		locationManager.delegate = self;
		locationManager.distanceFilter = kCLDistanceFilterNone;
		locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
		[locationManager startUpdatingLocation];
	}
	return self;
}
-(void)setOriginName:(NSString *)originName
{
    if (_originName!=originName) {
        id helper = _originName;
        _originName = [originName retain];
        [helper release];
    }
	[self getHintFor:originName withCallback:@selector(originHintsReceived:)];
}

-(void)setDestinationName:(NSString *)destinationName
{
    if (_destinationName!=destinationName) {
        id helper = _destinationName;
        _destinationName = [destinationName retain];
        [helper release];
    }
	[self getHintFor:destinationName withCallback:@selector(destinationHintsReceived:)];
}
-(void)getHintFor:(NSString*)query withCallback:(SEL)callback
{
	if ([query length]>0)
	{
		GEAPIRequest* request = [[GEAPIRequest alloc]
								 initWithQuery:query 
								 target:self 
								 selector:callback];
		GEAPIClient* client = [[GEAPIClient alloc] init];
		[client getLocationsForRequestInBackground:request];
		[request release];
		[client release];
	}
}
-(void) originHintsReceived:(NSDictionary *)hints
{
    self.originHints = [hints objectForKey:@"results"];
	[self calculateDistanceForHintArray:self.originHints];
    self.originHints = [self sortByDistance:self.originHints];
}
-(void) destinationHintsReceived:(NSDictionary *)hints
{
    self.destinationHints = [hints objectForKey:@"results"];
	[self calculateDistanceForHintArray:self.destinationHints];
    self.destinationHints = [self sortByDistance:self.destinationHints];
}
-(void)locationManager:(CLLocationManager*)manager didUpdateToLocation:(CLLocation*)newLocation fromLocation:(CLLocation*)oldLocation
{
	if (currentLocation!=nil)
		[currentLocation release];
	currentLocation=[newLocation retain];
	
	[manager stopUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
	[self locationManager:manager 
	  didUpdateToLocation:[locations lastObject] 
			 fromLocation:[locations objectAtIndex:0]];
}
-(void)calculateDistanceForHintArray:(NSDictionary*)hints
{
	for (NSDictionary* hint in hints) {
		NSDictionary* geoPosition = [hint objectForKey:@"geo_position"];
		CGPoint hintPosition = { 
			[[geoPosition objectForKey:@"longitude"] doubleValue],
			[[geoPosition objectForKey:@"latitude"] doubleValue]
		};
		CGPoint currentPosition = {
			currentLocation.coordinate.longitude,
			currentLocation.coordinate.latitude
		};
		[hint setValue:[NSNumber numberWithFloat:[self distanceOnEarthBetween:currentPosition and:hintPosition]] 
										  forKey:@"distance"];
	}
}
-(NSArray*)sortByDistance:(NSArray*)hints
{
	NSSortDescriptor* sortByDistance = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
	return [hints sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
}
-(double)distanceOnEarthBetween:(CGPoint)origin and:(CGPoint)destination
{
	double radium = 6371;
	double dLat = ToRad(destination.y - origin.y);
	double dLon = ToRad(destination.x - origin.x);
	
	double rLatOrig = ToRad(origin.y);
	double rLatDest = ToRad(destination.y);
	
	double a = sin(dLat/2) * sin(dLat/2) +
				sin(dLon/2) * sin(dLon/2) * cos(rLatOrig) * cos(rLatDest);
	double c = 2 * atan2(sqrt(a), sqrt(1-a));
	return c * (double)radium;
}
@end
