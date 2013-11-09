//
//  HttpsViewController.m
//  Https
//
//  Created by Michael Morris on 4/19/11.
//  Copyright 2011 Froggy Tech, LLC. All rights reserved.
//

#import "HttpsViewController.h"

@implementation HttpsViewController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	pageText.text = @"";
	client = [[HTTPClient alloc] init];
	[client setDelegate:self];
	[client addHost:@"www.arizonatreks.org"];
}


- (void)viewDidUnload
{
    urlEdit = nil;
    pageText = nil;
	statusLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark NSURLConnection

- (IBAction)doFetch:(id)sender 
{
	[urlEdit resignFirstResponder];
	[pageText resignFirstResponder];
	pageText.text = @"";
	[client setUrl:[NSURL URLWithString:urlEdit.text]];
	[client run];
}

-(void)client:(HTTPClient*)http didcompleteRequestWithData:(NSData*)data
{
	statusLabel.text = @"Request complete";
	NSString* body = [http dataAsString];
	pageText.text = body;
}

-(void)client:(HTTPClient*)client didReceiveError:(NSError*)err
{
	statusLabel.text = @"Error";
	pageText.text = [err description];
}

-(void)client:(HTTPClient*)client didReceiveStatus:(NSString*)status
{
	statusLabel.text = status;
}




@end
