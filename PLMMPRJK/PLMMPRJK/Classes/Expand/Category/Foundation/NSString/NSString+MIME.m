//
//  NSString+MIME.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/5/22.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import "NSString+MIME.h"

@implementation NSString (MIME)
/**
 *  @brief  根据文件url后缀 返回对应的MIMEType
 *
 *  @return MIMEType
 */
- (NSString *)MIMEType {
    return [[self class] MIMETypeForExtension:[self pathExtension]];
}

+ (NSString *)MIMETypeForExtension:(NSString *)extension {
    return [[self MIMEDict] valueForKey:[extension lowercaseString]];
}
/**
 *  @brief  常见MIME集合
 *
 *  @return 常见MIME集合
 */
+ (NSDictionary *)MIMEDict {
    NSDictionary * MIMEDict;
    // Lazy loads the MIME type dictionary.
    if (!MIMEDict) {
        
        // ???: Should I have these return an array of MIME types? The first element would be the preferred MIME type.
        
        // ???: Should I have a couple methods that return the MIME media type name and the MIME subtype name?
        
        // Values from http://www.w3schools.com/media/media_mimeref.asp
        // There are probably values missed, but this is a good start.
        // A few more have been added that weren't included on the original list.
        MIMEDict = [NSDictionary dictionaryWithObjectsAndKeys:
                    // Key      // Value
                    @"",        @"application/octet-stream",
                    @"323",     @"text/h323",
                    @"acx",     @"application/internet-property-stream",
                    @"ai",      @"application/postscript",
                    @"aif",     @"audio/x-aiff",
                    @"aifc",    @"audio/x-aiff",
                    @"aiff",    @"audio/x-aiff",
                    @"asf",     @"video/x-ms-asf",
                    @"asr",     @"video/x-ms-asf",
                    @"asx",     @"video/x-ms-asf",
                    @"au",      @"audio/basic",
                    @"avi",     @"video/x-msvideo",
                    @"axs",     @"application/olescript",
                    @"bas",     @"text/plain",
                    @"bcpio",   @"application/x-bcpio",
                    @"bin",     @"application/octet-stream",
                    @"bmp",     @"image/bmp",
                    @"c",       @"text/plain",
                    @"cat",     @"application/vnd.ms-pkiseccat",
                    @"cdf",     @"application/x-cdf",
                    @"cer",     @"application/x-x509-ca-cert",
                    @"class",   @"application/octet-stream",
                    @"clp",     @"application/x-msclip",
                    @"cmx",     @"image/x-cmx",
                    @"cod",     @"image/cis-cod",
                    @"cpio",    @"application/x-cpio",
                    @"crd",     @"application/x-mscardfile",
                    @"crl",     @"application/pkix-crl",
                    @"crt",     @"application/x-x509-ca-cert",
                    @"csh",     @"application/x-csh",
                    @"css",     @"text/css",
                    @"dcr",     @"application/x-director",
                    @"der",     @"application/x-x509-ca-cert",
                    @"dir",     @"application/x-director",
                    @"dll",     @"application/x-msdownload",
                    @"dms",     @"application/octet-stream",
                    @"doc",     @"application/msword",
                    @"docx",    @"application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                    @"dot",     @"application/msword",
                    @"dvi",     @"application/x-dvi",
                    @"dxr",     @"application/x-director",
                    @"eps",     @"application/postscript",
                    @"etx",     @"text/x-setext",
                    @"evy",     @"application/envoy",
                    @"exe",     @"application/octet-stream",
                    @"fif",     @"application/fractals",
                    @"flr",     @"x-world/x-vrml",
                    @"gif",     @"image/gif",
                    @"gtar",    @"application/x-gtar",
                    @"gz",      @"application/x-gzip",
                    @"h",       @"text/plain",
                    @"hdf",     @"application/x-hdf",
                    @"hlp",     @"application/winhlp",
                    @"hqx",     @"application/mac-binhex40",
                    @"hta",     @"application/hta",
                    @"htc",     @"text/x-component",
                    @"htm",     @"text/html",
                    @"html",    @"text/html",
                    @"htt",     @"text/webviewhtml",
                    @"ico",     @"image/x-icon",
                    @"ief",     @"image/ief",
                    @"iii",     @"application/x-iphone",
                    @"ins",     @"application/x-internet-signup",
                    @"isp",     @"application/x-internet-signup",
                    @"jfif",    @"image/pipeg",
                    @"jpe",     @"image/jpeg",
                    @"jpeg",    @"image/jpeg",
                    @"jpg",     @"image/jpeg",
                    @"js",      @"application/x-javascript",
                    @"json",    @"application/json",   // According to RFC 4627  // Also application/x-javascript text/javascript text/x-javascript text/x-json
                    @"latex",   @"application/x-latex",
                    @"lha",     @"application/octet-stream",
                    @"lsf",     @"video/x-la-asf",
                    @"lsx",     @"video/x-la-asf",
                    @"lzh",     @"application/octet-stream",
                    @"m",       @"text/plain",
                    @"m13",     @"application/x-msmediaview",
                    @"m14",     @"application/x-msmediaview",
                    @"m3u",     @"audio/x-mpegurl",
                    @"man",     @"application/x-troff-man",
                    @"mdb",     @"application/x-msaccess",
                    @"me",      @"application/x-troff-me",
                    @"mht",     @"message/rfc822",
                    @"mhtml",   @"message/rfc822",
                    @"mid",     @"audio/mid",
                    @"mny",     @"application/x-msmoney",
                    @"mov",     @"video/quicktime",
                    @"movie",   @"video/x-sgi-movie",
                    @"mp2",     @"video/mpeg",
                    @"mp3",     @"audio/mpeg",
                    @"mpa",     @"video/mpeg",
                    @"mpe",     @"video/mpeg",
                    @"mpeg",    @"video/mpeg",
                    @"mpg",     @"video/mpeg",
                    @"mpp",     @"application/vnd.ms-project",
                    @"mpv2",    @"video/mpeg",
                    @"ms",      @"application/x-troff-ms",
                    @"mvb",     @"	application/x-msmediaview",
                    @"nws",     @"message/rfc822",
                    @"oda",     @"application/oda",
                    @"p10",     @"application/pkcs10",
                    @"p12",     @"application/x-pkcs12",
                    @"p7b",     @"application/x-pkcs7-certificates",
                    @"p7c",     @"application/x-pkcs7-mime",
                    @"p7m",     @"application/x-pkcs7-mime",
                    @"p7r",     @"application/x-pkcs7-certreqresp",
                    @"p7s",     @"	application/x-pkcs7-signature",
                    @"pbm",     @"image/x-portable-bitmap",
                    @"pdf",     @"application/pdf",
                    @"pfx",     @"application/x-pkcs12",
                    @"pgm",     @"image/x-portable-graymap",
                    @"pko",     @"application/ynd.ms-pkipko",
                    @"pma",     @"application/x-perfmon",
                    @"pmc",     @"application/x-perfmon",
                    @"pml",     @"application/x-perfmon",
                    @"pmr",     @"application/x-perfmon",
                    @"pmw",     @"application/x-perfmon",
                    @"png",     @"image/png",
                    @"pnm",     @"image/x-portable-anymap",
                    @"pot",     @"application/vnd.ms-powerpoint",
                    @"vppm",    @"image/x-portable-pixmap",
                    @"pps",     @"application/vnd.ms-powerpoint",
                    @"ppt",     @"application/vnd.ms-powerpoint",
                    @"pptx",    @"application/vnd.openxmlformats-officedocument.presentationml.presentation",
                    @"prf",     @"application/pics-rules",
                    @"ps",      @"application/postscript",
                    @"pub",     @"application/x-mspublisher",
                    @"qt",      @"video/quicktime",
                    @"ra",      @"audio/x-pn-realaudio",
                    @"ram",     @"audio/x-pn-realaudio",
                    @"ras",     @"image/x-cmu-raster",
                    @"rgb",     @"image/x-rgb",
                    @"rmi",     @"audio/mid",
                    @"roff",    @"application/x-troff",
                    @"rtf",     @"application/rtf",
                    @"rtx",     @"text/richtext",
                    @"scd",     @"application/x-msschedule",
                    @"sct",     @"text/scriptlet",
                    @"setpay",  @"application/set-payment-initiation",
                    @"setreg",  @"application/set-registration-initiation",
                    @"sh",      @"application/x-sh",
                    @"shar",    @"application/x-shar",
                    @"sit",     @"application/x-stuffit",
                    @"snd",     @"audio/basic",
                    @"spc",     @"application/x-pkcs7-certificates",
                    @"spl",     @"application/futuresplash",
                    @"src",     @"application/x-wais-source",
                    @"sst",     @"application/vnd.ms-pkicertstore",
                    @"stl",     @"application/vnd.ms-pkistl",
                    @"stm",     @"text/html",
                    @"svg",     @"image/svg+xml",
                    @"sv4cpio", @"application/x-sv4cpio",
                    @"sv4crc",  @"application/x-sv4crc",
                    @"swf",     @"application/x-shockwave-flash",
                    @"t",       @"application/x-troff",
                    @"tar",     @"application/x-tar",
                    @"tcl",     @"application/x-tcl",
                    @"tex",     @"application/x-tex",
                    @"texi",    @"application/x-texinfo",
                    @"texinfo", @"application/x-texinfo",
                    @"tgz",     @"application/x-compressed",
                    @"tif",     @"image/tiff",
                    @"tiff",    @"image/tiff",
                    @"tr",      @"application/x-troff",
                    @"trm",     @"application/x-msterminal",
                    @"tsv",     @"text/tab-separated-values",
                    @"txt",     @"text/plain",
                    @"uls",     @"text/iuls",
                    @"ustar",   @"application/x-ustar",
                    @"vcf",     @"text/x-vcard",
                    @"vrml",    @"x-world/x-vrml",
                    @"wav",     @"audio/x-wav",
                    @"wcm",     @"application/vnd.ms-works",
                    @"wdb",     @"application/vnd.ms-works",
                    @"wks",     @"application/vnd.ms-works",
                    @"wmf",     @"application/x-msmetafile",
                    @"wps",     @"application/vnd.ms-works",
                    @"wri",     @"application/x-mswrite",
                    @"wrl",     @"x-world/x-vrml",
                    @"wrz",     @"x-world/x-vrml",
                    @"xaf",     @"x-world/x-vrml",
                    @"xbm",     @"image/x-xbitmap",
                    @"xla",     @"application/vnd.ms-excel",
                    @"xlc",     @"application/vnd.ms-excel",
                    @"xlm",     @"application/vnd.ms-excel",
                    @"xls",     @"application/vnd.ms-excel",
                    @"xlsx",    @"application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                    @"xlt",     @"application/vnd.ms-excel",
                    @"xlw",     @"application/vnd.ms-excel",
                    @"xml",     @"text/xml",   // According to RFC 3023   // Also application/xml
                    @"xof",     @"x-world/x-vrml",
                    @"xpm",     @"image/x-xpixmap",
                    @"xwd",     @"image/x-xwindowdump",
                    @"z",       @"application/x-compress",
                    @"zip",     @"application/zip",
                    nil];
    }
    
    return MIMEDict;
}
@end
