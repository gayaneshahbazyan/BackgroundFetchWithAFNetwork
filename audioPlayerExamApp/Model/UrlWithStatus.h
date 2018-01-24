//
//  UrlWithStatus.h
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlWithStatus : NSObject
// status = 0 loading
// status = 1 loaded
// status = -1 fail to load
// in perfect code I will keep it as a struct.
@property NSInteger status;
@property NSString *urlPath;
@property NSURL *savedPath;

-(instancetype)initWithUrlPath:(NSString*)url;
@end
