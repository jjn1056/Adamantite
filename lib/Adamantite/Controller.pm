package Adamantite::Controller::Base;

use Moose;
use MooseX::MethodAttributes;

extends 'Catalyst::Controller';
with 'Catalyst::ControllerRole::At';

Adamantite::Controller::Base->meta->make_immutable;
  
package Adamantite::Controller;

use strict;
use warnings;

use Moose::Exporter;
use Import::Into;
use Module::Runtime;

my ($import, $unimport, $init_meta) =
  Moose::Exporter->build_import_methods( also => ['Moose'] );

sub importables {
  my ($class) = @_;
  return (
    'utf8',
    'namespace::autoclean',
    ['feature', ':5.10'],
    ['experimental', 'signatures'],
  );
}

sub base_class { 'Adamantite::Controller::Base' }

sub init_meta {
  my ($class, @args) = @_;
  Moose->init_meta( @args,
    base_class => $class->base_class );
  goto $init_meta if $init_meta;
}

sub import {
  my ($class, @args) = @_;
  my $caller = caller;

  foreach my $import_proto($class->importables) {
    my ($module, @args) = (ref($import_proto)||'') eq 'ARRAY' ? 
      @$import_proto : ($import_proto, ());
    Module::Runtime::use_module($module)
      ->import::into($caller, @args)
  }
  goto $import;
}

1;
