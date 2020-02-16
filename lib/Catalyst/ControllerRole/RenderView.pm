package Catalyst::ControllerRole::RenderView;

use Moose::Role;
use MooseX::MethodAttributes::Role;
use HTTP::Headers::ActionPack;

my $NO_VIEW_ERROR = 'Catalyst::Action::RenderView could not find a view to forward to.';
my $CONTENT_NEGOTIATOR = HTTP::Headers::ActionPack->new
  ->get_content_negotiator;

has view_handlers => (
  is => 'ro',
  isa => 'HashRef',
   
);

sub begin :Private {
  my ($self, $c) = @_;
  my %view_handlers = %{$self->view_handlers};

  my $accept = $c->req->header('Accept');
  return unless $accept;
  $c->log->debug("Found Accept Header of: $accept") if $c->debug;
  
  my $best_match = $CONTENT_NEGOTIATOR->choose_media_type([keys %view_handlers], $accept);
  return unless $best_match;
  $c->log->debug("Found best matching media-type: $best_match") if $c->debug;

  my $view = $view_handlers{$best_match} || $view_handlers{default};
  return unless $view;
  $c->log->debug("Found best matching view: $view") if $c->debug;

  $c->stash(current_view => $view);
}

sub end :Private {
  my ($self, $c) = @_;

  return 1 if $c->req->method eq 'HEAD';
  return 1 if defined $c->response->body;
  return 1 if $c->response->status =~ /^(?:204|3\d\d)$/;

  if(@{$c->error}) {
    
  }
  return 1 if scalar @{$c->error};

  $c->forward($c->view() || die $NO_VIEW_ERROR);
}

1;

=head1 NAME

Catalyst::Plugin::RenderView - Simple View handling

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

=head1 COPYRIGHT
 
Copyright (c) 20202 - the above named AUTHOR
 
=head1 LICENSE
 
You may distribute this code under the same terms as Perl itself.
 
=cut
