//
//  NSString+Helper.m
//  lexi
//
//  Created by FLYang on 2018/6/21.
//  Copyright © 2018年 taihuoniao. All rights reserved.
//

#import "NSString+Helper.h"

/// 缓存 NSDateFormatter
static NSDateFormatter *cachedFormatter = nil;
static NSString *const kLocaleIdentifier = @"zh_CN";

@implementation NSString (Helper)

#pragma mark - 是否空字符串
- (BOOL)isEmptyString {
    if (![self isKindOfClass:[NSString class]]) {
        return TRUE;
        
    } else if (self == nil) {
        return TRUE;
        
    } else if (!self) {
        // null object
        return TRUE;
        
    } else if (self == NULL) {
        // null object
        return TRUE;
        
    } else if ([self isEqualToString:@"NULL"]) {
        // null object
        return TRUE;
        
    } else if ([self isEqualToString:@"(null)"]) {
        return TRUE;
        
    } else {
        //  使用 whitespaceAndNewlineCharacterSet 删除周围的空白字符串
        //  然后在判断首位字符串是否为空
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return TRUE;
            
        } else {
            return FALSE;
        }
    }
}

#pragma mark - 时间戳转换Date
+ (NSString *)timeConversion:(NSString *)timeStampString initWithFormatterType:(Formatter)type {
    NSTimeInterval interval = [timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    switch (type) {
        case FormatterYear:
            [formatter setDateFormat:@"yyyy"];
            break;
        case FormatterMonth:
             [formatter setDateFormat:@"yyyy-MM"];
            break;
        case FormatterDay:
            [formatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case FormatterHour:
            [formatter setDateFormat:@"yyyy-MM-dd HH"];
            break;
        case FormatterMin:
             [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case FormatterSecond:
             [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
    }
    
    NSString *dateString = [formatter stringFromDate: date];
    return dateString;
}


#pragma mark - 判断是否是手机号
- (BOOL)checkTel {
    //^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    NSString *regex = @"^(13[\\d]{9}|15[\\d]{9}|18[\\d]{9}|14[5,7][\\d]{8}|17[\\d]{9}|16[\\d]{9})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

#pragma mark - 判断是否是邮箱
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

#pragma mark - 清空字符串中的空白字符
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - 返回沙盒中的文件路径
+ (NSString *)stringWithDocumentsPath:(NSString *)path {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    return [file stringByAppendingPathComponent:path];
}

#pragma mark - 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 根据返回的数字得到性别
+ (NSString *)getSexByNum:(NSNumber *)num {
    NSString *sex;
    int n = [num intValue];
    switch (n) {
        case 0:
            sex = @"保密";
            break;
        case 1:
            sex = @"男";
            break;
        case 2:
            sex = @"女";
            break;
            
        default:
            break;
    }
    return sex;
}

#pragma mark - 时间戳
+ (NSDateFormatter *)cachedFormatter {
    if (!cachedFormatter) {
        cachedFormatter = [[NSDateFormatter alloc] init] ;
        
        // 用标示符创建
        // NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:kLocaleIdentifier];
        // 一直保持在 cache 中，第一次用此方法实例化对象后，即使修改了本地化设定，也不改变
        NSLocale *locale = [NSLocale currentLocale];
        [cachedFormatter setLocale:locale];
        
        [cachedFormatter setDateStyle:NSDateFormatterMediumStyle];
        [cachedFormatter setTimeStyle:NSDateFormatterShortStyle];
        [cachedFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return cachedFormatter;
}

+ (NSString *)getTimestamp {
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:[NSTimeZone localTimeZone].name];
    [cachedFormatter setTimeZone:timeZone];
    
    NSString *timestamp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];

    return timestamp;
}

#pragma mark 转换时间戳格式
+ (NSString *)convertTimestamp:(NSInteger)time {
    NSString *timeStr = [cachedFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)time]];
    
    return timeStr;
}

#pragma mark 时间戳对比
+ (NSTimeInterval)comparisonStartTimestamp:(NSString *)startTime endTimestamp:(NSString *)endTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]];
    
    NSTimeInterval interval = [endDate timeIntervalSinceDate:startDate];
    
    return interval;
}

#pragma mark - 数据转json格式
+ (NSString *)jsonStringWithObject:(id)object {
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:(NSJSONWritingPrettyPrinted) error:nil];
    
    return [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
}

#pragma mark - 生成随机字符串
+ (NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:len];
    
    for (NSInteger idx = 0; idx < len; idx++) {
        NSInteger index = arc4random() % (letters.length - 1);
        char tempStr = [letters characterAtIndex:index];
        randomString = (NSMutableString *)[randomString stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return randomString;
}

#pragma mark - 照片获取本地路径转换
+ (NSString *)getImagePath:(UIImage *)image {
    NSString *filePath = nil;
    NSData *data = nil;
    
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString *DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *ImagePath = [[NSString alloc] initWithFormat:@"/theFirstImage.png"];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:ImagePath] contents:data attributes:nil];
    
    //得到选择后沙盒中图片的完整路径
    filePath = [[NSString alloc] initWithFormat:@"%@%@", DocumentsPath, ImagePath];
    return filePath;
}

#pragma mark - 获取文字的宽度
- (CGFloat)boundingSizeWidthWithFontSize:(NSInteger)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    
    CGSize retSize = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, fontSize + 1)
                                          options:NSStringDrawingUsesFontLeading
                                       attributes:attribute
                                          context:nil].size;
    return retSize.width;
}

@end
