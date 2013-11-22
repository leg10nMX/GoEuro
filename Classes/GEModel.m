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
		locationManager = [[CLLocationManager alloc] init];
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
        CLLocation* hintPosition = [[CLLocation alloc] initWithLatitude:[[geoPosition objectForKey:@"latitude"] doubleValue]
                                                              longitude:[[geoPosition objectForKey:@"longitude"] doubleValue]];

		[hint setValue:[NSNumber numberWithDouble: [currentLocation distanceFromLocation:hintPosition]]
										  forKey:@"distance"];
        [hintPosition release];
	}
}
-(NSArray*)sortByDistance:(NSArray*)hints
{
	NSSortDescriptor* sortByDistance = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
	return [hints sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortByDistance]];
}
@end
