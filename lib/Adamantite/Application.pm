package Adamantite::Application;

use Moose;

extends 'Catalyst';

use Catalyst qw(
  Session
  Session::State::Cookie
  Session::Store::Cookie
  RedirectTo
  InjectionHelpers
  URI
);

__PACKAGE__->config(
  disable_component_resolution_regex_fallback => 1,
  'Plugin::Session' => { storage_secret_key => 'abc123' },
  'View::HTML' => {
    -inject => {
      from_component => 'Catalyst::View::Handlebars',
    },
  },
  'Controller::Root' => {
    namespace => '',
    view_handlers => {
      'text/html' => 'HTML',
      'application/json' => 'JSON',
    },
  },
);

__PACKAGE__->meta->make_immutable;
