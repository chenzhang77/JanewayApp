//
//  MessageViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2017-03-17.
//  Copyright © 2017 winemocol. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSLog(@"MessageViewController   =  %@", _titleMessage.text);
    
    
    _titleMessage.text = _titleString;
    //_detailMessage.text = _detailString;
    _timeMessage.text = _timeString;
    
 
    [_detailMessage sizeToFit];
    
}
-(void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
   
   
    NSLog(@"MessageViewController   =  %@", _titleMessage.text);
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
   // _detailMessage.contentOffset= CGPointMake(0, 0);
    
    _detailMessage.scrollView.bounces = NO;

    NSArray* foo = [_detailString componentsSeparatedByString: @"\n"];
    
    
    
    NSString* firstLine = [foo objectAtIndex: 0];
    
    NSString* SecondLine = [foo objectAtIndex: 1];
    
    NSString* ThirdLine = [foo objectAtIndex: 2];
    
    NSString* html = [NSString stringWithFormat:@"<html><body><p>%@</p><p>%@</p><p align=\"justify\">%@</p></body></html>",firstLine,SecondLine,ThirdLine];
    
    
    [_detailMessage loadHTMLString:html baseURL:NULL];
    
    [_detailMessage.scrollView setContentSize: CGSizeMake(_detailMessage.frame.size.width, _detailMessage.scrollView.contentSize.height)];
   
}

- (void)viewDidLayoutSubviews {
   // [_detailMessage setContentOffset:CGPointZero animated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
