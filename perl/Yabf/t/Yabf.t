use strict;
use warnings;
use 5.010;
use Yabf;
use Test::More;

sub eval_to_data_pointer {
    my $arg = shift;
    my %result = Yabf::evaluate($arg);
    $result{data_pointer};
}

sub eval_to_buffer {
    my $arg = shift;
    my %result = Yabf::evaluate($arg);
    $result{buffer};
}

BEGIN { use_ok('Yabf'); }
is(eval_to_data_pointer(""), 0, "data pointer starts at 0");
is(eval_to_data_pointer(">"), 1, "> shifts data pointer to 1");
is(eval_to_data_pointer(">>"), 2, ">> shifts data pointer to 2");
is(eval_to_data_pointer("<"), 0, "< does not shift to -1, but to 0");
is(eval_to_data_pointer("><"), 0, ">< resets data pointer to 0");

is(eval_to_buffer(""), (0), "position 0 starts with 0");
is(eval_to_buffer("+"), (1), "+ increments position 0 to 1");

done_testing();

