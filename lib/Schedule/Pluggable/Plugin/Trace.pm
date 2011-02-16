package Schedule::Pluggable::Plugin::Trace;
use B qw(svref_2object);
use Moose::Role;
use Try::Tiny;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;

has TraceWhat => ( is => 'rw',
                   isa => 'Str',
                   default => 'all',
               );


my $meta = Class::MOP::Class->initialize('Schedule::Pluggable');

my @methods = $meta->get_all_methods;
my @method_names = ();
foreach my $method (sort { $a->name cmp $b->name } @methods) {
    next unless $method->package_name =~ m/^Schedule::Pluggable/;
    next if $method->name =~ m/^_/;
    next unless  $method->original_package_name =~ m/^Schedule::Pluggable/;

    push(@method_names, { name => $method->name,
                          package_name => $method->package_name,
                          context => _get_context($method),
                        });
}

foreach my $method (@method_names) {
    my $where = $method->{context}->{file}."(".$method->{context}->{line}.") ".$method->{package_name};
    try { 
        before $method->{name} => sub { shift @_;print "TRACE: ${where}::$method->{name} called - ".Data::Dumper->Dump([\@_],[qw/@params/]); };
        after $method->{name}  => sub { print "TRACE: $method->{name} ended\n"; };
    }
    catch {
        warn "Whoops: $_";
    }
}
sub _get_context {
    my ($method) = @_;
    my $meta = $method->associated_metaclass;
    my $meth = $meta->get_method($method->name);
#    warn Data::Dumper->Dump([$method->name, $meth], [qw/$method $meth/]);
    my $context = {};
    if ($meth->{definition_context}) {
        $context = $meth->{definition_context};
    }
    else {
       ($context->{file}, $context->{line}) = map +($_->file,$_->line), svref_2object(\&{ $method->fully_qualified_name })->START;
    }
    return $context;
}
no Moose;
1;
__END__
=head1 NAME

Schedule::Pluggable::Plugin::Trace - Plugin Role for Schedule::Pluggable to trace each method called

=head1 METHODS

no public methods

=cut
