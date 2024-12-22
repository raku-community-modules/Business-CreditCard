unit module Business::CreditCard;

my subset CreditCard of Str() is export where !*.contains(/ <-[\d x _ \  -]> /);

my enum CardTypes is export <
  NotACreditCard
  AmericanExpress
  BankCard
  BORICA
  ChinaT-Union
  ChinaUnionPay
  Dankort
  DinersClub
  DinersClubInternational
  Discover
  enRoute
  GPN
  Humo
  InterPayment
  InstaPayment
  IsraCard
  JCB
  LankaPay
  Laser
  Maestro
  MaestroUK
  MasterCard
  Mir
  Napas
  NPSPridnestrovie
  PayPal
  RuPay
  Solo
  Switch
  Troy
  UATP
  UkrCard
  UzCard
  Verve
  Visa
  VisaElectron
>;

# Marker enums for special country-dependent handling
enum Rebranded (
  ChinaUnionPay-as-Discover => -1,
  JCB-as-Discover           => -2,
);

# Obsolete to current branding map
my constant @renamed =
  NotACreditCard,
  AmericanExpress,
  BankCard,
  BORICA,
  ChinaT-Union,
  ChinaUnionPay,
  Dankort,
  Discover,  # was: DinersClub
  DinersClubInternational,
  Discover,
  enRoute,
  GPN,
  Humo,
  InterPayment,
  InstaPayment,
  IsraCard,
  JCB,
  LankaPay,
  Laser,
  Discover,  # was: Maestro
  Discover,  # was: MaestroUK
  MasterCard,
  Mir,
  Napas,
  NPSPridnestrovie,
  PayPal,
  RuPay,
  Solo,
  Switch,
  Troy,
  UATP,
  UkrCard,
  UzCard,
  Verve,
  Visa,
  VisaElectron,
;

# Helper sub to initialize lookup hashes
my sub splat(%map, $value, *@splattee --> Nil) {
    %map{$_} := $value for @splattee;
}

# Set up lookup hash at compile time: this distills the information
# found at https://en.wikipedia.org/wiki/Bank_card_number and
# from the Perl version at https://metacpan.org/pod/Business::CreditCard
# which sometimes contradict: patches welcome!
#
# Each initialization is done for the known card lengths (number of
# digits) and 2, 4 or 6 letter prefixes, possibly specIfied as a range.
my constant @lookup = do {

    my @a;

    for (12 .. 19).map({ @a[$_] := %() }) -> %map {
        # obsolete, Discover nowadays
        splat(%map, MaestroUK, 6758, 676770, 676774);
        splat(%map, Maestro,
          5018, 5020, 5038, 5893, 6304, 6759, 6761, 6762, 6763
        );
    }

    for (13, 16, 19).map({ @a[$_] }) -> %map {
        splat(%map, Visa, 40 .. 49);
    }

    {
        my %map := @a[14];
        splat(@a[14], DinersClub, 30, 36, 38, 39, 55);
    }

    {
        my %map := @a[15];
        splat(%map, AmericanExpress, 34, 37);
        splat(%map, DinersClubInternational, 30, 36, 38, 39);
        splat(%map, enRoute, 2014, 2149);
        splat(%map, JCB, 213100..213199, 180000..180099);
        splat(%map, UATP, 10..19);
    }

    {
        my %map := @a[16];
        splat(%map, BankCard, 5610, 560221..560225);
        splat(%map, BORICA, 2205);
        splat(%map, Dankort, 5019);
        splat(%map, DinersClub, 55);
        splat(%map, Discover, 3095);
        splat(%map, Humo, 9860);
        splat(%map, InstaPayment, 6370..6399);
        splat(%map, JCB, 30..35, 37);
        splat(%map, MasterCard, 22..27, 51..55);
        splat(%map, Napas, 9704);
        splat(%map, LankaPay, 357111);
        splat(%map, NPSPridnestrovie, 605474);
        splat(%map, Troy, 65, 9792);
        splat(%map, UzCard, 8600, 5614);
        splat(%map, VisaElectron, 4026, 417500, 4508, 4844, 4913, 4917);
    }

    {
        # Should return Discover in some countries
        splat(@a[17], ChinaUnionPay, 6224..6268);
    }

    for (16 .. 19).map({ @a[$_] }) -> %map {
        splat(%map, ChinaUnionPay, 62);
        splat(%map, ChinaUnionPay-as-Discover,
          6220..6229, 6240..6269, 6280..6289
        );
        splat(%map, DinersClub, 3000..3059, 3090..3099, 36, 38, 39);
        splat(%map, Discover, 6011, 6440..6499, 65);
        splat(%map, InterPayment,  6360..6369);
        splat(%map, JCB-as-Discover, 3528..3589);
        splat(%map, Laser, 6304, 6706, 6709, 6771);
        splat(%map, Mir, 2200..2204);
        # Should return Discover if :receipt is False
        splat(%map, PayPal, 601104, 650600, 650610);
        splat(%map, RuPay, 60, 65, 81, 82, 5080..5089, 3530..3539, 3560..3569);
        splat(%map, Troy, 65);
        splat(%map, UkrCard, 604001..604200);
    }

    for (16,18,19).map({ @a[$_] }) -> %map {
        splat(%map, GPN, 1946, 50, 56, 58, 60..63);
        splat(%map, Solo, 6334, 6767);
        splat(%map, Switch,
          4903, 4905, 4911, 4936, 564182, 633110, 6333, 6759
        );
        splat(%map, Verve, 506099..506198, 650002..650027, 507865..507964);
    }

    {
        my %map := @a[19];
        splat(%map, ChinaT-Union, 31);
        splat(%map, Napas, 9704);
    }

    # Ensure deep immutability
    @a[$_] := @a[$_].Map for 13 .. 19;

    @a
}

