// TTTImageTransformers.m
//
// Copyright (c) 2012 - 2018 Mattt (https://mat.tt)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <TransformerKit/TTTImageTransformers.h>

#import <TransformerKit/NSValueTransformer+TransformerKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import <UIKit/UIKit.h>
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

static inline NSData * NSImageRepresentationWithType(NSImage *image, NSBitmapImageFileType type, NSDictionary *properties) {
    NSBitmapImageRep *bitmap = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0.0f, 0.0f, image.size.width, image.size.height)];
    return [bitmap representationUsingType:type properties:properties];
}

NS_ASSUME_NONNULL_END

#endif

NS_ASSUME_NONNULL_BEGIN

#if defined(UIKIT_EXTERN) || defined(_APPKITDEFINES_H)

NSValueTransformerName const TTTPNGRepresentationImageTransformerName = @"TTTPNGRepresentationImageTransformer";
NSValueTransformerName const TTTJPEGRepresentationImageTransformerName = @"TTTJPEGRepresentationImageTransformer";

#if __MAC_OS_X_VERSION_MIN_REQUIRED
NSValueTransformerName const TTTGIFRepresentationImageTransformerName = @"TTTGIFRepresentationImageTransformer";
NSValueTransformerName const TTTTIFFRepresentationImageTransformerName = @"TTTTIFFRepresentationImageTransformer";
#endif

@implementation TTTImageTransformers

+ (void)load {
    @autoreleasepool {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
        Class imageClass = [UIImage class];
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
        Class imageClass = [NSImage class];
#endif

        [NSValueTransformer registerValueTransformerWithName:TTTPNGRepresentationImageTransformerName transformedValueClass:imageClass returningTransformedValueWithBlock:^id(id value) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            return UIImagePNGRepresentation(value);
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
            return NSImageRepresentationWithType(value, NSPNGFileType, @{});
#endif
        } allowingReverseTransformationWithBlock:^id(id value) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            return [[imageClass alloc] initWithData:value scale:[[UIScreen mainScreen] scale]];
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
            return [[imageClass alloc] initWithData:value];
#endif
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTJPEGRepresentationImageTransformerName transformedValueClass:imageClass returningTransformedValueWithBlock:^id(id value) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            return UIImageJPEGRepresentation(value, kTTTJPEGRepresentationCompressionQuality);
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
            return NSImageRepresentationWithType(value, NSPNGFileType, [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:kTTTJPEGRepresentationCompressionQuality] forKey:NSImageCompressionFactor]);
#endif
        } allowingReverseTransformationWithBlock:^id(id value) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
            return [[imageClass alloc] initWithData:value scale:[[UIScreen mainScreen] scale]];
#elif __MAC_OS_X_VERSION_MIN_REQUIRED
            return [[imageClass alloc] initWithData:value];
#endif
        }];

#if __MAC_OS_X_VERSION_MIN_REQUIRED
        [NSValueTransformer registerValueTransformerWithName:TTTGIFRepresentationImageTransformerName transformedValueClass:imageClass returningTransformedValueWithBlock:^id(id value) {
            return NSImageRepresentationWithType(value, NSGIFFileType, @{});
        } allowingReverseTransformationWithBlock:^id(id value) {
            return [[imageClass alloc] initWithData:value];
        }];

        [NSValueTransformer registerValueTransformerWithName:TTTTIFFRepresentationImageTransformerName transformedValueClass:imageClass returningTransformedValueWithBlock:^id(id value) {
            return NSImageRepresentationWithType(value, NSTIFFFileType, @{});
        } allowingReverseTransformationWithBlock:^id(id value) {
            return [[imageClass alloc] initWithData:value];
        }];
#endif
    }
}

@end

#endif

NS_ASSUME_NONNULL_END
