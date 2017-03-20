//
//  WebViewController.h
//  JanewayApp
//
//  Created by cz5670 on 2016-06-08.
//  Copyright © 2016 winemocol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *webFileName;

@end
