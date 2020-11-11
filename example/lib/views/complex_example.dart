import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';

class ComplexExample extends StatefulWidget {
  @override
  _ComplexExampleState createState() => _ComplexExampleState();
}

class ArbitrarySuggestionType {
  int id;
  String name;
  double stars;
  String imageURL;

  ArbitrarySuggestionType();
}

List<ArbitrarySuggestionType> suggestions = [
  ArbitrarySuggestionType()
    ..id = 0
    ..stars = 4.7
    ..name = "Minamishima"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-p/0f/25/de/0c/photo1jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 1
    ..stars = 1.5
    ..name = "The Meat & Wine Co Hawthorn East"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/12/ba/7d/4c/confit-cod-chorizo-red.jpg",
  ArbitrarySuggestionType()
    ..id = 2
    ..stars = 3.4
    ..name = "Florentino"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/12/fc/bb/11/from-the-street.jpg",
  ArbitrarySuggestionType()
    ..id = 3
    ..stars = 4.3
    ..name = "Syracuse Restaurant & Winebar Melbourne CBD"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-p/07/ad/76/b0/the-gyoza-had-a-nice.jpg",
  ArbitrarySuggestionType()
    ..id = 4
    ..stars = 1.1
    ..name = "Geppetto Trattoria"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0c/85/3d/cb/photo1jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 5
    ..stars = 3.4
    ..name = "Cumulus Inc."
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0e/21/a0/be/photo0jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 6
    ..stars = 2.2
    ..name = "Chin Chin"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0e/83/ec/07/triple-beef-triple-bacon.jpg",
  ArbitrarySuggestionType()
    ..id = 7
    ..stars = 5.0
    ..name = "Anchovy"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/07/e7/f6/8e/daneli-s-kosher-deli.jpg",
  ArbitrarySuggestionType()
    ..id = 8
    ..stars = 4.7
    ..name = "Sezar Restaurant"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/04/b8/23/d1/nevsky-russian-restaurant.jpg",
  ArbitrarySuggestionType()
    ..id = 9
    ..stars = 2.6
    ..name = "Tipo 00"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/11/17/67/8c/front-seats.jpg",
  ArbitrarySuggestionType()
    ..id = 10
    ..stars = 3.4
    ..name = "Coda"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0d/b1/6a/84/photo0jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 11
    ..stars = 1.1
    ..name = "Pastuso"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-w/0a/d9/cf/52/photo4jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 12
    ..stars = 0.2
    ..name = "San Telmo"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0e/51/35/35/tempura-sashimi-combo.jpg",
  ArbitrarySuggestionType()
    ..id = 13
    ..stars = 3.6
    ..name = "Supernormal"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0e/bc/63/69/mr-miyagi.jpg",
  ArbitrarySuggestionType()
    ..id = 14
    ..stars = 4.4
    ..name = "EZARD"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-p/09/f2/83/15/photo0jpg.jpg",
  ArbitrarySuggestionType()
    ..id = 15
    ..stars = 2.1
    ..name = "Maha"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/10/f8/9e/af/20171013-205729-largejpg.jpg",
  ArbitrarySuggestionType()
    ..id = 16
    ..stars = 4.2
    ..name = "MoVida"
    ..imageURL = "https://media-cdn.tripadvisor.com/media/photo-s/0e/1f/55/79/and-here-we-go.jpg",
];

class _ComplexExampleState extends State<ComplexExample> {
  final _formKey = GlobalKey<FormState>();

  ArbitrarySuggestionType _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget _bottomFormField() {
      return Container(
        color: theme.primaryColorLight,
        padding: const EdgeInsets.all(4.0),
        child: AutoCompleteTextField<ArbitrarySuggestionType>(
          duration: const Duration(milliseconds: 300),
          config: AutoCompleteConfiguration(
            offset: Offset(0, 4),
            preferAbove: true,
            clearOnSelected: true,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          textFieldConfig: TextFieldConfiguration(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Restaurants...',
            ),
          ),
          onItemSelected: (item) {
            setState(() => _selected = item);
            return item.name;
          },
          itemBuilder: (context, term) => (suggestions.where((x) => x.name.toLowerCase().contains(term)).toList()
                ..sort((a, b) => a.stars.compareTo(b.stars)))
              .take(15)
              .map<AutoCompleteEntry<ArbitrarySuggestionType>>(_mapSuggestions)
              .toList(),
        ),
      );
    }

    Widget _body() {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.accentColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selected == null
              ? Center(child: Text('No Movie Selected'))
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(_selected.name, style: theme.textTheme.headline6),
                        Expanded(child: Container()),
                        Text('${_selected.stars.toStringAsFixed(1)}/5'),
                        Icon(Icons.star, color: Colors.yellow, size: 12),
                      ],
                    ),
                    SizedBox(height: 12),
                    Image.network(
                      _selected.imageURL,
                      errorBuilder: (context, e, s) => Center(child: Text('Could not fetch image')),
                      loadingBuilder: (context, image, event) {
                        return Center(
                          child: event == null
                              ? image
                              : CircularProgressIndicator(
                                  value: event.cumulativeBytesLoaded / event.expectedTotalBytes,
                                ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(title: Text('Form Example')),
        body: _body(),
        bottomNavigationBar: _bottomFormField(),
      ),
    );
  }

  AutoCompleteEntry<ArbitrarySuggestionType> _mapSuggestions(ArbitrarySuggestionType x) => AutoCompleteEntry(
        value: x,
        child: ListTile(
          title: Text(x.name),
          trailing: SizedBox(
            width: 48,
            height: 48,
            child: Row(
              children: [
                Text('${x.stars.toStringAsFixed(1)}/5'),
                Icon(Icons.star, color: Colors.yellow, size: 12),
              ],
            ),
          ),
        ),
      );
}
