<?php

# Copyright Everitz Consulting.  Not to be redistributed without permission.

function smarty_function_MTSphereItWidget($args, &$ctx) {
  if ($entry = $ctx->stash('entry')) {
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
    return '';
  }
}
?>
