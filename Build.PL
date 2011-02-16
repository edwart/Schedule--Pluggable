use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Schedule::Pluggable',
    license             => 'perl',
    dist_author         => 'Tony Edwardson <Tony.Edwardson@lchclearnet.com>',
    dist_version_from   => 'lib/Schedule/Pluggable.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Schedule-Pluggable-*' ],
);

$builder->create_build_script();
