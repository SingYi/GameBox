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

@property (nonatomic, strong) UILabel *label;

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
    
    NSURL *url = [NSURL URLWithString:imagePath];
    [self.contentView addSubview:self.label];
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                weakSelf.gifImageView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:data];
                
                weakSelf.gifImageView.alpha = 0.f;
                
                [UIView animateWithDuration:1.f animations:^{
                    
                    weakSelf.gifImageView.alpha = 1.f;
                }];
    
            });
        
        }];
        
    }];
    
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
        
        [self.contentView addSubview:_label];
    }
    return _label;
}







@end
