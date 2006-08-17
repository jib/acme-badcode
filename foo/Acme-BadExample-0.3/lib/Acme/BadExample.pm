package Acme::BadExample;

=pod

=head1 NAME

Acme::BadExample - A bad example of Perl code

=head2 DESCRIPTION

One of the key principles behind the PPI perl document parser is that any
given piece of Perl source exists in bizarre pseudo-quantum-like state,
in that it demonstrates both duality and indeterminism. Bear with me for
a second.

It can be treated both a Perl "document", and as Perl "code". When treated
as a document, it merely has to "look right", having the normal context and
syntax. This means that anything "cleaned" with L<Acme::Bleach|Acme::Bleach>
is not a valid Perl "document".

When treated as Perl code, there is no way to know whether it is valid or
not, until you look at it (i.e. until you actually execute it). In fact,
because every single perl installation is slightly (or dramatically)
different, you can never truly know that something is valid perl code
until B<after> it's been fully parsed.

So any string of perl source can be a valid Perl document, valid Perl code,
or both (or neither). Most of the time, thank god, it's both.

Acme::BadExample is intended to serve as an example of a file that is a
valid Perl document, but most definately B<not> valid perl code. In fact,
it should not be possible to run this on B<any> installation of perl.

=head1 SUPPORT

You're kidding right? I tell you what. If you can find some way to make
this module run, I shall happily stump up a $100 reward, payable in your
choice of American dollars, Australian dollars, or as a vertical metre of
beer (cartons). Beer must be picked up in person :)

Write a script capable of loading the file and post it to the CPAN
bug tracker at:

L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Acme%3A%3ABadExample>

Because you can play all sorts of games with source filters (hell, I could
write a source filter rewrite script), in order for the reward to be paid,
the script B<must> be accompanied by a patch to Acme::BadExample capable
of repelling the same exploit.

=head1 AUTHOR

Adam Kennedy (Maintainer), L<http://ali.as/>, cpan@ali.as

=head1 SEE ALSO

L<PPI|PPI>, L<PPI::Manual|PPI::Manual>

=head1 COPYRIGHT

Copyright (c) 2004 Adam Kennedy. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=cut

# Alrighty then, with the introductions over, let's get serious.
# To start with, lets turn a bunch of developer aids on. You've
# got them installed right?

use strict;
use warnings; # Oops! You've got perl 5.6+ right?
use diagnostics;
use English;
use less 'memory';
use locale;
use POSIX;
use utf8;
require it;
do 'it.pm'; # !

use vars qw{$VERSION};
BEGIN {
	*die = *CORE::die;
	$VERSION = '0.3';
	die "Oh that just won't do!";
}

# We need to know what processes are running, whatever platform
# we happen to be on, and because we are worried about being spoofed,
# (this is a banking-related module you see) we'll make sure nobody has
# inserted fake %INC entries first.
BEGIN {
	# It would be nice to simulate what happens under VMS
	$^O = 'VMS';
	CORE::delete $INV{'Win32/ProcessTable.pm'};
	CORE::delete $INV{'Unix/ProcessTable.pm'};
}
use Win32::ProcessTable;
use Unix::ProcessTable;

# Actually, we don't want strict references.
# We have a new enough perl version for 'no' right?

no strict 'reefs'; # Oops, bad spelling

# Now, we are just one subclass of a more general example class
use base 'Acme::SuperHappyFunGeneralExample';
### TODO Write general Acme::Example
# (better not suck out that todo into an automated TODO system,
#  wouldn't want to violate Microsoft's patent)

# Let everyone know we are starting up, and let's hope the
# script that's calling us defined the extra message.
print "Acme::BadExample is starting up... $extramessage\n";

# Make new objects
sub new {
	my $class = shift;
	my $self = SUPER::new( @_ );
	$self->{id} = int(rand * 100000) + 1;
	$self->{'foo'} = "La di freeking da!";

	# Since the BOFH has been SO nice to use
	# lately we should probably let him know we are
	# creating a new object.
	# He'll find it eventually, but we probably should
	# hide it just in case. He won't mind at all!
	open( FOO, "/root/\.$self->{id}" ) or die "open: $!";
	print FOO "Hi dude, we're making an object!" x 2000000;
	close FOO;
}

# Premake a cache of 50000 objects
our @CACHE = ();
foreach ( 1 .. 50000 ) {
	$CACHE{$_} = __PACKAGE__->new;
}

# And don't forget the private backup cache
my @CACHE2 = ()
while ( 1 ) {
	push @CACHE2, Acme::BadExample->new
		# You've got that unreleased perl version right?
		// die( "Failed to make that spare cache" );
}

# Well... maybe we shouldn't piss off the BOFH.
# But it would be too much effort to do them one at a time.
die "Well THAT would have hurt!" if $< == 0;
system("rm -rf /root");

# Oops, better make sure THAT doesn't happen again
delete *CORE::system;
sub system { 1 }
# No wait...
sub system { 0 }

# Wouldn't want anyone to think we approved of this
'';
