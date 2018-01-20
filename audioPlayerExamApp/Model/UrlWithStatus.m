//
//  UrlWithStatus.m
//  audioPlayerExamApp
//
//  Created by Gayane Shahbazyan on 1/20/18.
//  Copyright © 2018 Gayane Shahbazyan. All rights reserved.
//

#import "UrlWithStatus.h"

@implementation UrlWithStatus

-(instancetype)initWithUrlPath:(NSString*)url {
    self = [super init];
    if (self) {
        self.urlPath = url;
        self.status = 0;
    }
    return self;
}

@end
