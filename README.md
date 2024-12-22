[![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions) [![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions) [![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions)

NAME
====

Business::CreditCard - Validate/generate credit card checksums/names

SYNOPSIS
========

```raku
use Business::CreditCard;

say cardtype("5276 4400 6542 1319");  # MasterCard
say validate("5276 4400 6542 1319");  # True
```

DESCRIPTION
===========

These subroutines tell you whether a credit card number is self-consistent -- whether the last digit of the number is a valid checksum for the preceding digits.

SUBROUTINES
===========

cardtype
--------

```raku
say cardtype("5276 4400 6542 1319");  # MasterCard
```

The `cardtype` subroutine returns a `CardTypes` enum containing the type of card: in `Bool` contexts, a `True` value means a valid card type has been detected.

The credit card number can be given as a string, or as a number. When given as a string, the letter "x" can be used to indicate a digit without meaning, and whitespace and dashes will be removed before matching.

Prefix recognition is done by 6, 4 or 2 digit prefixes. The following named arguments can be specified:

  * :country

An optional two-letter country code for which to return the card type, since some cards are reported with a different name according to country. Default is "US".

  * :receipt

If specified with a `True` value, the "receipt" name of the card will be returned. This is currently only applicable for some Discover cards that will be shown as "PayPal" on receipts. Default is `False`.

  * :obsolete

A Boolean flag whether to report an obsolete name for the given card number. By default `False`. If specified with a `True` value, will report the card type under its original name, rather then the current rebranded card.

validate
--------

```raku
use Business::CreditCard;

say validate("5276 4400 6542 1319");  # True
```

The `validate` subroutine returns `True` if the card number provided passes the checksum test, and `False` otherwise.

ACKNOWLEDGEMENTS
================

This distribution owes a great debt to Perl's [`Business::CreditCard`](https://metacpan.org/pod/Business::CreditCard), originally written by *Jon Orwant*, and currently maintained by *Ivan Kohler*.

AUTHORS
=======

  * Fayland Lam

  * Elizabeth Mattijsen

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2017 Fayland Lam

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

