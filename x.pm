### file x.pl ###
BEGIN { 
    use IO::String;
    use Tie::Handle;
    use Devel::Peek;
    use PerlIO;
    use File::Temp  qw[tempfile];
    
    my $Str = "package foo; 1;\n";
    
    unshift @INC, 
#         sub {   warn "Code ref 1 -- IO::String\n";
#                 my $io = IO::String->new;
#                 $io->print( $Str );
#                 Dump( $io );
#                 $io->setpos(0);
#                 return $io;
#         },
#         sub {   warn "Code ref 2 -- Tie::Handle\n";
#                 package X;
#                 @ISA = qw[Tie::StdHandle];
#                 sub READLINE  { $Str };
#                 tie *FH, 'X';
#                 Devel::Peek::Dump( \*FH );
#                 return \*FH;
#         },
        sub {   warn "Code ref 3 -- PerlIO";
                my $dummy = "";
                open my $fh, '>', \$dummy   or die $!;
                print $fh $Str              or die $!;
warn do { seek $fh, 0, 0; local $/; <$fh> };
                seek $fh, 0, 0;
                Dump( $fh );
                return $fh;
        },
#         sub {   warn "Code ref 4 -- File::Temp\n";
#                 my($fh,$name) = tempfile();
#                 print $fh $Str;
#                 close $fh;
#                 open my $fh2, $name or warn $!;
#                 Dump( $fh2 );
#                 return $fh2;
#         },
        sub {   die "Code ref 5 -- failed to load\n" },
}

1;

__END__

### output ### 

$ perl -Mx -e'use foo'
Code ref 1 -- IO::String
SV = RV(0x81ab34) at 0x80d43c
  REFCNT = 1
  FLAGS = (PADBUSY,PADMY,ROK)
  RV = 0x807bbc
  SV = PVGV(0x1c01b0) at 0x807bbc
    REFCNT = 1
    FLAGS = (OBJECT,GMG,SMG,MULTI)
    IV = 0
    NV = 0
    MAGIC = 0x19e160
      MG_VIRTUAL = &PL_vtbl_backref
      MG_TYPE = PERL_MAGIC_backref(<)
      MG_FLAGS = 0x02
        REFCOUNTED
      MG_OBJ = 0x84fb38
      SV = PVAV(0x801970) at 0x84fb38
        REFCNT = 2
        FLAGS = ()
        IV = 0
        NV = 0
        ARRAY = 0x18e7e0
        FILL = 0
        MAX = 3
        ARYLEN = 0x0
        FLAGS = (REAL)
        Elt No. 0
        SV = RV(0x81aaf8) at 0x85b338
          REFCNT = 1
          FLAGS = (ROK,WEAKREF,IsUV)
          RV = 0x807bbc
          SV = PVGV(0x1c01b0) at 0x807bbc
            REFCNT = 1
            FLAGS = (OBJECT,GMG,SMG,MULTI)
            IV = 0
            NV = 0
            MAGIC = 0x19e160
              MG_VIRTUAL = &PL_vtbl_backref
              MG_TYPE = PERL_MAGIC_backref(<)
              MG_FLAGS = 0x02
                REFCOUNTED
              MG_OBJ = 0x84fb38
              SV = PVAV(0x801970) at 0x84fb38
                REFCNT = 2
                FLAGS = ()
                IV = 0
                NV = 0
                ARRAY = 0x18e7e0
                FILL = 0
                MAX = 3
                ARYLEN = 0x0
                FLAGS = (REAL)
            MAGIC = 0x1c01f0
              MG_VIRTUAL = &PL_vtbl_glob
              MG_TYPE = PERL_MAGIC_glob(*)
              MG_OBJ = 0x807bbc
            STASH = 0x80d658    "IO::String"
            NAME = "GEN0"
            NAMELEN = 4
            GvSTASH = 0x81e550  "Symbol"
            GP = 0x1013e0
              SV = 0x807bc8
              REFCNT = 1
              IO = 0x807bd4
              FORM = 0x0  
              AV = 0x0
              HV = 0x82f224
              CV = 0x0
              CVGEN = 0x0
              GPFLAGS = 0x0
              LINE = 103
              FILE = "/opt/lib/perl5/5.8.3/Symbol.pm"
              FLAGS = 0x2
              EGV = 0x807bbc    "GEN0"
    MAGIC = 0x1c01f0
      MG_VIRTUAL = &PL_vtbl_glob
      MG_TYPE = PERL_MAGIC_glob(*)
      MG_OBJ = 0x807bbc
    STASH = 0x80d658    "IO::String"
    NAME = "GEN0"
    NAMELEN = 4
    GvSTASH = 0x81e550  "Symbol"
    GP = 0x1013e0
      SV = 0x807bc8
      REFCNT = 1
      IO = 0x807bd4
      FORM = 0x0  
      AV = 0x0
      HV = 0x82f224
      CV = 0x0
      CVGEN = 0x0
      GPFLAGS = 0x0
      LINE = 103
      FILE = "/opt/lib/perl5/5.8.3/Symbol.pm"
      FLAGS = 0x2
      EGV = 0x807bbc    "GEN0"
