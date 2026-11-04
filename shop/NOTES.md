
# Practice 9 — Notes

## Level 1: Lift It Up

The cart state is stored in Shell above MaterialApp.

Data is passed to screens through constructor parameters.

Callbacks are used to add and remove books.

## Constructor Changes

To display the total price near the cart badge,
I added a total parameter to BooksScreen and CartBadge.

Constructors changed: 2.

## Rebuild Counter

BooksScreen build: [enter measured count]

Book row builds: [enter measured count]

## Level 5 — UI Logic

### Where does it live?

Search query:
BooksScreen State.
It is local UI state and is not needed by other screens.

Cart data:
Cart ChangeNotifier.
It is shared application state.

Expanded or collapsed total:
CartScreen State.
Only the cart screen needs this value.

Snackbar:
BooksScreen.
It is displayed after adding a new book.

Clear cart confirmation:
CartScreen.
The dialog asks the user before clearing the cart.

### Provider Usage

context.watch:
Subscribes a widget to Cart changes.

context.read:
Calls Cart methods without subscribing.

context.select:
Subscribes only to a selected value.

Consumer:
Rebuilds a specific UI section when Cart changes.
