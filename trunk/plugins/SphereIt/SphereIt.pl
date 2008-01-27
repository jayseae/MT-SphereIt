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
  version => '1.1.0',
#
# config
#
  blog_config_template => \&template,
  settings => new MT::PluginSettings([
    ['sphereit_enabled', { Default => 1 }],
    ['sphereit_min_chars', { Default => 500 }],
    ['sphereit_min_words', { Default => 30 }],
    ['sphereit_threshold', { Default => 1 }],
    ['sphereit_widget_type', { Default => 'movabletype' }]
  ])
});
MT->add_plugin($SphereIt);

require MT::Template::Context;
MT::Template::Context->add_tag(SphereItHeader => \&sphereit_header);
MT::Template::Context->add_tag(SphereItWidget => \&sphereit_widget);

sub instance { $SphereIt }

sub template {
  my $tmpl = <<HTML;
  <script language="JavaScript">
    <!--
      function hide_and_seek () {
        if (document.getElementById('sphereit_enabled').checked) {
          document.getElementById('sphereit_threshold').disabled = 0;
          if (document.getElementById('sphereit_threshold').checked) {
            document.getElementById('sphereit_min_chars').disabled = 0;
            document.getElementById('sphereit_min_words').disabled = 0;
          } else {
            document.getElementById('sphereit_min_chars').disabled = 1;
            document.getElementById('sphereit_min_words').disabled = 1;
          }
          document.getElementById('sphereit_widget_type_movabletype').disabled = 0;
          document.getElementById('sphereit_widget_type_political_dem').disabled = 0;
          document.getElementById('sphereit_widget_type_political_rep').disabled = 0;
          document.getElementById('sphereit_widget_type_political_gen').disabled = 0;
        } else {
          document.getElementById('sphereit_threshold').disabled = 1;
          document.getElementById('sphereit_min_chars').disabled = 1;
          document.getElementById('sphereit_min_words').disabled = 1;
          document.getElementById('sphereit_widget_type_movabletype').disabled = 1;
          document.getElementById('sphereit_widget_type_political_dem').disabled = 1;
          document.getElementById('sphereit_widget_type_political_rep').disabled = 1;
          document.getElementById('sphereit_widget_type_political_gen').disabled = 1;
        }
      }
    //-->
  </script>
  <div class="setting">
    <div class="label">
      <label for="sphereit_enabled"><MT_TRANS phrase="Enable:"></label>
    </div>
    <div class="field">
      <p>
        <input type="checkbox" name="sphereit_enabled" id="sphereit_enabled" onclick="hide_and_seek(this.form)" value="1" <TMPL_IF NAME=SPHEREIT_ENABLED>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="Enable SphereIt for This Blog">
      </p>
    </div>
  </div>
  <div class="setting">
    <div class="label">
      <label for="sphereit_threshold"><MT_TRANS phrase="Threshold:"></label>
    </div>
    <div class="field">
      <p>
         <input value="1" type="checkbox" name="sphereit_threshold" id="sphereit_threshold" onclick="hide_and_seek(this.form)" <TMPL_IF NAME=SPHEREIT_THRESHOLD>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="Enable Entry Length Checking (default)">
      </p>
    </div>
  </div>
  <div class="setting">
    <div class="label">
      <label for="sphereit_min_chars"><MT_TRANS phrase="Minimum Characters:"></label>
    </div>
    <div class="field">
      <p>
         <input type="text" name="sphereit_min_chars" id="sphereit_min_chars" <TMPL_IF NAME=SPHEREIT_MIN_CHARS>value="<TMPL_VAR NAME=SPHEREIT_MIN_CHARS>"</TMPL_IF> /> <MT_TRANS phrase="Enter the Minimum Characters per Entry">
      </p>
    </div>
  </div>
  <div class="setting">
    <div class="label">
      <label for="sphereit_min_words"><MT_TRANS phrase="Minimum Words:"></label>
    </div>
    <div class="field">
      <p>
         <input type="text" name="sphereit_min_words" id="sphereit_min_words" <TMPL_IF NAME=SPHEREIT_MIN_WORDS>value="<TMPL_VAR NAME=SPHEREIT_MIN_WORDS>"</TMPL_IF> /> <MT_TRANS phrase="Enter the Minimum Words per Entry">
      </p>
    </div>
  </div>
  <div class="setting">
    <div class="label">
      <label for="sphereit_widget_type"><MT_TRANS phrase="Widget Type:"></label>
    </div>
    <div class="field">
      <p>
         <input type="radio" name="sphereit_widget_type" id="sphereit_widget_type_movabletype" value="movabletype" <TMPL_IF NAME=SPHEREIT_WIDGET_TYPE_MOVABLETYPE>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="The classic widget shows related posts and news from a wide variety of sources that are not category specific."><br />
         <input type="radio" name="sphereit_widget_type" id="sphereit_widget_type_political_dem" value="political_dem" <TMPL_IF NAME=SPHEREIT_WIDGET_TYPE_POLITICAL_DEM>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="The politics widget for <em>Democrats</em> shows related posts from Democratic and other left-leaning blogs, as well as from a variety of news sources."><br />
         <input type="radio" name="sphereit_widget_type" id="sphereit_widget_type_political_rep" value="political_rep" <TMPL_IF NAME=SPHEREIT_WIDGET_TYPE_POLITICAL_REP>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="The politics widget for <em>Republicans</em> shows related posts from Republicans and other right-leaning blogs, as well as from a variety of news sources."><br />
         <input type="radio" name="sphereit_widget_type" id="sphereit_widget_type_political_gen" value="political_gen" <TMPL_IF NAME=SPHEREIT_WIDGET_TYPE_POLITICAL_GEN>checked="checked"</TMPL_IF> /> <MT_TRANS phrase="The politics widget with <em>Balance</em> shows related posts from both sides of the political divide, as well as from a variety of news sources."><br />
      </p>
    </div>
  </div>
  <script language="JavaScript">
    <!--
      hide_and_seek();
    //-->
  </script>
HTML
}

sub sphereit_header {
  my ($ctx, $args, $cond) = @_;
  my $blog = $ctx->stash('blog');
  my $config = $SphereIt->get_config_hash('blog:'.$blog->id);
  my $out = '';
  return $out unless ($config->{sphereit_enabled});

  my $widget;
  if ($config->{sphereit_widget_type}) {
    $widget = '&amp;t='.$config->{sphereit_widget_type};
  }

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

<script type="text/javascript" src="http://www.sphere.com/widgets/sphereit/js?p=movabletype$widget"></script>
HTML

  $out;
}

sub sphereit_widget {
  my ($ctx, $args, $cond) = @_;
  my $blog = $ctx->stash('blog');
  my $config = $SphereIt->get_config_hash('blog:'.$blog->id);
  my $out = '';
  return $out unless ($config->{sphereit_enabled});

  my $entry = $ctx->stash('entry');
  return $out unless ($entry);

  if ( $config->{sphereit_threshold} ) {
    my $entry_id = $entry->id;
    my $body = $entry->text;
    my $more = $entry->text_more;
    $body = $body . ' ' . $more;
    my @num_words = split( / /, $body );
    my $num_words = scalar( @num_words );
    my $num_chars = length( $body );
    return $out if ( $num_words < $config->{sphereit_min_words} && $num_chars < $config->{sphereit_min_chars} );
  }

  my $permalink = $entry->permalink;
  $out = <<HTML;
<a class="iconsphere" title="Related Blogs &amp; Articles" onclick="return Sphere.Widget.search()" href="http://www.sphere.com/search?q=sphereit:$permalink">Sphere It</a>
HTML

  $out;
}

1;