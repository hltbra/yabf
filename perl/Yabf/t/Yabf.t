use strict;
use warnings;
use 5.010;
use Yabf;
use Test::More;
use Data::Dumper;

sub array_is {
    my ($result_ref, $expected_ref, $msg) = @_;
    my @result = @{$result_ref};
    my @expected = @{$expected_ref};

    return fail(Dumper(\@expected, \@result)) if (scalar @result) != (scalar @expected);

    for (my $i = 0 ; $i < scalar @expected ; $i++) {
        return fail(Dumper(\@expected, \@result)) if $expected[$i] != $result[$i];
    }
    pass $msg;
}

sub eval_to_data_pointer {
    my $arg = shift;
    my $result = Yabf::evaluate($arg);
    $result->{data_pointer};
}

sub eval_to_buffer {
    my $arg = shift;
    my $result = Yabf::evaluate($arg);
    $result->{buffer};
}

BEGIN { use_ok('Yabf'); }

is(eval_to_data_pointer(""), 0, "data pointer starts at 0");
is(eval_to_data_pointer(">"), 1, "> shifts data pointer to 1");
is(eval_to_data_pointer(">>"), 2, ">> shifts data pointer to 2");
is(eval_to_data_pointer("<"), 0, "< does not shift to -1, but to 0");
is(eval_to_data_pointer("><"), 0, ">< resets data pointer to 0");

array_is(eval_to_buffer(""), [0], "position 0 starts with 0");
array_is(eval_to_buffer("+"), [1], "+ increments position 0 to 1");
array_is(eval_to_buffer("++"), [2], "++ increments position 0 to 2");
array_is(eval_to_buffer(">+"), [0, 1], ">+ increments position 1 to 1");
array_is(eval_to_buffer(">++"), [0, 2], ">++ increments position 1 to 2");

array_is(eval_to_buffer("-"), [-1], "- decrements position 0 to -1");
array_is(eval_to_buffer(">-"), [0, -1], "- decrements position 1 to -1");

array_is(eval_to_buffer(">++-"), [0, 1], ">++- sets position 1 to 1");
array_is(eval_to_buffer("+>+-<-"), [0, 0], "+>+-<- resets position 0 and 1");

array_is(eval_to_buffer("+[-]"), [0], "+[-] resets position 0 to 0");
array_is(eval_to_buffer("[-]"), [0], "[-] does nothing (keep position 0 as 0)");


done_testing();

