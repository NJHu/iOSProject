//
//  NSDecimalNumber+CalculatingByString.m
//  NSDecimalNumber+StringCalculation
//
//  Created by Adi Li on 11/5/14.
//  Copyright (c) 2014 Adi Li. All rights reserved.
//

#import "NSDecimalNumber+CalculatingByString.h"

typedef enum {
    tokenTypeFirstLoop = -1,
    tokenTypeEndOfEquation,
    tokenTypeNumber,
    tokenTypeText,
    tokenTypeOperator,
    tokenTypeUnknown = 99,
} tokenType;

tokenType typeForCharacter (const unichar character);
NSInteger precedenceForOperator (NSString *operator);
NSInteger precedenceForOperatorChar (const unichar operator);
NSArray* tokenizeEquation (NSString *equation, NSDictionary *numbers);
NSArray* RPNFromTokens (NSArray *tokens);

static NSArray *operators;
void initOperators();

@implementation NSDecimalNumber (CalculatingByString)

+ (NSDecimalNumber *)decimalNumberWithEquation:(NSString *)equation decimalNumbers:(NSDictionary *)numbers
{
    NSDecimalNumber *left, *right;
    
    NSMutableArray *equationStack = [RPNFromTokens(tokenizeEquation(equation, numbers)) mutableCopy];
    NSMutableArray *resultArray = [@[] mutableCopy];
    
    NSString *token;
    
    initOperators();
    
    do {
        token = [equationStack firstObject];
        if ([operators indexOfObject:token] != NSNotFound) {
            right = [NSDecimalNumber decimalNumberWithString:[resultArray lastObject]];
            [resultArray removeLastObject];
            left = [NSDecimalNumber decimalNumberWithString:[resultArray lastObject]];
            [resultArray removeLastObject];
            
            assert(![left isEqual:[NSDecimalNumber notANumber]]);
            assert(![right isEqual:[NSDecimalNumber notANumber]]);
            
            if ([@"+" isEqualToString:token]) {
                token = [[left decimalNumberByAdding:right] stringValue];
                
            } else if ([@"-" isEqualToString:token]) {
                token = [[left decimalNumberBySubtracting:right] stringValue];
                
            } else if ([@"*" isEqualToString:token]) {
                token = [[left decimalNumberByMultiplyingBy:right] stringValue];
                
            } else if ([@"/" isEqualToString:token]) {
                token = [[left decimalNumberByDividingBy:right] stringValue];
                
            } else if ([@"^" isEqualToString:token]) {
                token = [[left decimalNumberByRaisingToPower:right.integerValue] stringValue];
                
            }
        }
        
        [resultArray addObject:token];
        [equationStack removeObjectAtIndex:0];
        
    } while (equationStack.count > 0);
    
    
    
    return [NSDecimalNumber decimalNumberWithString:[resultArray objectAtIndex:0]];
}

@end


#pragma mark - helper functions

// find the token type for a character
tokenType typeForCharacter (const unichar character)
{
    if ((character >= '0' && character <= '9') || character == '.') {
        return tokenTypeNumber;
        
    } else if ((character >= 'A' && character <= 'z') || character == '_') {
        return tokenTypeText;
        
    } else if (character == '+' || character == '-' || character == '*' || character == '/' ||
               character == '(' || character == ')' || character == '^')
    {
        return tokenTypeOperator;
        
    } else if (character == 0) {
        return tokenTypeEndOfEquation;
    }
    
#ifdef DEBUG
    NSLog(@"Invalid Operator: %@ is not a valid character." ,[NSString stringWithCharacters:&character length:1]);
    exit(EXIT_FAILURE);
#endif
    
    return tokenTypeUnknown;
}

// find the precedence for a operator
NSInteger precedenceForOperator (NSString *operator)
{
    unichar operatorChar = operator.UTF8String[0];
    
    return precedenceForOperatorChar(operatorChar);
}

// find the precedence for a operator
NSInteger precedenceForOperatorChar (const unichar operator)
{
    switch (operator) {
        case '+':
        case '-':
            return 2;
            
        case '*':
        case '/':
            return 3;
            
        case '^':
            return 4;
            
        default:
            return 0;
    }
}

