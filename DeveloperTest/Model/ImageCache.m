//
//  ImageCache.m
//  DeveloperTest
//
//  Created by Ilya Maier on 08.12.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache ()

@property (retain) NSCache *cache;
@end

@implementation ImageCache

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [[[NSCache alloc] init] autorelease];
    }
    return self;
}

-(void)dealloc
{
    [_cache release];
    [super dealloc];
}

-(BOOL)isLoadedImageWithURL:(NSString *)imageURL
{
    UIImage *image = [self.cache objectForKey:imageURL];
    
    return image ? YES : NO;
}

-(UIImage*)imageWithImageURL:(NSString *)imageURL
{
    UIImage *image = [self.cache objectForKey:imageURL];

    if (!image) {
        
        NSURL* url = [NSURL URLWithString:imageURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url] ;
        image = [UIImage imageWithData:urlData];
        
        if (image) {
            [self.cache setObject:image forKey:imageURL];
        }
    }
    
    return image;
}

+(ImageCache *) sharedInstance
{
    static ImageCache *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageCache alloc] init];
    });

    return sharedInstance;
}

-(void)loadImageAsyncWithImageURL:(NSString *)imageURL andCompletionBlock:(ICCompletionBlock)handler;
{
    [imageURL retain];
    dispatch_queue_t fetcher = dispatch_queue_create("ImageCache fetcher", NULL);
    dispatch_async(fetcher, ^{
        UIImage *image = [self imageWithImageURL:imageURL];
        handler(image, imageURL);
        [imageURL release];
        });
}

@end