Code ref 2 -- Tie::Handle
SV = RV(0x81ab30) at 0x807c04
  REFCNT = 1
  FLAGS = (TEMP,ROK)
  RV = 0x850c10
  SV = PVGV(0x13b7f0) at 0x850c10
    REFCNT = 5
    FLAGS = (GMG,SMG,MULTI)
    IV = 0
    NV = 0
    MAGIC = 0x13bba0
      MG_VIRTUAL = &PL_vtbl_glob
      MG_TYPE = PERL_MAGIC_glob(*)
      MG_OBJ = 0x850c10
    NAME = "FH"
    NAMELEN = 2
    GvSTASH = 0x842630  "X"
    GP = 0x13bb70
      SV = 0x850b8c
      REFCNT = 1
      IO = 0x807bbc
      FORM = 0x0  
      AV = 0x0
      HV = 0x0
      CV = 0x0
      CVGEN = 0x0
      GPFLAGS = 0x0
      LINE = 19
      FILE = "x.pm"
      FLAGS = 0x2
      EGV = 0x850c10    "FH"
Code ref 3 -- File::Temp
SV = RV(0x81ab30) at 0x850ac0
  REFCNT = 1
  FLAGS = (PADBUSY,PADMY,ROK)
  RV = 0x807c58
  SV = PVGV(0x1c6ef0) at 0x807c58
    REFCNT = 1
    FLAGS = (GMG,SMG)
    IV = 0
    NV = 0
    MAGIC = 0x1c6f60
      MG_VIRTUAL = &PL_vtbl_glob
      MG_TYPE = PERL_MAGIC_glob(*)
      MG_OBJ = 0x807c58
    NAME = "$fh2"
    NAMELEN = 4
    GvSTASH = 0x800290  "main"
    GP = 0x1c6f30
      SV = 0x807d90
      REFCNT = 1
      IO = 0x807c10
      FORM = 0x0  
      AV = 0x0
      HV = 0x0
      CV = 0x0
      CVGEN = 0x0
      GPFLAGS = 0x0
      LINE = 27
      FILE = "x.pm"
      FLAGS = 0x0
      EGV = 0x807c58    "$fh2"

