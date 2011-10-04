use strict;
use warnings;
use 5.010;
use Yabf;
use Test::More tests => 4;


BEGIN { use_ok('Yabf'); }
is(Yabf::evaluate(""),  0, "data pointer starts at 0");
is(Yabf::evaluate(">"), 1, "> shifts data pointer to 1");
is(Yabf::evaluate(">>"), 2, ">> shifts data pointer to 2");

#done_testing();

