package Schedule::Pluggable::Trace;

use Moose::Role;
with 'MooseX::Object::Pluggable';

has Trace => ( is => 'rw',
               isa => 'Bool',
               reader   => '_get_Trace',
               writer   => '_set_Trace',
               default => 0,
            );

has TracePlugin => ( is => 'rw',
         isa => 'Str',
         reader   => '_get_TracePlugin',
         writer   => '_set_TracePlugin',
         default => 'Trace',
      );

before BUILD => sub {
    my $self = shift;
    my $plugins = $self->_get_Plugins;
    push( @{ $plugins }, $self->_get_TracePlugin ) if $self->_get_Trace;
    $self->_set_Plugins($plugins);
};
1;
__END__


=head1 NAME

Schedule::Pluggable::Trace 

=cut
