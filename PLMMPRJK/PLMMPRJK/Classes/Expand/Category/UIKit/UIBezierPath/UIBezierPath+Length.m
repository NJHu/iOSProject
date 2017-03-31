#import "UIBezierPath+Length.h"

typedef struct BezierSubpath {
    CGPoint startPoint;
    CGPoint controlPoint1;
    CGPoint controlPoint2;
    CGPoint endPoint;
    CGFloat length;
    CGPathElementType type;
} BezierSubpath;

typedef void(^BezierSubpathEnumerator)(const CGPathElement *element);

static void bezierSubpathFunction(void *info, CGPathElement const *element) {
	BezierSubpathEnumerator block = (__bridge BezierSubpathEnumerator)info;
	block(element);
}

@implementation UIBezierPath (Length)

#pragma mark - Internal

- (void)enumerateSubpaths:(BezierSubpathEnumerator)enumeratorBlock
{
	CGPathApply(self.CGPath, (__bridge void *)enumeratorBlock, bezierSubpathFunction);
}

- (NSUInteger)countSubpaths
{
	__block NSUInteger count = 0;
	[self enumerateSubpaths:^(const CGPathElement *element) {
		if (element->type != kCGPathElementMoveToPoint) {
			count++;
		}
	}];
	if (count == 0) {
		return 1;
	}
	return count;
}

- (void)extractSubpaths:(BezierSubpath*)subpathArray
{
	__block CGPoint currentPoint = CGPointZero;
	__block NSUInteger i = 0;
	[self enumerateSubpaths:^(const CGPathElement *element) {
		
		CGPathElementType type = element->type;
		CGPoint *points = element->points;
		
		CGFloat subLength = 0.0f;
		CGPoint endPoint = CGPointZero;
		
		BezierSubpath subpath;
		subpath.type = type;
		subpath.startPoint = currentPoint;
		
		/*
		 *  All paths, no matter how complex, are created through a combination of these path elements.
		 */
		switch (type) {
			case kCGPathElementMoveToPoint:
				
				endPoint = points[0];
				
				break;
			case kCGPathElementAddLineToPoint:
				
				endPoint = points[0];
				
				subLength = linearLineLength(currentPoint, endPoint);
				
				break;
			case kCGPathElementAddQuadCurveToPoint:
				
				endPoint = points[1];
				CGPoint controlPoint = points[0];
				
				subLength = quadCurveLength(currentPoint, endPoint, controlPoint);
				
				subpath.controlPoint1 = controlPoint;
				
				break;
			case kCGPathElementAddCurveToPoint:
				
				endPoint = points[2];
				CGPoint controlPoint1 = points[0];
				CGPoint controlPoint2 = points[1];
				
				subLength = cubicCurveLength(currentPoint, endPoint, controlPoint1, controlPoint2);
				
				subpath.controlPoint1 = controlPoint1;
				subpath.controlPoint2 = controlPoint2;
				
				break;
			case kCGPathElementCloseSubpath:
			default:
				break;
		}
		
		subpath.length = subLength;
		subpath.endPoint = endPoint;
		
		if (type != kCGPathElementMoveToPoint) {
			subpathArray[i] = subpath;
			i++;
		}
		
		currentPoint = endPoint;
	}];
	if (i == 0) {
		subpathArray[0].length = 0.0f;
		subpathArray[0].endPoint = currentPoint;
	}
}

- (CGPoint)pointAtPercent:(CGFloat)t ofSubpath:(BezierSubpath)subpath {
	
	CGPoint p = CGPointZero;
	switch (subpath.type) {
		case kCGPathElementAddLineToPoint:
			p = linearBezierPoint(t, subpath.startPoint, subpath.endPoint);
			break;
		case kCGPathElementAddQuadCurveToPoint:
			p = quadBezierPoint(t, subpath.startPoint, subpath.controlPoint1, subpath.endPoint);
			break;
		case kCGPathElementAddCurveToPoint:
			p = cubicBezierPoint(t, subpath.startPoint, subpath.controlPoint1, subpath.controlPoint2, subpath.endPoint);
			break;
		default:
			break;
	}
	return p;
}

#pragma mark - Public API

- (CGFloat)length {
	
	NSUInteger subpathCount = [self countSubpaths];
	BezierSubpath subpaths[subpathCount];
	[self extractSubpaths:subpaths];
	
	CGFloat length = 0.0f;
	for (NSUInteger i = 0; i < subpathCount; i++) {
		length += subpaths[i].length;
	}
	return length;
}

