//
//  VMaskEditor.m
//  Pods
//
//  Created by viniciusmo on 1/6/16.
//
//

#import "JVMaskEditor.h"
#import "JVFloatLabeledTextField.h"

@implementation JVMaskEditor

+(BOOL)shouldChangeCharactersInRange:(NSRange)range
                   replacementString:(NSString *)string
                           textField:(UITextField *)textField
                                mask:(NSString *)mask{
    
    JVFloatLabeledTextField *jvTextField = (JVFloatLabeledTextField *)textField;
    
    NSString * currentTextDigited = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (string.length == 0) {
        jvTextField.raw = [jvTextField.raw substringToIndex:[jvTextField.raw length] - 1];
        unichar lastCharDeleted = 0;
        while (currentTextDigited.length > 0 && !isnumber([currentTextDigited characterAtIndex:currentTextDigited.length-1])) {
            lastCharDeleted = [currentTextDigited characterAtIndex:[currentTextDigited length] - 1];
            currentTextDigited = [currentTextDigited substringToIndex:[currentTextDigited length] - 1];
        }
        textField.text = currentTextDigited;
        return NO;
    }
    
    NSMutableString * returnText = [[NSMutableString alloc] init];
    if (currentTextDigited.length > mask.length) {
        return NO;
    }
    
    int last = 0;
    BOOL needAppend = NO;
    for (int i = 0; i < currentTextDigited.length; i++) {
        unichar  currentCharMask = [mask characterAtIndex:i];
        unichar  currentChar = [currentTextDigited characterAtIndex:i];
        if (isnumber(currentChar) && currentCharMask == '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentChar]];
        }else{
            if (currentCharMask == '#') {
                break;
            }
            if (isnumber(currentChar) && currentCharMask!= currentChar) {
                needAppend = YES;
            }
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        last = i;
    }
    
    for (int i = last+1; i < mask.length; i++) {
        unichar currentCharMask = [mask characterAtIndex:i];
        if (currentCharMask != '#') {
            [returnText appendString:[NSString stringWithFormat:@"%c",currentCharMask]];
        }
        if (currentCharMask == '#') {
            break;
        }
    }
    if (needAppend) {
        [returnText appendString:string];
        
        if (jvTextField.raw) {
            jvTextField.raw = [NSString stringWithFormat:@"%@%@", jvTextField.raw, string];
        }
        else {
            jvTextField.raw = string;
        }
    }
    textField.text = returnText;
        
    return NO;
}

@end
