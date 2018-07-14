# AutoCompleteTextField Docs

## Usage

AutoCompleteTextField is typed to allow any data type to be used. However most common use case is with string types.


# Fields

## @required

### key

A global key of type GlobalKey<AutoCompleteTextFieldState<T>> where T is the data type of the suggestions is required
so the text field may be cleared dynamically.

### suggestions

A List<T> is provided. Each item in suggestions represents a possible suggestion such as a list of foods.

### itemBuilder

This is called for each suggestion:

`
(context, suggestion) {

}

`

A widget must be returned, the most common use case for itemBuilder is
`
(context, suggestion) {
    return new Padding(
        padding: desired padding,
        child: new Text(suggestion)
    );
}

`

### itemSorter

Sorts items:

`
(a, b) {

}

`

For string implementation (sorting A-Z)

`
(a, b) {
    return a.compareTo(b);
}

`
Can be used.

### itemFilter

Filters items based on the search query (return true or false)

`
(item, query) {

}
`

A common use case with strings is

`
(item, query) {
  item.toLowerCase().startsWith(query.toLowerCase());
}
`

Note that .toLowerCase() is used as if the user searched 'Ap'

And the possible suggestions were

'Apple',
'appletree'

without the use of .ToLowerCase() only Apple would be a suggestion.


## non-required fields

### suggestionsAmount

By default only 5 suggestions will be returned, this can be customised with this field

### style, decoration, textInputAction and keyboardType

Are TextField parameters refer to [here](https://docs.flutter.io/flutter/material/TextField-class.html)