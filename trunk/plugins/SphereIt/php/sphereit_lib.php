<?php

# Copyright Everitz Consulting.  Not to be redistributed without permission.

function sphereit_config($ctx) {
  $config = $ctx->stash('sphereit_config');
  if ($config)
    return $config;
  $blog_id = $ctx->stash('blog_id');
  $config = $ctx->mt->db->fetch_plugin_config('MT-SphereIt', 'blog:' . $blog_id);
  if (!$config)
    $config = $ctx->mt->db->fetch_plugin_config('MT-SphereIt');
  if (!$config)
    $config = array(
      'sphereit_enabled' => 1,
      'sphereit_min_chars' => 30,
      'sphereit_min_words' => 500,
      'sphereit_threshold' => 1,
      'sphereit_widget_type' => 'movabletype'
    );
  if ($config) {
    $ctx->stash('sphereit_config', $config);
  }
  return $config;
}
?>
