//
//  GoEuroAppDelegate.h
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoEuroViewController;

@interface GoEuroAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GoEuroViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GoEuroViewController *viewController;

@end

