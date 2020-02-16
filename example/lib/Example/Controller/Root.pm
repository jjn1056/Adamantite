package Example::Controller::Root;

use Adamantite::Controller;

with 'Catalyst::ControllerRole::RenderView';

sub root : At(/...) ($self, $c) { }

  sub not_found : Via(root) At({*}) ($self, $c, @path) { }
  
  sub welcome : Via(root) At(welcome) ($self, $c) { }

__PACKAGE__->meta->make_immutable;