- (CGPoint)pointAtPercentOfLength:(CGFloat)percent {
	
	if (percent < 0.0f) {
		percent = 0.0f;
	} else if (percent > 1.0f) {
		percent = 1.0f;
	}
	
	NSUInteger subpathCount = [self countSubpaths];
	BezierSubpath subpaths[subpathCount];
	[self extractSubpaths:subpaths];
    
	CGFloat length = 0.0f;
	for (NSUInteger i = 0; i < subpathCount; i++) {
		length += subpaths[i].length;
	}
	
    CGFloat pointLocationInPath = length * percent;
    CGFloat currentLength = 0;
    BezierSubpath subpathContainingPoint;
	for (NSUInteger i = 0; i < subpathCount; i++) {
		if (currentLength + subpaths[i].length >= pointLocationInPath) {
			subpathContainingPoint = subpaths[i];
			break;
		} else {
			currentLength += subpaths[i].length;
		}
	}
	
    CGFloat lengthInSubpath = pointLocationInPath - currentLength;
	if (subpathContainingPoint.length == 0) {
		return subpathContainingPoint.endPoint;
	} else {
		CGFloat t = lengthInSubpath / subpathContainingPoint.length;
		return [self pointAtPercent:t ofSubpath:subpathContainingPoint];
	}
}

#pragma mark - Math helpers

CGFloat linearLineLength(CGPoint fromPoint, CGPoint toPoint) {
    return sqrtf(powf(toPoint.x - fromPoint.x, 2) + powf(toPoint.y - fromPoint.y, 2));
}

CGFloat quadCurveLength(CGPoint fromPoint, CGPoint toPoint, CGPoint controlPoint) {
    int iterations = 100;
    CGFloat length = 0;
    
    for (int idx=0; idx < iterations; idx++) {
        float t = idx * (1.0 / iterations);
        float tt = t + (1.0 / iterations);
        
        CGPoint p = quadBezierPoint(t, fromPoint, controlPoint, toPoint);
        CGPoint pp = quadBezierPoint(tt, fromPoint, controlPoint, toPoint);
        
        length += linearLineLength(p, pp);
    }
    
    return length;
}

CGFloat cubicCurveLength(CGPoint fromPoint, CGPoint toPoint, CGPoint controlPoint1, CGPoint controlPoint2) {
    int iterations = 100;
    CGFloat length = 0;
    
    for (int idx=0; idx < iterations; idx++) {
        float t = idx * (1.0 / iterations);
        float tt = t + (1.0 / iterations);
        
        CGPoint p = cubicBezierPoint(t, fromPoint, controlPoint1, controlPoint2, toPoint);
        CGPoint pp = cubicBezierPoint(tt, fromPoint, controlPoint1, controlPoint2, toPoint);
        
        length += linearLineLength(p, pp);
    }
    return length;
}

CGPoint linearBezierPoint(float t, CGPoint start, CGPoint end) {
    CGFloat dx = end.x - start.x;
    CGFloat dy = end.y - start.y;
    
    CGFloat px = start.x + (t * dx);
    CGFloat py = start.y + (t * dy);
    
    return CGPointMake(px, py);
}

CGPoint quadBezierPoint(float t, CGPoint start, CGPoint c1, CGPoint end) {
    CGFloat x = QuadBezier(t, start.x, c1.x, end.x);
    CGFloat y = QuadBezier(t, start.y, c1.y, end.y);
    
    return CGPointMake(x, y);
}

CGPoint cubicBezierPoint(float t, CGPoint start, CGPoint c1, CGPoint c2, CGPoint end) {
    CGFloat x = CubicBezier(t, start.x, c1.x, c2.x, end.x);
    CGFloat y = CubicBezier(t, start.y, c1.y, c2.y, end.y);
    
    return CGPointMake(x, y);
}

/*
 *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
 */
float CubicBezier(float t, float start, float c1, float c2, float end) {
    CGFloat t_ = (1.0 - t);
    CGFloat tt_ = t_ * t_;
    CGFloat ttt_ = t_ * t_ * t_;
    CGFloat tt = t * t;
    CGFloat ttt = t * t * t;
    
    return start * ttt_
    + 3.0 *  c1 * tt_ * t
    + 3.0 *  c2 * t_ * tt
    + end * ttt;
}

/*
 *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
 */
float QuadBezier(float t, float start, float c1, float end) {
    CGFloat t_ = (1.0 - t);
    CGFloat tt_ = t_ * t_;
    CGFloat tt = t * t;
    
    return start * tt_
    + 2.0 *  c1 * t_ * t
    + end * tt;
}

@end
