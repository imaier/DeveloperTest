//
//  ImageCache.m
//  StoreViewer
//
//  Created by Ilya Maier on 29.10.14.
//  Copyright (c) 2014 Mera. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache ()

@property (nonatomic, strong) NSMutableDictionary *cache;
@property (nonatomic, strong) NSLock *dataLock;
@end

@implementation ImageCache

-(NSMutableDictionary *)cache
{
    if (!_cache) {
        _cache = [[NSMutableDictionary alloc] init];
    }
    return _cache;
}

-(NSLock *)dataLock
{
    if (!_dataLock) {
        _dataLock = [[NSLock alloc] init];
    }
    return _dataLock;
}

-(BOOL)isLoadedImageWithURL:(NSString *)imageURL
{
    [self.dataLock lock];
    
    UIImage *image = [self.cache valueForKey:imageURL];
    
    [self.dataLock unlock];

    return image ? YES : NO;
}

-(UIImage*)imageWithImageURL:(NSString *)imageURL
{
    [self.dataLock lock];

    UIImage *image = [self.cache valueForKey:imageURL];

    if (!image) {
        
        NSURL* url = [NSURL URLWithString:imageURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:urlData];
        
        [self.cache setObject:image forKey:imageURL];
    }
    [self.dataLock unlock];
    
    return image;
}

+(ImageCache *) sharedInstance
{
    //  Static local predicate must be initialized to 0
    static ImageCache *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImageCache alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

-(void)loadImageAsyncWithImageURL:(NSString *)imageURL andCompletionBlock:(ICCompletionBlock)handler;
{
    dispatch_queue_t fetcher = dispatch_queue_create("ImageCache fetcher", NULL);
    dispatch_async(fetcher, ^{
        UIImage *image = [self imageWithImageURL:imageURL];
        handler(image, imageURL);
        });
}

@end