//
//  AppDelegate.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSURLSessionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSURLSession *session;

@end

