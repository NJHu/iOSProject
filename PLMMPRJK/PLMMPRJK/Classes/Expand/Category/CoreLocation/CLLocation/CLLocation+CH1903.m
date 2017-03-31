//
//  CLLocation+CH1903.m
//  g7
//
//  Created by Jonas Schnelli on 22.04.10.
//  Copyright 2010 include7 AG. All rights reserved.
//
// check: http://github.com/jonasschnelli/CLLocation-CH1903

#import "CLLocation+CH1903.h"


@implementation CLLocation (CH1903)


- (id) initWithCH1903x:(double)x y:(double)y
{
    self = [self initWithLatitude:[CLLocation CHtoWGSlatWithX:x y:y] longitude:[CLLocation CHtoWGSlongWithX:x y:y]];
    if (self != nil) {
        
    }
    return self;
}


- (double)CH1903Y {
    return [CLLocation WGStoCHyWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
}

- (double)CH1903X {
    return [CLLocation WGStoCHxWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
}


+ (double)CHtoWGSlatWithX:(double)x y:(double)y {
    
    // Converts militar to civil and  to unit = 1000km
    // Axiliary values (% Bern)
    double y_aux = (y - 600000)/1000000.0;
    double x_aux = (x - 200000)/1000000.0;
    
    // Process lat
    double lat = 16.9023892
    +  3.238272 * x_aux
    -  0.270978 * pow(y_aux,2)
    -  0.002528 * pow(x_aux,2)
    -  0.0447   * pow(y_aux,2) * x_aux
    -  0.0140   * pow(x_aux,3);
    
    // Unit 10000" to 1 " and converts seconds to degrees (dec)
    lat = lat * 100/36.0;
    
    return lat;
    
}

// Convert CH y/x to WGS long
+ (double)CHtoWGSlongWithX:(double)x y:(double)y {
    
    // Converts militar to civil and  to unit = 1000km
    // Axiliary values (% Bern)
    double y_aux = (y - 600000)/1000000.0;
    double x_aux = (x - 200000)/1000000.0;
    
    // Process long
    double lng = 2.6779094
    + 4.728982 * y_aux
    + 0.791484 * y_aux * x_aux
    + 0.1306   * y_aux * pow(x_aux,2)
    - 0.0436   * pow(y_aux,3);
    
    // Unit 10000" to 1 " and converts seconds to degrees (dec)
    lng = lng * 100/36.0;
    
    return lng;
}



+ (double)WGStoCHyWithLatitude:(double)lat longitude:(double)lng {
    // Converts degrees dec to sex
    lat = [CLLocation decToSex:lat];
    lng = [CLLocation decToSex:lng];
    
    // Converts degrees to seconds (sex)
    lat = [CLLocation degToSec:lat];
    lng = [CLLocation degToSec:lng];
    
    // Axiliary values (% Bern)
    double lat_aux = (lat - 169028.66)/10000;
    double lng_aux = (lng - 26782.5)/10000;
    
    // Process Y
    double y = 600072.37  + 211455.93 * lng_aux  -  10938.51 * lng_aux * lat_aux -      0.36 * lng_aux * pow(lat_aux,2) -     44.54 * pow(lng_aux,3);
    
    return y;
    
}

+ (double)WGStoCHxWithLatitude:(double)lat longitude:(double)lng {
    // Converts degrees dec to sex
    lat = [CLLocation decToSex:lat];
    lng = [CLLocation decToSex:lng];
    
    // Converts degrees to seconds (sex)
    lat = [CLLocation degToSec:lat];
    lng = [CLLocation degToSec:lng];
    
    // Axiliary values (% Bern)
    double lat_aux = (lat - 169028.66)/10000.0;
    double lng_aux = (lng - 26782.5)/10000.0;
    
    // Process X
    double x = 200147.07  + 308807.95 * lat_aux  + 3745.25 * pow(lng_aux,2) +     76.63 * pow(lat_aux,2)-    194.56 * pow(lng_aux,2) * lat_aux+    119.79 * pow(lat_aux,3);
    
    return x;
}




// Convert DEC angle to SEX DMS
+ (double)decToSex:(double)angle {
    // Extract DMS
    int deg = (int) angle;
    int min = (int) ((angle-deg)*60);
    double sec = (((angle-deg)*60) - min) * 60;
    
    // Result in degrees sex (dd.mmss)
    return deg + min/100.0 + sec/10000.0;
}

+ (double)degToSec:(double)angle {
    // Extract DMS
    int deg = (int) angle;
    int min = (int) ((angle-deg)*100);
    double sec = (((angle-deg)*100.0) - min) * 100.0;
    
    // Result in degrees sex (dd.mmss)
    return sec + min*60.0 + deg*3600.0;
}

+ (double)sexToDec:(double)angle {
    // Extract DMS
    int deg = (int) angle;
    int min = (int) ((angle-deg)*100);
    double sec = (((angle-deg)*100.0) - min) * 100.0;
    
    // Result in degrees sex (dd.mmss)
    return deg + (sec/60.0 + min)/60.0;
}
@end