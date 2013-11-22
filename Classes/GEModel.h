//
//  GEModel.h
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocationManager, CLLocation;
@interface GEModel : NSObject {
}
@property (nonatomic,retain) NSDate*    date;
@property (nonatomic,retain) NSString*  originName;
@property (nonatomic,retain) NSString*  destinationName;

@property (nonatomic,retain) NSArray*   originHints;
@property (nonatomic,retain) NSArray*   destinationHints;
@end
