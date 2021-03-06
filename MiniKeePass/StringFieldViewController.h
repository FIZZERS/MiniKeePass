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

#import "FormViewController.h"
#import "Kdb4Node.h"
#import "SwitchCell.h"

@protocol StringFieldViewDelegate;

@interface StringFieldViewController : FormViewController <FormViewControllerDelegate>

@property (nonatomic, retain) StringField *stringField;
@property (nonatomic, readonly) UITextField *keyTextField;
@property (nonatomic, readonly) UITextField *valueTextField;
@property (nonatomic, readonly) SwitchCell *protectedSwitchCell;

@property (nonatomic, retain) id object;
@property (nonatomic, retain) id<StringFieldViewDelegate> stringFieldViewDelegate;

- (id)initWithStringField:(StringField *)stringField;

@end

@protocol StringFieldViewDelegate <NSObject>
- (void)stringFieldViewController:(StringFieldViewController *)controller
                updateStringField:(StringField *)stringField;
@end
