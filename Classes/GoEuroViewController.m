//
//  GoEuroViewController.m
//  GoEuro
//
//  Created by nukoso on 11/21/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GoEuroViewController.h"
#import "GEModel.h"
@interface GoEuroViewController ()
@property (nonatomic, retain) GEModel* model;
@end

@implementation GoEuroViewController

- (void)dealloc {
    [self.model removeObserver:self forKeyPath:@"originHints"];
    [self.model removeObserver:self forKeyPath:@"destinationHints"];
    [self.model removeObserver:self forKeyPath:@"date"];
    
	[_model release];
	[_originContainer release];
	[_destinationContainer release];
	[_originHintsTable release];
	[_destinationHintsTable release];
	[_originSearchBar release];
	[_destinationSearchBar release];
    [super dealloc];
}
-(void)initialize {
    self.model=[[[GEModel alloc] init] autorelease];
    [self.model addObserver:self forKeyPath:@"originHints" options:0 context:nil];
    [self.model addObserver:self forKeyPath:@"destinationHints" options:0 context:nil];
    [self.model addObserver:self forKeyPath:@"date" options:0 context:nil];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initialize];
    }
    return self;
}
-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return  self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqualToString:@"originHints"])
	{
		[self.originHintsTable reloadData];
	} else if ([keyPath isEqualToString:@"destinationHints"])
	{
		[self.destinationHintsTable reloadData];
	} else if ([keyPath isEqualToString:@"date"])
    {
        [self displayDate:self.model.date];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.superview.frame.size.height>searchBar.frame.size.height)return;
	[UIView beginAnimations:@"switchInputs" context:nil];
	[UIView setAnimationDuration:0.5];
	CGRect originFrame = self.originContainer.frame;
	CGRect destinationFrame = self.destinationContainer.frame;
	
	CGFloat helper = originFrame.size.height;
	originFrame.size.height = destinationFrame.size.height;
	destinationFrame.size.height = helper;
	destinationFrame.origin.y = originFrame.origin.y + originFrame.size.height;
	
	self.originContainer.frame=originFrame;
	self.destinationContainer.frame=destinationFrame;
	
	[UIView commitAnimations];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (self.originSearchBar == searchBar)
    {
        self.model.originName = searchText;
    }
    else
    {
        self.model.destinationName = searchText;
    }
}
-(void) discardDatePicker
{
    self.model.date = self.datePicker.date;
    CGRect frame = self.datePicker.frame;
    frame.origin.x -= frame.size.width;
    __block GoEuroViewController* _self = self;
    [UIView animateWithDuration:0.5 animations:^{
        _self.datePickerContainer.frame = frame;
    } completion:^(BOOL finished) {
        [_self.datePickerContainer removeFromSuperview];
        _self.datePickerContainer=nil;
    }];

}
-(IBAction)selectDate
{
    if (self.datePickerContainer != nil) return;
    CGRect originFrame = self.originContainer.frame;
    CGRect destinationFrame = self.destinationContainer.frame;
    CGRect viewFrame = CGRectMake(originFrame.size.width, originFrame.origin.y,
                                  originFrame.size.width, originFrame.size.height + destinationFrame.size.height);
    
    UIView* datePickerContainer = [[UIView alloc] initWithFrame:viewFrame];
    datePickerContainer.backgroundColor=[UIColor whiteColor];
    UIButton* discardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [discardButton setTitle:@"Done!" forState:UIControlStateNormal];
    [discardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [discardButton addTarget:self action:@selector(discardDatePicker) forControlEvents:UIControlEventTouchUpInside];
    [datePickerContainer addSubview:discardButton];
    
    self.datePickerContainer = datePickerContainer;
    [datePickerContainer release];
    
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, discardButton.frame.size.height, originFrame.size.width, originFrame.size.height-discardButton.frame.size.height)];
    picker.datePickerMode = UIDatePickerModeDate;
    [datePickerContainer addSubview:picker];
    self.datePicker = picker;
    [picker release];
    
    [self.view addSubview: datePickerContainer];
    [self.view bringSubviewToFront:datePickerContainer];
    
    viewFrame.origin.x = originFrame.origin.x;
    [UIView animateWithDuration:0.5 animations:^{
        datePickerContainer.frame = viewFrame;
    }];
}
-(IBAction)search
{
	UIAlertView* alert = [[UIAlertView alloc] 
						  initWithTitle:@"Sorry" 
						  message:@"Search is not yet implemented" 
						  delegate:nil 
						  cancelButtonTitle:@"OK" 
						  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(void)displayDate:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.dateLabel.text=[formatter stringFromDate:date];
    [formatter release];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.model.date = [NSDate date];
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (tableView==self.originHintsTable)
	{
		return [self.model.originHints count];
	}else
	{
		return [self.model.destinationHints count];
	}
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString* cellIdentifier=@"hintCell";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
	}
	
	NSDictionary *hint = nil;
	if (tableView == self.originHintsTable)
	{
		hint = [self.model.originHints objectAtIndex:[indexPath row]];
	} else
	{
		hint = [self.model.destinationHints objectAtIndex:[indexPath row]];
	}
	cell.textLabel.text=[hint objectForKey:@"name"];
	return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView == self.originHintsTable)
	{
		NSDictionary *hint = nil;
		hint = [self.model.originHints objectAtIndex:[indexPath row]];
		self.originSearchBar.text=[hint objectForKey:@"name"];
		[self.originSearchBar resignFirstResponder];
	} else 
	{
		NSDictionary *hint = nil;
		hint = [self.model.destinationHints objectAtIndex:[indexPath row]];
		self.destinationSearchBar.text=[hint objectForKey:@"name"];
		[self.destinationSearchBar resignFirstResponder];
	}
}
@end
