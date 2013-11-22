//
//  GoEuroViewController.h
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GEModel;
@interface GoEuroViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{

}
@property (nonatomic, retain) IBOutlet UILabel* dateLabel;
@property (nonatomic, retain) IBOutlet UIView * originContainer;
@property (nonatomic, retain) IBOutlet UIView * destinationContainer;

@property (nonatomic, retain) IBOutlet UITableView * originHintsTable;
@property (nonatomic, retain) IBOutlet UITableView * destinationHintsTable;

@property (nonatomic, retain) IBOutlet UISearchBar* originSearchBar;
@property (nonatomic, retain) IBOutlet UISearchBar* destinationSearchBar;

@property (nonatomic, retain) UIView* datePickerContainer;
@property (nonatomic, retain) UIDatePicker* datePicker;
-(IBAction)selectDate;
-(IBAction)search;
@end

