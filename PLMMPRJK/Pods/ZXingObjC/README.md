ZXingObjC
=========

ZXingObjC is a full Objective-C port of [ZXing](https://github.com/zxing/zxing) ("Zebra Crossing"), a Java barcode image processing library. It is designed to be used on both iOS devices and in Mac applications.

The following barcodes are currently supported for both encoding and decoding:

* UPC-A and UPC-E
* EAN-8 and EAN-13
* Code 39
* Code 93 (not implemented yet)
* Code 128
* ITF
* Codabar
* RSS-14 (all variants)
* QR Code
* Data Matrix
* Aztec ('beta' quality)
* PDF 417 ('alpha' quality)

ZXingObjC currently has feature parity with ZXing version 3.0.

## Requirements

ZXingObjC requires Xcode 5, targeting either iOS 6.0 and above, or Mac OS X 10.8 Mountain Lion and above.

## Usage

Encoding:

```objc
NSError *error = nil;
ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
ZXBitMatrix* result = [writer encode:@"A string to encode"
                              format:kBarcodeFormatQRCode
                               width:500
                              height:500
                               error:&error];
if (result) {
  CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];

  // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
} else {
  NSString *errorMessage = [error localizedDescription];
}
```

Decoding:

```objc
CGImageRef imageToDecode;  // Given a CGImage in which we are looking for barcodes

ZXLuminanceSource *source = [[[ZXCGImageLuminanceSource alloc] initWithCGImage:imageToDecode] autorelease];
ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];

NSError *error = nil;

// There are a number of hints we can give to the reader, including
// possible formats, allowed lengths, and the string encoding.
ZXDecodeHints *hints = [ZXDecodeHints hints];

ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
ZXResult *result = [reader decode:bitmap
                            hints:hints
                            error:&error];
if (result) {
  // The coded result as a string. The raw data can be accessed with
  // result.rawBytes and result.length.
  NSString *contents = result.text;

  // The barcode format, such as a QR code or UPC-A
  ZXBarcodeFormat format = result.barcodeFormat;
} else {
  // Use error to determine why we didn't get a result, such as a barcode
  // not being found, an invalid checksum, or a format inconsistency.
}
```

## Installation

#### CocoaPods

The recommended way to install ZXingObjC is with [CocoaPods](http://cocoapods.org), a dependency mananger for Objective-C projects. After installing CocoaPods just add ZXingObjC to your Podfile:

```ruby
platform :ios, '7.0'
pod 'ZXingObjC', '~> 3.2.0'
```

#### Carthage

Alternatively, ZXingObjC can be installed using [Carthage](https://github.com/Carthage/Carthage). After installing Carthage just add ZXingObjC to your Cartfile:

```ogdl
github "TheLevelUp/ZXingObjC" ~> 3.2.0
```

## Examples

ZXingObjC includes several example applications found in "examples" folder:

* BarcodeScanner - An iOS application that captures video from the camera, scans for barcodes and displays results on screen.
* BarcodeScannerOSX - An OS X application that captures video from the camera, scans for barcodes and displays results on screen.
* QrCodeTest - A basic QR code generator that accepts input, encodes it as a QR code, and displays it on screen.

## License

ZXingObjC is available under the [Apache 2.0 license](http://www.apache.org/licenses/LICENSE-2.0.html).
