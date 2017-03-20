//
//  OnGoWebViewController.m
//  JanewayApp
//
//  Created by cz5670 on 2016-06-09.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import "OnGoWebViewController.h"

@interface OnGoWebViewController ()

@end

@implementation OnGoWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"Go";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:self.webFileName ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [_webView setScalesPageToFit:true];
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