# Countries in which ChinaUnionPay is reported as Discover
my constant %CUPcountry = <
  US MX AI AG AW BS BB BM BQ VG KY CW DM DO GD
  GP JM MQ MS BL KN LC VC MF SX TT TC
>.map(* => Discover);

# Countries in which JCB is reported as Discover
my constant %JCBcountry = <
  US PR VI MP PW GU
>.map(* => Discover);

my proto sub cardtype(|) is export {*}

# Dirty input
my multi sub cardtype($, *% --> NotACreditCard) { }

# Might be a card
my multi sub cardtype(
  CreditCard $input,
  Bool      :$receipt,
  Bool      :$obsolete,
  Str       :$country = "US",
) {
    my $card := $input.comb(/ \d+ | x /).join.trans("x" => "0");

    if @lookup[$card.chars] -> %lookup {

        # Lookup from most specific to least specific prefix
        my $found := %lookup{$card.substr(0,6)}
          // %lookup{$card.substr(0,4)}
          // %lookup{$card.substr(0,2)}
          // NotACreditCard;

        # Paypal special case
        $found := Discover if $found == PayPal && !$receipt;

        # Country dependent branding
        if $found == ChinaUnionPay-as-Discover
          && %CUPcountry{$country.uc} -> $alternate {
            $found := $alternate;
        }
        if $found == JCB-as-Discover
          && %JCBcountry{$country.uc} -> $alternate {
            $found := $alternate;
        }

        # Handle renamed brands
        $obsolete ?? $found !! @renamed[$found];
    }

    # Handle special cases
    elsif $card.chars == 8 | 9 {
        IsraCard
    }

    # Alas
    else {
        NotACreditCard
    }
}

my sub validate($num is copy) is export {
    if cardtype($num) == enRoute {
        True
    }

    else {
        $num = $num.subst(/\D+/, '', :g);

        my $sum = 0; my $even = False;
        for (0 .. $num.chars - 1).reverse -> $i {
            my $char = substr($num, $i, 1).Int;
            $char *= 2 if $even;
            $char -= 9 if $char > 9;
            $sum  += $char;
            $even = ! $even;
        }

        ($sum % 10) == 0
    }
}

=begin pod

=head1 NAME

Business::CreditCard - Validate/generate credit card checksums/names

=head1 SYNOPSIS

=begin code :lang<raku>

use Business::CreditCard;

say cardtype("5276 4400 6542 1319");  # MasterCard
say validate("5276 4400 6542 1319");  # True

=end code

=head1 DESCRIPTION

These subroutines tell you whether a credit card number is
self-consistent -- whether the last digit of the number is a valid
checksum for the preceding digits.

=head1 SUBROUTINES

=head2 cardtype

=begin code :lang<raku>

say cardtype("5276 4400 6542 1319");  # MasterCard

=end code

The C<cardtype> subroutine returns a C<CardTypes> enum containing the
type of card: in C<Bool> contexts, a C<True> value means a valid card
type has been detected.

The credit card number can be given as a string, or as a number.  When
given as a string, the letter "x" can be used to indicate a digit
without meaning, and whitespace and dashes will be removed before
matching.

Prefix recognition is done by 6, 4 or 2 digit prefixes.  The following
named arguments can be specified:

=item :country

An optional two-letter country code for which to return the card type,
since some cards are reported with a different name according to
country.  Default is "US".

=item :receipt

If specified with a C<True> value, the "receipt" name of the card will
be returned.  This is currently only applicable for some Discover cards
that will be shown as "PayPal" on receipts.  Default is C<False>.

=item :obsolete

A Boolean flag whether to report an obsolete name for the given card
number.  By default C<False>.  If specified with a C<True> value, will
report the card type under its original name, rather then the current
rebranded card.

=head2 validate

=begin code :lang<raku>

use Business::CreditCard;

say validate("5276 4400 6542 1319");  # True

=end code

The C<validate> subroutine returns C<True> if the card number provided
passes the checksum test, and C<False> otherwise.

=head1 ACKNOWLEDGEMENTS

This distribution owes a great debt to Perl's
L<C<Business::CreditCard>|https://metacpan.org/pod/Business::CreditCard>,
originally written by I<Jon Orwant>, and currently maintained
by I<Ivan Kohler>.

=head1 AUTHORS

=item Fayland Lam
=item Elizabeth Mattijsen

=head1 COPYRIGHT AND LICENSE

Copyright 2015 - 2017 Fayland Lam

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
