//
//  UIColor+Additions.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

int hexalpha_to_int(int c)
{
    char hexalpha[] = "aAbBcCdDeEfF";
    int i;
    int answer = 0;
    
    for(i = 0; answer == 0 && hexalpha[i] != '\0'; i++)
    {
        if(hexalpha[i] == c)
        {
            answer = 10 + (i / 2);
        }
    }
    
    return answer;
}

unsigned int htoi(const char s[])
{
    unsigned int answer = 0;
    int i = 0;
    int valid = 1;
    int hexit;
    
    if(s[i] == '0')
    {
        ++i;
        if(s[i] == 'x' || s[i] == 'X')
        {
            ++i;
        }
    }
    
    while(valid && s[i] != '\0')
    {
        answer = answer * 16;
        if(s[i] >= '0' && s[i] <= '9')
        {
            answer = answer + (s[i] - '0');
        }
        else
        {
            hexit = hexalpha_to_int(s[i]);
            if(hexit == 0)
            {
                valid = 0;
            }
            else
            {
                answer = answer + hexit;
            }
        }
        
        ++i;
    }
    
    if(!valid)
    {
        answer = 0;
    }
    
    return answer;
}

+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    return [[UIColor alloc] initWithHex:hex alpha:alpha];
}

- (UIColor *)initWithHex:(NSString *)hex alpha:(CGFloat)alpha {
    const char *argv = [hex cStringUsingEncoding:NSUTF8StringEncoding];
    int tmp[] = {0,0,0,0,0,0};
    unsigned int rgb[] = {0,0,0};
    for (int i = 0; i < 6; i += 2) {
        for (int j = i; j < i+2; j++) {
            char *to = (char*) malloc(6);
            tmp[j] = htoi(strncpy(to, argv+j, 1));
        }
        rgb[i/2] = tmp[i]*16 + tmp[i+1];
    }
    float red = rgb[0] / 255.0f;
    float green = rgb[1] / 255.0f;
    float blue = rgb[2] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@end
