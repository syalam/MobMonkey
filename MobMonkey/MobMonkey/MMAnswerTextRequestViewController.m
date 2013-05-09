//
//  MMAnswerTextRequestViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 12/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAnswerTextRequestViewController.h"

@interface MMAnswerTextRequestViewController ()

@end

@implementation MMAnswerTextRequestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Answer Text Request";
    // Do any additional setup after loading the view from its nib.
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction Methods
- (IBAction)submitButtonTapped:(id)sender {
    if (textView.text.length > 0) {
        [SVProgressHUD showWithStatus:@"Submitting response"];
        NSMutableDictionary* params = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                                       textView.text, @"text",
                                       @"text/plain", @"contentType",
                                       [NSNumber numberWithInt:0], @"requestType",
                                       [_requestObject valueForKey:@"requestId"], @"requestId", nil];
        NSLog(@"%@", params);
        [MMAPI fulfillRequest:@"text" params:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"Response submitted"];
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
            if (operation.responseData) {
                NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                [SVProgressHUD showErrorWithStatus:[response valueForKey:@"description"]];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"Unable to submit response at this time. Please try again later"];
            }
            NSLog(@"ERROR: %@", error);
        }];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Please enter a text response before proceeding" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText {
    
    NSString* newText = [_textView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    if([newText length] > 100)
    {
        return NO; // can't enter more text
    }
    else
        return YES; // let the textView know that it should handle the inserted text
}

@end
