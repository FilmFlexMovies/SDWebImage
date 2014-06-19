/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+HighlightedWebCache.h"
#import "objc/runtime.h"

static char operationKey;

@implementation UIImageView (HighlightedWebCache)

- (void)loadHighlightedImageWithURL:(NSURL *)url {
    [self loadHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)loadHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options {
    [self loadHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)loadHighlightedImageWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self loadHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)loadHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    [self loadHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)loadHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    [self cancelCurrentImageLoad];

    if (url) {
        __weak UIImageView      *wself    = self;
        id<SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        objc_setAssociatedObject(self, &operationKey, operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

@end


@implementation UIImageView (HighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url {
    [self loadHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options {
    [self loadHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadHighlightedImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadHighlightedImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletedBlock)completedBlock {
    [self loadHighlightedImageWithURL:url options:0 progress:progressBlock completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

@end
