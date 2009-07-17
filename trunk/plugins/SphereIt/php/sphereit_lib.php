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
