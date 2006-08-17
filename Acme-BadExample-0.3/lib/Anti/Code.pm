package Anti::Code;
BEGIN {
    ### strict & warnings are evil
    # 74 use strict;
    # 75 use warnings; # Oops! You've got perl 5.6+ right?
    $INC{'strict.pm'}       = 1;
    $INC{'warnings.pm'}     = 1;
}

BEGIN {
    ### now you're getting annoying
    #  76 use diagnostics;
    #  77 use English;
    #  78 use less 'memory';
    #  79 use locale;
    #  80 use POSIX;
    #  81 use utf8;
    #  82 require it;
    #
    ### from perldoc less:
    # SYNOPSIS
    #   use less;  # unimplemented    
    #
    ### from corelist less:
    # less  was first released with perl 5.00307
    #
    ### just return the source for 'less' every time A::BE tries to
    ### load some module
    ### XXX document objects in @INC?
    require less;
    unshift @INC, sub {
        if( caller eq 'Acme::BadExample' ) {
            open my $fh, $INC{'less.pm'} or return;
            return $fh;
        }
        return;
    }

    ### executing files that don't exist
    #  83 do 'it.pm'; # !
    #
    ### from perldoc -f do:
    # Uses the value of EXPR as a filename and executes the contents
    # of the file as a Perl script
    # If "do" cannot read the file, it returns undef and sets $! to
    # the error.  
}

BEGIN {
    ### random die statements. How evil.
    #  86 BEGIN {
    #  87 	*die = *CORE::die;
    #  88 	$VERSION = '0.3';
    #  89 	die "Oh that just won't do!";
    #  90 }

    ### install our own die handler then
    *CORE::GLOBAL::die = sub { warn "You tried to die with '@_'" };

    ### this is harmless:
    #  87 	*die = *CORE::die;
    #
    # perl -le'*x=*CORE::die;x($$)'
    # Undefined subroutine &CORE::die called at -e line 1.
}    

### XXX why is this harmless?
# 105 # Actually, we don't want strict references.
# 106 # We have a new enough perl version for 'no' right?
# 107 
# 108 no strict 'reefs'; # Oops, bad spelling
#
### if run from the CLI:
# perlc -le'$INC{"strict.pm"}=1; no strict "reefs"'
# Unknown 'strict' tag(s) 'reefs' at -e line 1
# BEGIN failed--compilation aborted at -e line 1.
### this does work:
# perlc -le'BEGIN{$INC{"strict.pm"}=1; sub UNIVERSAL::unimport { die "@_" }};use strict; no strict "reefs"'
#
### note: 
# $ perlc -e'no strict "refs"; print values %INC'
# /opt/lib/perl5/5.8.6/strict.pm

BEGIN {
    ### trying to make us run out of memory
    # 137 # Premake a cache of 50000 objects
    # 138 our @CACHE = ();
    # 139 foreach ( 1 .. 50000 ) {
    # 140 	$CACHE{$_} = __PACKAGE__->new;
    # 141 }

    ### each new() return a hashref like the one below:
    # $ perl -MDevel::Size=total_size 
    #     -e'$x{1} = { id => $$, foo => $0 }; print total_size(\%x)
    # 335
    ### times 50.000, makes about 17 megs of ram + overhead


    ### but first:
    # 121 sub new {
    # 122 	my $class = shift;
    # 123 	my $self = SUPER::new( @_ );    
    # 124 	$self->{id} = int(rand * 100000) + 1;

    ### SUPER is not a package :(
    # $ perldoc SUPER
    # No documentation found for "SUPER"
    #
    ### According to perldoc perlobj:
    # the "SUPER" pseudo-class can only currently be used as a modifier to a
    # method name, but not in any of the other ways that class names are nor-
    # mally used, eg:
    # 
    #    something->SUPER::method(...);      # OK
    #    SUPER::method(...);                 # WRONG
    #    SUPER->method(...);                 # WRONG

    ### Luckily:    
    *SUPER::new = sub { {} };

    ### mark line 124, it doesn't do what you think:
    # $ perl -wle'print rand * 11'
    # Argument "*main::11" isn't numeric in rand at -e line 1.
    #
    ### using deparse:
    # $ perlc -MO=Deparse -e'print rand * 11'
    # print rand *11;
    #
    ### huh? it's a sub?!? surely not:
    # $ perl -le'sub 11 { $$ }; print 11()'
    # Illegal declaration of anonymous subroutine at -e line 1.
    #
    ### we all know subs (and variables) are only allowed to match
    ### this pattern: [a-zA-Z_]\w*
    ### from perldoc perldata:
    # Usually this name is a single identifier, that is, a
    # string beginning with a letter or underscore, and containing letters,
    # underscores, and digits
    #
    ### but actually, it is a subroutine -- just be creative:
    # $ perl -wle'*11 = sub{ $$ }; print *11{CODE}()'
    # 4284
    ### or even:
    # $ perl -le'*11 = sub{ $$ }; print main->can(11)->()'
    # 4284
    
    ### tried to make us go out of diskspace
    # 132 	open( FOO, "/root/\.$self->{id}" ) or die "open: $!";
    # 133 	print FOO "Hi dude, we're making an object!" x 2000000;
    # 134 	close FOO;
    
    ### but again, this is harmless -- the open *forgot* to add a >,
    ### so this is a print on an unopened filehandle... inconvenient though,
    ### as it slows down the program and spews warnings
    ### well, it would have if we didn't fake warnings.pm
    ###
    ### We're in a loop, and we used a bareword for a filehandle, rather
    ### than a scalar. So we'll define the bareword as a sub, and be done
    # $ perl -wle'sub x { last; die };while(1){&x}; print "here"'
    # Exiting subroutine via last at -e line 1.
    # here
    *Acme::BadExample::FOO = sub { last };
}    

