package Yabf;

use 5.010000;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Yabf ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);

our $VERSION = '0.01';


sub evaluate {
    my $expr = shift;
    my $output_callback = shift;
    my $read_callback = shift;
    my $loops_deep = 0;
    my $data_pointer = 0;
    my @buffer = (0);
    my @output = ();

    for (my $i = 0 ; $i < length $expr ; $i++)  {
        my $op = substr($expr, $i, 1);
        given ($op) {
            when ('>') { $data_pointer++ }
            when ('<') { $data_pointer-- if $data_pointer }
            when ('+') { $buffer[$data_pointer]++ }
            when ('-') { $buffer[$data_pointer]-- }
            when ('[') {
                $loops_deep++ if $buffer[$data_pointer];
                if ($buffer[$data_pointer] == 0) {
                    $loops_deep--;
                    while (substr($expr, $i, 1) ne ']') {
                        $i++;
                    }
                }
            }
            when(']') {
                next if $loops_deep == 1 && $buffer[$data_pointer] == 0;
                while ($loops_deep > 0 && substr($expr, $i, 1) ne '[') {
                    $i--;
                }
                $i--;
            }
            when('.') { $output_callback->($buffer[$data_pointer]) }
            when(',') { $buffer[$data_pointer] = ord $read_callback->() }
        }
    }
    {data_pointer => $data_pointer,
     buffer => \@buffer};
}


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Yabf - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Yabf;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Yabf, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Hugo Lopes Tavares, E<lt>hugo@apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Hugo Lopes Tavares

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.


=cut
