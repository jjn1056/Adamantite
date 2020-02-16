package Example;

use Moose;
extends 'Adamantite::Application';

__PACKAGE__->setup_plugins(['Authentication']);


__PACKAGE__->config(
  'Plugin::Authentication' => {
    default_realm => 'members',
    members => {
      credential => {
        class => 'Password',
        password_field => 'password',
        password_type => 'clear'
      },
      store => {
        class => 'Minimal',
        users => {
          john => { password=>'green59' },
          mark => { password=>'now' },
        }
      },
    },
  }
);

__PACKAGE__->setup();
__PACKAGE__->meta->make_immutable();

