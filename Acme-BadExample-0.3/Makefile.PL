require 5.000;
use ExtUtils::MakeMaker;
WriteMakefile(
	'NAME'             => 'Acme::BadExample',
	'VERSION_FROM'     => 'lib/Acme/BadExample.pm',
	($] >= 5.005) ? (
		'AUTHOR'   => 'Adam Kennedy<cpan@ali.as>',
		'ABSTRACT' => 'Perl DOCUMENT, yes. Perl CODE, no damn way!',
	) : (),
);
