use strict;
use warnings;
use 5.010;
use Yabf;
use Test::More;

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

sub eval_to_output {
    my $arg = shift;
    my $fake_input = shift;
    my @output = ();
    my $result = Yabf::evaluate($arg, sub { push @output, shift }, sub { $fake_input });
    \@output;
}


BEGIN { use_ok('Yabf'); }

is(eval_to_data_pointer(""), 0, "data pointer starts at 0");
is(eval_to_data_pointer(">"), 1, "> shifts data pointer to 1");
is(eval_to_data_pointer(">>"), 2, ">> shifts data pointer to 2");
is(eval_to_data_pointer("<"), 0, "< does not shift to -1, but to 0");
is(eval_to_data_pointer("><"), 0, ">< resets data pointer to 0");

is_deeply(eval_to_buffer(""), [0], "position 0 starts with 0");
is_deeply(eval_to_buffer("+"), [1], "+ increments position 0 to 1");
is_deeply(eval_to_buffer("++"), [2], "++ increments position 0 to 2");
is_deeply(eval_to_buffer(">+"), [0, 1], ">+ increments position 1 to 1");
is_deeply(eval_to_buffer(">++"), [0, 2], ">++ increments position 1 to 2");

is_deeply(eval_to_buffer("-"), [-1], "- decrements position 0 to -1");
is_deeply(eval_to_buffer(">-"), [0, -1], ">- decrements position 1 to -1");

is_deeply(eval_to_buffer(">++-"), [0, 1], ">++- sets position 1 to 1");
is_deeply(eval_to_buffer("+>+-<-"), [0, 0], "+>+-<- resets position 0 and 1");

is_deeply(eval_to_buffer("+[-]"), [0], "+[-] resets position 0 to 0");
is_deeply(eval_to_buffer("[-]"), [0], "[-] does nothing (keep position 0 as 0)");
is_deeply(eval_to_buffer("+[>+<-]"), [0, 1], "+[>+<-] resets position 0 and increments position 1");

is_deeply(eval_to_buffer("++[>+<-]"), [0, 2], "++[>+<-] should increment position 1 to 2");
is_deeply(eval_to_buffer("++[[-]]"), [0], "nested reset");
is_deeply(eval_to_buffer("++[[[[-]]]]"), [0], "four nested reset");

is_deeply(eval_to_output(''), [], "output starts blank");

is_deeply(eval_to_output('
    +++++ +
    [
      > +++++ +++++
      < -
    ]
    > +++++ .'), [65], "should output 65, the A character"); 

is_deeply(eval_to_output('
    +++++ +
    [
      > +++++ +++++
      < -
    ]
    > +++++ .
    + .
    + .'), [65, 66, 67], "should output 65, 66 and 67 (the A, B and C characters)"); 

is_deeply(eval_to_output('
 ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.
 '), [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33, 10], "should output 'Hello World!\\n'");

is_deeply(eval_to_output(',.', "A"), [65], "should output letter 'A'");
is_deeply(eval_to_output(',+.', "B"), [67], "should output letter 'C'");

done_testing();