### relevant pp_require code ###

        {
            namesv = NEWSV(806, 0);
            for (i = 0; i <= AvFILL(ar); i++) {
                SV *dirsv = *av_fetch(ar, i, TRUE);

                if (SvROK(dirsv)) {
                    int count;
                    SV *loader = dirsv;

                    if (SvTYPE(SvRV(loader)) == SVt_PVAV
                        && !sv_isobject(loader))
                    {
                        loader = *av_fetch((AV *)SvRV(loader), 0, TRUE);
                    }

                    Perl_sv_setpvf(aTHX_ namesv, "/loader/0x%"UVxf"/%s",
                                   PTR2UV(SvRV(dirsv)), name);
                    tryname = SvPVX_const(namesv);
                    tryrsfp = 0;

                    ENTER;
                    SAVETMPS;
                    EXTEND(SP, 2);

                    PUSHMARK(SP);
                    PUSHs(dirsv);
                    PUSHs(sv);
                    PUTBACK;
                    if (sv_isobject(loader))
                        count = call_method("INC", G_ARRAY);
                    else
                        count = call_sv(loader, G_ARRAY);
                    SPAGAIN;

                    if (count > 0) {
                        int i = 0;
                        SV *arg;

                        SP -= count - 1;
                        arg = SP[i++];

                        if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVGV) {
                            arg = SvRV(arg);
                        }

                        if (SvTYPE(arg) == SVt_PVGV) {
                            IO *io = GvIO((GV *)arg);

                            ++filter_has_file;

                            if (io) {
                                tryrsfp = IoIFP(io);
                                if (IoTYPE(io) == IoTYPE_PIPE) {
                                    /* reading from a child process doesn't
                                       nest -- when returning from reading
                                       the inner module, the outer one is
                                       unreadable (closed?)  I've tried to
                                       save the gv to manage the lifespan of
                                       the pipe, but this didn't help. XXX */
                                    filter_child_proc = (GV *)arg;
                                    (void)SvREFCNT_inc(filter_child_proc);
                                }
                                else {
                                    if (IoOFP(io) && IoOFP(io) != IoIFP(io)) {
                                        PerlIO_close(IoOFP(io));
                                    }
                                    IoIFP(io) = Nullfp;
                                    IoOFP(io) = Nullfp;
                                }
                            }

                            if (i < count) {
                                arg = SP[i++];
                            }
                        }

                        if (SvROK(arg) && SvTYPE(SvRV(arg)) == SVt_PVCV) {
                            filter_sub = arg;
                            (void)SvREFCNT_inc(filter_sub);

                            if (i < count) {
                                filter_state = SP[i];
                                (void)SvREFCNT_inc(filter_state);
                            }

                            if (tryrsfp == 0) {
                                tryrsfp = PerlIO_open("/dev/null",
                                                      PERL_SCRIPT_MODE);
                            }
                        }
                        SP--;
                    }

                    PUTBACK;
                    FREETMPS;
                    LEAVE;

                    if (tryrsfp) {
                        hook_sv = dirsv;
                        break;
                    }
 
                    filter_has_file = 0;
                    if (filter_child_proc) {
                        SvREFCNT_dec(filter_child_proc);
                        filter_child_proc = 0;
                    }
                    if (filter_state) {
                        SvREFCNT_dec(filter_state);
                        filter_state = 0;
                    }
                    if (filter_sub) {
                        SvREFCNT_dec(filter_sub);
                        filter_sub = 0;
                    }
                }
                else {
                  if (!path_is_absolute(name)
                  
[....]                  

[11:07AM] pasty: "Nicholas" at 80.169.162.72 pasted "Case 1 - IFP and OFP are NULL" (40 lines) at http://paste.husk.org/4629
[11:07AM] pasty: "Nicholas" at 80.169.162.72 pasted "Case 2 - IFP and OFP are NULL" (32 lines) at http://paste.husk.org/4631
[11:07AM] pasty: "Nicholas" at 80.169.162.72 pasted "Case 3 - IFP isn't NULL" (22 lines) at http://paste.husk.org/4632


[11:08AM] Nicholas: Been working on it. Found the answer
[11:08AM] Nicholas: Basically the current code is not going to work with tied file handles.
[11:08AM] Nicholas: to be realistic, it's not going to work properly where a real file handle then has something else tied on top of it
[11:09AM] Nicholas: because it's doing direct file handle access
[11:09AM] Nicholas: I think that we need to document that as a limitation
[11:09AM] Nicholas: a PerlIO layer should work though
