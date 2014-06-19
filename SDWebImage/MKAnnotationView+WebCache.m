//
//  MKAnnotationView+WebCache.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 14/03/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "MKAnnotationView+WebCache.h"
#import "objc/runtime.h"
#import "UIView+WebCacheOperation.h"

static char imageURLKey;

@implementation MKAnnotationView (WebCache)

- (NSURL *)imageURL {
    return objc_getAssociatedObject(self, &imageURLKey);
}

- (void)loadImageWithURL:(NSURL *)url
{
    [self loadImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self loadImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self loadImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)loadImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self loadImageWithURL:url placeholderImage:nil options:0 completed:completedBlock];
}

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    [self loadImageWithURL:url placeholderImage:placeholder options:0 completed:completedBlock];
}

- (void)loadImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self cancelCurrentImageLoad];

    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = placeholder;

    if (url) {
        __weak MKAnnotationView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe(^{
                __strong MKAnnotationView *sself = wself;
                if (!sself) return;
                if (image) {
                    sself.image = image;
                }
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, url);
                }
            });
        }];
        [self setImageLoadOperation:operation forKey:@"MKAnnotationViewImage"];
    }
}

- (void)cancelCurrentImageLoad {
    [self cancelImageLoadOperationWithKey:@"MKAnnotationViewImage"];
}

@end


@implementation MKAnnotationView (WebCacheDeprecated)

- (void)setImageWithURL:(NSURL *)url {
    [self loadImageWithURL:url placeholderImage:nil options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder {
    [self loadImageWithURL:url placeholderImage:placeholder options:0 completed:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    [self loadImageWithURL:url placeholderImage:placeholder options:options completed:nil];
}

- (void)setImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadImageWithURL:url placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadImageWithURL:url placeholderImage:placeholder options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadImageWithURL:url placeholderImage:placeholder options:options completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

@end
