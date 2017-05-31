//
//  GifTableViewCell.m
//  GameBox
//
//  Created by 石燚 on 2017/5/27.
//  Copyright © 2017年 SingYi. All rights reserved.
//

#import "GifTableViewCell.h"


#import "FLAnimatedImage.h"
#import "UIImageView+WebCache.h"

@interface GifTableViewCell ()


@end


@implementation GifTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setGifUrl:(NSString *)gifUrl {
    _gifUrl = gifUrl;
    
    NSString *imagePath = [NSString stringWithFormat:IMAGEURL,_gifUrl];

    //先从缓存中找 GIF 图,如果有就加载,没有就请求
    NSData *gifImageData = [self imageDataFromDiskCacheWithKey:[imagePath stringByAppendingString:@"gif"]];
    
    
    if (gifImageData) {
        
        self.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:gifImageData];
        [self.label removeFromSuperview];
    } else {
 
        NSURL *url = [NSURL URLWithString:imagePath];
        
        WeakSelf;
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = receivedSize * 1.f / expectedSize * 1.f;
                
                self.label.text = [NSString stringWithFormat:@"加载中 %.2lf %%",progress * 100];
                self.label.backgroundColor = [UIColor blackColor];
                if (progress >= 1) {
                    [self.label removeFromSuperview];
                }
            });
            
            
            
        }  completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            [[[SDWebImageManager sharedManager] imageCache] storeImage:image forKey:url.absoluteString toDisk:YES completion:^{
                
//                [[[SDWebImageManager sharedManager] imageCache] storeImage:image imageData:data forKey:imagePath toDisk:YES completion:nil];
                
                //缓存 gif 图
                [[[SDWebImageManager sharedManager] imageCache] storeImageDataToDisk:data forKey:[imagePath stringByAppendingString:@"gif"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakSelf.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                    
                    //                weakSelf.gifImageView.alpha = 0.f;
                    
                    //                [UIView animateWithDuration:1.f animations:^{
                    //
                    //                    weakSelf.gifImageView.alpha = 1.f;
                    //
                    //
                    //                }];
                    
                    syLog(@"height === %lf",weakSelf.gifImageView.image.size.height);
                    syLog(@"width === %lf",weakSelf.gifImageView.image.size.width);
                    syLog(@"screen_width ==== %lf",kSCREEN_WIDTH);
                    syLog(@"cell_height === %lf",kSCREEN_WIDTH * 0.618);
                    syLog(@"图片大小 ======== %lf",data.length / 1024.f / 1024.f);
                });
                
            }];
            
        }];

    }
    
    
}


- (FLAnimatedImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = [[FLAnimatedImageView alloc] init];
        [self.contentView addSubview:_gifImageView];
    }
    return _gifImageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 44)];
        
        _label.center = CGPointMake(kSCREEN_WIDTH / 2, 50);
        
        _label.textAlignment = NSTextAlignmentCenter;
        
        _label.backgroundColor = [UIColor blackColor];
        
        _label.textColor = [UIColor whiteColor];
        
        _label.text = @"GIF";
        
        [self.contentView addSubview:_label];
    }
    return _label;
}

- (NSData *)imageDataFromDiskCacheWithKey:(NSString *)key {
    NSString *path = [[[SDWebImageManager sharedManager] imageCache] defaultCachePathForKey:key];
    return [NSData dataWithContentsOfFile:path];
}








@end