// split the equation into token (e.g. @[@"1", @"+", @"2", @"*", @"3"])
NSArray* tokenizeEquation (NSString *equation, NSDictionary *numbers)
{
    unichar equationChars[equation.length + 1], tempChars[equation.length + 1];
    
    tokenType lastTokenType = tokenTypeFirstLoop, currentTokenType = tokenTypeFirstLoop;
    
    NSUInteger tempCharsLength = 0;
    
    NSMutableArray *equationStack = [@[] mutableCopy];
    
    equation = [equation stringByReplacingOccurrencesOfString:@" " withString:@""];
    [equation getCharacters:equationChars];
    
    for (long i=0; i <= equation.length; i++) {
        unichar character = equationChars[i];
        currentTokenType = typeForCharacter(character);
        
        // compare to last token type to re-define the token type
        if (character == '-' && lastTokenType != tokenTypeNumber && lastTokenType != tokenTypeText) {
            // e.g. -1 or -variable
            currentTokenType = tokenTypeNumber;
            
        } else if (currentTokenType == tokenTypeNumber && lastTokenType == tokenTypeText) {
            // e.g. a1 should be a variable
            currentTokenType = tokenTypeText;
            
        }
        
        // if first loop, last == current token type
        if (lastTokenType == tokenTypeFirstLoop) {
            lastTokenType = currentTokenType;
        }
        
        // token type changed, push the token into stack
        if (currentTokenType != lastTokenType || lastTokenType == tokenTypeOperator) {
            
            NSString *string = [NSString stringWithCharacters:tempChars length:tempCharsLength];
            
            // variable token
            if (lastTokenType == tokenTypeText) {
                id object = [numbers objectForKey:string];
                
                if ([object isKindOfClass:[NSString class]]) {
                    string = object;
                    
                } else if ([object respondsToSelector:@selector(stringValue)]) {
                    string = [object stringValue];
                    assert(![[NSDecimalNumber notANumber] isEqual:[NSDecimalNumber decimalNumberWithString:string]]);
                    
                } else {
#ifdef DEBUG
                    NSLog(@"Invalid Variable: object %@ has no string value.", object);
                    exit(EXIT_FAILURE);
#endif
                }
                
                [equationStack addObject:string];
                tempCharsLength = 0;
                
            } else if (lastTokenType == tokenTypeNumber && [@"-" isEqualToString:string]) {
                // '-': unary minus
                [equationStack addObject:@"-1"];
                [equationStack addObject:@"*"];
                
                tempCharsLength = 0;
                
            } else {
                [equationStack addObject:string];
                tempCharsLength = 0;
            }
        }
        
        // read next character
        tempChars[tempCharsLength++] = character;
        lastTokenType = currentTokenType;
    }
    
    return equationStack;
}

// change the tokens array into RPN (Reverse Polish notation) array
// e.g. @[@"1", @"2", @"3", @"*", @"+"]
NSArray* RPNFromTokens (NSArray *tokens)
{
    NSMutableArray *output = [@[] mutableCopy];
    NSMutableArray *operatorStack = [@[] mutableCopy];
    NSString *operator;
    
    initOperators();
    
    for (NSString *token in tokens) {
        
        if ([@"(" isEqualToString:token]) {
            [operatorStack addObject:token];
            continue;
        }
        
        operator = nil;
        
        if ([@")" isEqualToString:token]) {
            
            do {
                operator = [operatorStack lastObject];
                [operatorStack removeLastObject];
                
                if (![@"(" isEqualToString:operator]) {
                    [output addObject:operator];
                }
                
            } while (![@"(" isEqualToString:operator]);
            
            continue;
        }
        
        
        if ([operators indexOfObject:token] != NSNotFound) {
            operator = [operatorStack lastObject];
            
            NSInteger precedence = precedenceForOperator(token);
            NSInteger lastPrecedence = -1;
            
            if (operator) {
                lastPrecedence = precedenceForOperator(operator);
            }
            
            if (precedence > lastPrecedence) {
                [operatorStack addObject:token];
                continue;
            }
            
            do {
                operator = [operatorStack lastObject];
                if (operator && ![@"(" isEqualToString:operator]) {
                    [output addObject:operator];
                    
                    [operatorStack removeLastObject];
                }
                
            } while (operator && precedence <= lastPrecedence && ![@"(" isEqualToString:operator]);
            
            [operatorStack addObject:token];
            continue;
        }
        
        [output addObject:token];
    }
    
    [output addObjectsFromArray:[[operatorStack reverseObjectEnumerator] allObjects]];
    
    return output;
}


#pragma mark - Operators static array

void initOperators()
{
    if (operators == nil) {
        operators = @[@"+", @"-", @"*", @"/", @"^"];
    }
}