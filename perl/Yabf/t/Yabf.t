use strict;
use warnings;
use 5.010;
use Yabf;
use Test::More;


BEGIN { use_ok('Yabf'); }
is(Yabf::evaluate(""),  0, "data pointer starts at 0");
is(Yabf::evaluate(">"), 1, "> shifts data pointer to 1");
is(Yabf::evaluate(">>"), 2, ">> shifts data pointer to 2");
is(Yabf::evaluate("<"), 0, "< does not shift to -1, but to 0");
is(Yabf::evaluate("><"), 0, ">< resets data pointer to 0");

done_testing();

