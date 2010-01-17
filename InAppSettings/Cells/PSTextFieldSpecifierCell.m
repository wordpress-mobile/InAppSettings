//
//  PSToggleSwitchSpecifier.m
//  InAppSettingsTestApp
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import "PSTextFieldSpecifierCell.h"
#import "InAppSettingConstants.h"

@implementation PSTextFieldSpecifierCell

@synthesize textField;

#pragma mark helper methods

- (BOOL)isSecure{
    NSNumber *isSecure = [self.setting valueForKey:@"IsSecure"];
    if(!isSecure){
        return NO;
    }
    return [isSecure boolValue];
}

- (UIKeyboardType)getKeyboardType{
    NSString *keyboardType = [self.setting valueForKey:@"KeyboardType"];
    if([keyboardType isEqualToString:@"NumbersAndPunctuation"]){
        return UIKeyboardTypeNumbersAndPunctuation;
    }
    else if([keyboardType isEqualToString:@"NumberPad"]){
        return UIKeyboardTypeNumberPad;
    }
    else if([keyboardType isEqualToString:@"URL"]){
        return UIKeyboardTypeURL;
    }    
    else if([keyboardType isEqualToString:@"EmailAddress"]){
        return UIKeyboardTypeEmailAddress;
    } 
    
    return UIKeyboardTypeAlphabet;
}

- (UITextAutocapitalizationType)getAutocapitalizationType{
    //this works, but the real settings don't seem to respect these values eventhough they are in the docs
    NSString *autoCapitalizationType = [self.setting valueForKey:@"AutoCapitalizationType"];
    if([autoCapitalizationType isEqualToString:@"Words"]){
        return UITextAutocapitalizationTypeWords;
    }
    else if([autoCapitalizationType isEqualToString:@"Sentences"]){
        return UITextAutocapitalizationTypeSentences;
    }
    else if([autoCapitalizationType isEqualToString:@"AllCharacters"]){
        return UITextAutocapitalizationTypeAllCharacters;
    }
    return UITextAutocapitalizationTypeNone;
}

- (UITextAutocorrectionType)getAutocorrectionType{
    NSString *autocorrectionType = [self.setting valueForKey:@"AutocorrectionType"];
    if([autocorrectionType isEqualToString:@"Yes"]){
        return UITextAutocorrectionTypeYes;
    }
    else if([autocorrectionType isEqualToString:@"No"]){
        return UITextAutocorrectionTypeNo;
    }
    return UITextAutocorrectionTypeDefault;
}

- (void)textChangeAction{
    [self setValue:self.textField.text];
}

#pragma mark text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)cellTextField{
    [self.delegate textFieldSpecifierCellBecameFirstResponder:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)cellTextField{
    [cellTextField resignFirstResponder];
    [self.delegate textFieldSpecifierCellResignedFirstResponder:self];
    return YES;
}

#pragma mark cell controlls

- (void)setUIValues{
    [super setUIValues];
    
    [self setTitle];
    
    CGRect textFieldFrame = self.textField.frame;
    CGSize titleSize = [titleLabel.text sizeWithFont:titleLabel.font];
    textFieldFrame.origin.x = (CGFloat)round(titleSize.width+(InAppSettingCellPadding*2));
    if(textFieldFrame.origin.x < InAppSettingCellTextFieldMinX){
        textFieldFrame.origin.x = InAppSettingCellTextFieldMinX;
    }
    textFieldFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(titleSize.height*0.5f));
    textFieldFrame.size.width = (CGFloat)round((InAppSettingTableWidth-(InAppSettingCellPadding*3))-textFieldFrame.origin.x);
    textFieldFrame.size.height = titleSize.height;
    self.textField.frame = textFieldFrame;
    self.textField.text = [self getValue];
    
    //these are set here so they are set per cell
    self.textField.delegate = self;
    self.valueInput = self.textField;
}

- (void)setupCell{
    [super setupCell];
    
    //create text field
    self.textField =[[UITextField alloc] initWithFrame:CGRectZero];
    self.textField.textColor = InAppSettingBlue;
    self.textField.adjustsFontSizeToFitWidth = YES;
    
    //keyboard traits
    self.textField.secureTextEntry = [self isSecure];
    self.textField.keyboardType = [self getKeyboardType];
    self.textField.autocapitalizationType = [self getAutocapitalizationType];
    self.textField.autocorrectionType = [self getAutocorrectionType];
    //THIS IS NOT THE BEHAVIOR OF THE SETTINGS APP
    //but we need a way to dismiss the keyboard
    self.textField.returnKeyType = UIReturnKeyDone;
    
    [self.textField addTarget:self action:@selector(textChangeAction) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:self.textField];
}

- (void)dealloc{
    [textField release];
    [super dealloc];
}

@end