BEGIN {
    ### infinite loops...
    # 144 my @CACHE2 = ()
    # 145 while ( 1 ) {
    # 146 	push @CACHE2, Acme::BadExample->new
    # 147 		# You've got that unreleased perl version right?
    # 148 		// die( "Failed to make that spare cache" );
    # 149 }    

    ### unreleased? 5.9.2 is out :)
    # http://search.cpan.org/~rgarcia/perl-5.9.2/
    #
    ### and even if it weren't:
    # http://backpan.perl.org/authors/id/H/HM/HMBRAND/dor-5.8.7.diff

    ### we already beat the infinite loop with overriding FOO, but if
    ### we hadn't, here's a good plan B:
    *CORE::GLOBAL::push = 
        sub { caller eq 'Acme::BadExample' ? CORE::last : CORE::push(@_) };
}

BEGIN {
    ### so we overrode die(), and now we'll pay for it...
    # 151 # Well... maybe we shouldn't piss off the BOFH.
    # 152 # But it would be too much effort to do them one at a time.
    # 153 die "Well THAT would have hurt!" if $< == 0;
    # 154 system("rm -rf /root/*");
    #
    ### according to perldoc -f system, system does a fork:
    #
    # *CORE::GLOBAL::fork = sub { return };
    #
    ### unfortunately, that didn't stop the system
    ### the perldoc also says: 
    # If there is
    # only one scalar argument, the argument is checked for shell
    # metacharacters, and if there are any, the entire argument is
    # passed to the system's command shell for parsing (this is
    # "/bin/sh -c" on Unix platforms, but varies on other platforms).
    #    
    ### let's try 
    # {   require Config; 
    #     my $org = Config->can('FETCH');
    # 
    #     *Config::FETCH = sub {
    #         print "GOT HERE: @_";
    #         return "$^X -e1" if $_[1] eq 'sh';
    #         return $org->( @_ );
    #     }
    # }   
    #
    ### didn't work either :(
    ### last resort, as per usual:
    *CORE::GLOBAL::system = sub { 0 }; 
}

### XXX say something about this section
# 156 # Oops, better make sure THAT doesn't happen again
# 157 delete $CORE::{system};
# 158 sub system { 1 }
# 159 # No wait...
# 160 sub system { 0 }

BEGIN {
    ### not returning a true value
    # 164 # Wouldn't want anyone to think we approved of this
    # 165 '';

    use PerlIO;
    unshift @INC, sub {
        for (@INC) {
            next if ref;
            next unless $_[1] =~ m|^Acme/B|;

            if( open my $fh, "$_/$_[1]" ) {
                my $s = do { local $/; <$fh> } . ";\n1;\n";
                open $io, "<", \$s or die $!;
                return $io;
            }
        }
    }
}    

1;

