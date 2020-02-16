package Catalyst::View::Handlebars;

use Moose;
use Text::Handlebars;
use File::Spec;

extends 'Catalyst::View';

with 'Catalyst::Component::ApplicationAttribute';

has path => (
  is => 'ro',
  lazy => 1,
  required => 1,
  builder => '_build_path',
);
 
  sub _build_path {
    my $self = shift;
    my $module_path = $self->_module_path;
    my ($vol, $dir, $file) = File::Spec->splitpath($module_path);
    return [
      File::Spec->catfile($dir),
      File::Spec->catfile($dir, 'shared'),
    ];
  }

  sub _module_path {
    my @parts = split '::', shift;
    my $path = File::Spec->catfile(@parts);
    return $INC{"${path}.pm"} || die "Can't find view path at '$path'";
  }



has handlerbars => (
  is => 'ro',
  lazy => 1,
  required => 1,
  builder => '_build_handlerbars');

 

sub ACCEPT_CONTEXT {
  my ($self, $c, @args) = @_;
  die "Can't call in Application context" unless blessed $c;

  return $self;
}

__PACKAGE__->meta->make_immutable;
