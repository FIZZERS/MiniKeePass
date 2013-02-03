/*
 * Copyright 2011-2012 Jason Rush and John Flanagan. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#import "TextFieldCell.h"
#import <UIKit/UIPasteboard.h>

#define INSET 83

@interface TextFieldCell()
@property (nonatomic, retain) UIView *grayBar;
@end

@implementation TextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect frame = self.contentView.frame;
        frame.origin.x = INSET;
        frame.size.width -= INSET;

        _textField = [[UITextField alloc] initWithFrame:frame];
        _textField.delegate = self;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.textColor = [UIColor colorWithRed:.285 green:.376 blue:.541 alpha:1];
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.returnKeyType = UIReturnKeyNext;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _textField.font = [UIFont boldSystemFontOfSize:15];
        _textField.textColor = [UIColor blackColor];

        [self.contentView addSubview:self.textField];

        CGFloat grayIntensity = 202.0 / 255.0;
        UIColor *color = [UIColor colorWithRed:grayIntensity green:grayIntensity blue:grayIntensity alpha:1];

        _grayBar = [[UIView alloc] initWithFrame:CGRectMake(79, -1, 1, self.contentView.frame.size.height - 4)];
        _grayBar.backgroundColor = color;
        _grayBar.hidden = YES;
        [self.contentView addSubview:_grayBar];

        [self addGestureRecognizer:[[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)] autorelease]];

        _menuItems = [[NSMutableArray alloc] initWithCapacity:3];
        [_menuItems addObject:[[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Edit", nil) action:@selector(edit:)] autorelease]];
    }
    return self;
}

- (void)dealloc {
    [_textField release];
    [_grayBar release];
    [_menuItems release];
    _textFieldCellDelegate = nil;
    
    [_accessoryButton release];
    [_editAccessoryButton release];
    [super dealloc];
}

- (BOOL)showGrayBar {
    return !self.grayBar.hidden;
}

- (void)setShowGrayBar:(BOOL)showGrayBar {
    self.grayBar.hidden = !showGrayBar;
}

- (void)setAccessoryButton:(UIButton *)accessoryButton {
    if (self.accessoryButton != nil) {
        [_accessoryButton release];
    }
    _accessoryButton = [accessoryButton retain];
    self.accessoryView = accessoryButton;
}

- (void)setEditAccessoryButton:(UIButton *)editAccessoryButton {
    if (self.editAccessoryButton != nil) {
        [_editAccessoryButton release];
    }
    _editAccessoryButton = [editAccessoryButton retain];
    self.editingAccessoryView = editAccessoryButton;
}

- (void)textFieldDidBeginEditing:(UITextField *)field {
    // Keep cell visable
    UITableView *tableView = (UITableView*)self.superview;
    [tableView scrollRectToVisible:self.frame animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.textFieldCellDelegate respondsToSelector:@selector(textFieldCellDidEndEditing:)]) {
        [self.textFieldCellDelegate textFieldCellDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
    if ([self.textFieldCellDelegate respondsToSelector:@selector(textFieldCellWillReturn:)]) {
        [self.textFieldCellDelegate textFieldCellWillReturn:self];
    }
    
    return NO;
}

- (void)longPress:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        CGRect rect = CGRectInset(self.bounds, 0, 15.0f);

        UIMenuController *menuController = [UIMenuController sharedMenuController];
        menuController.menuItems = self.menuItems;
        [menuController setTargetRect:rect inView:self];
        [menuController setMenuVisible:YES animated:YES];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(copy:) || action == @selector(edit:);
}

- (void)copy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.textField.text;
}

- (void)edit:(id)sender {
    if ([self.superview.nextResponder isKindOfClass:UIViewController.class]) {
        UITableViewController *viewController = (UITableViewController *)self.superview.nextResponder;
        [viewController setEditing:YES animated:YES];
        [self.textField becomeFirstResponder];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

@end
