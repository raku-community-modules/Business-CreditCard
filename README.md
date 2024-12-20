[![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions) [![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions) [![Actions Status](https://github.com/raku-community-modules/Business-CreditCard/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Business-CreditCard/actions)

NAME
====

Business::CreditCard - Validate/generate credit card checksums/names

SYNOPSIS
========

```raku
use Business::CreditCard;

say validate("5276 4400 6542 1319");  # True
say cardtype("5276 4400 6542 1319");  # MasterCard
```

DESCRIPTION
===========

These subroutines tell you whether a credit card number is self-consistent -- whether the last digit of the number is a valid checksum for the preceding digits.

The `validate` subroutine returns `True` if the card number provided passes the checksum test, and `False` otherwise.

The `cardtype` subroutine returns a string containing the type of card.

ACKNOWLEDGEMENTS
================

This distribution owes a great debt to Perl's [`Business::CreditCard`](https://metacpan.org/pod/Business::CreditCard), originally written by *Jon Orwant*, and currently maintained by *Ivan Kohler*.

AUTHOR
======

Fayland Lam

COPYRIGHT AND LICENSE
=====================

Copyright 2015 - 2017 Fayland Lam

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

