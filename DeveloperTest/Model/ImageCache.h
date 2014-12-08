//
//  Store.h
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

typedef void(^ICCompletionBlock)(UIImage * image, NSString *imageURL);

@interface ImageCache : NSObject

+(ImageCache *) sharedInstance;

-(BOOL)isLoadedImageWithURL:(NSString *)imageURL;

-(UIImage *)imageWithImageURL:(NSString *)imageURL;

-(void)loadImageAsyncWithImageURL:(NSString *)imageURL andCompletionBlock:(ICCompletionBlock)handler;

@end
