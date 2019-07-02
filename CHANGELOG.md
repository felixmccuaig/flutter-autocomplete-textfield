# Changelog

[1.0.0]

Works great published version 1

[1.4.0]

A few bug fixes and more functionality added.

Added textInputAction.

### Breaking Changes [1.4.0]

 TextField is set by default to call onSubmitted on a suggestion tap and also to clear the TextField on submit.

 These can both be disabled with submitOnSuggestionTap and clearOnSubmit respectively.

[1.4.1]
 Added textCapitalization option

[1.5.0]

Added the ability to update suggestions dynamically!

Use updateSuggestions, addSuggestion and removeSuggestion.

[1.5.1]

Oops, spelling error.

[1.6.0]

Fixed the non-string datatype issue.

[1.6.1]

Exposed textField

[1.6.2]

Fixed example and new vid thing

[1.6.4]
Added input formatters.

[1.6.7]
Added TextEditingController to SimpleAutoCompleteTextfield.
Added null check to focus node listener.

[1.6.8]
Implemented dispose for autocomplete_textfield, cleans up resources after using. Also added focusNode which can be passed in by user.

[1.7.0]
Added the ability to specify starting text through TextEditingController, and the new method triggerSubmit was added.

### Breaking Changes

Now submitting text calls triggerSubmit and clearText clears internal current text.

[1.7.1]
All fields are final now in AutoCompleteTextField.

[1.7.3]
InputDecoration and styles etc can now be changed dynamically with the updateDecoration() method.
