# ===========================================================================
# Copyright Everitz Consulting.  Not for redistribution.
# ===========================================================================
package MT::Plugin::SphereIt;

use base qw(MT::Plugin);
use strict;

use MT;

my $SphereIt;
$SphereIt = MT::Plugin::SphereIt->new({
  name => 'MT-SphereIt',
  description => "<MT_TRANS phrase=\"Automatically show related content from the 'Sphere.\">",
  author_name => 'Everitz Consulting',
  author_link => 'http://www.everitz.com/',
  version => 1.0,
#
# config
#
  blog_config_template => \&template,
  settings => new MT::PluginSettings([
    ['blog_enable_sphere_it', { Default => 1 }]
  ])
});
MT->add_plugin($SphereIt);

require MT::Template::Context;
MT::Template::Context->add_tag(SphereItHeader => \&sphere_it_header);
MT::Template::Context->add_tag(SphereItWidget => \&sphere_it_widget);

sub instance { $SphereIt }

sub template {
  my $tmpl = <<HTML;
  <div class="setting">
    <div class="field">
      <p>
        <input type="checkbox" name="blog_enable_sphere_it" id="blog_enable_sphere_it" value="1" <TMPL_IF NAME=BLOG_ENABLE_SPHERE_IT>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="Enable SphereIt for This Blog">
      </p>
    </div> 
  </div>
HTML
}

sub sphere_it_header {
  my ($ctx, $args, $cond) = @_;
  my $blog = $ctx->stash('blog');
  my $blog_enabled = $SphereIt->get_config_value('blog_enable_sphere_it', 'blog:'.$blog->id);
  my $out = '';
  return $out unless ($blog_enabled);

  $out = <<HTML;
<style type=\"text/css\">
.iconsphere {
  background: url(http://www.sphere.com/images/sphereicon.gif) top left no-repeat;
  padding-left: 20px;
  padding-bottom: 10px;
  font-size: 10px;
  white-space: nowrap;
	}
</style>

<script type="text/javascript" src="http://www.sphere.com/widgets/sphereit/js?siteid=movabletype"></script>
HTML

  $out;
}

sub sphere_it_widget {
  my ($ctx, $args, $cond) = @_;
  my $blog = $ctx->stash('blog');
  my $blog_enabled = $SphereIt->get_config_value('blog_enable_sphere_it', 'blog:'.$blog->id);
  my $out = '';
  return $out unless ($blog_enabled);

  my $entry = $ctx->stash('entry');
  return $out unless ($entry);

  my $permalink = $entry->permalink;
  $out = <<HTML;
<a class="iconsphere" title="Related Blogs &amp; Articles" onclick="return Sphere.Widget.search()" href="http://www.sphere.com/search?q=sphereit:$permalink">Sphere It</a>
HTML

  $out;
}

1;