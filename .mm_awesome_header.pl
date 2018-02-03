use Config;
use Alien::libuv ();
use ExtUtils::Depends ();
use XS::Object::Magic ();

# Some options behave differently on Windows
sub WINLIKE () {
    return 1 if $^O eq 'MSWin32';
    return 1 if $^O eq 'cygwin';
    return 1 if $^O eq 'msys';
    return '';
}

# make sure we actually get stuff back from Alien::libuv
sub TRIM {
    my $s = shift;
    return '' unless $s;
    $s =~ s/\A\s*//;
    $s =~ s/\s*\z//;
    return $s;
}

my $dep = ExtUtils::Depends->new('UV', 'Alien::libuv', 'XS::Object::Magic');
$dep->set_libs('-lpsapi') if WINLIKE();
{
    my @inc = ('-I.', '-I../..');
    my $cflags = TRIM(Alien::libuv->cflags);
    my $cflags_s = TRIM(Alien::libuv->cflags_static);
    if ($cflags eq $cflags_s) {
        push @inc, $cflags if $cflags;
    }
    else {
        push @inc, $cflags if $cflags;
        push @inc, $cflags_s if $cflags_s;
    }
    $dep->set_inc(@inc);
}
my %xsbuild = (
    XSMULTI => 1,
    XSBUILD => {
        xs => {
            'lib/UV' => {
                OBJECT => 'lib/UV$(OBJ_EXT) lib/perl_math_int64$(OBJ_EXT)',
            },
        },
    },
    OBJECT  => '$(O_FILES)',
    $dep->get_makefile_vars(),
);
