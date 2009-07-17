<?php

/*
# ===========================================================================
# A Movable Type plugin to automatically show related content from Sphere.
# Copyright 2007, 2008 Everitz Consulting <everitz.com>.
#
# This program is free software:  You may redistribute it and/or modify it
# it under the terms of the Artistic License version 2 as published by the
# Open Source Initiative.
#
# This program is distributed in the hope that it will be useful but does
# NOT INCLUDE ANY WARRANTY; Without even the implied warranty of FITNESS
# FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the Artistic License with this program.
# If not, see <http://www.opensource.org/licenses/artistic-license-2.0.php>.
# ===========================================================================
*/

function smarty_function_mtsphereitwidget($args, &$ctx) {
  require_once('sphereit_lib.php');

  if (! $config = sphereit_config($ctx)) 
    return;

  if (! $config['sphereit_enabled'])
    return;

  if ($entry = $ctx->stash('entry')) {
    if ( $config['sphereit_threshold']) {
      $body = $entry['entry_text'];
      $more = $entry['entry_text_more'];
      $body = $body . ' ' . $more;
      $num_words = count( explode( ' ', $body) );
      $num_chars = strlen( $body );
      if ( $num_words < $config['sphereit_min_words'] && $num_chars < $config['sphereit_min_chars'] )
        return;
    }

    $blog = $ctx->stash('blog');
    $at = $args['archive_type'];
    $at or $at = $blog['blog_archive_type_preferred'];
    if (!$at) {
        $at = $blog['blog_archive_type'];
        # strip off any extra archive types...
        $at = preg_replace('/,.*/', '', $at);
    }
    $entry_link = $ctx->mt->db->entry_link($entry['entry_id'], $at, $args);
    return '<a class="iconsphere" title="Related Blogs &amp; Articles" onclick="return Sphere.Widget.search()" href="http://www.sphere.com/search?q=sphereit:'.$entry_link.'">Sphere It</a>';
  } else {
    return;
  }
}
?>
