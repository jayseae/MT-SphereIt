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

function smarty_function_mtsphereitheader($args, &$ctx) {
  require_once('sphereit_lib.php');

  if (! $config = sphereit_config($ctx)) 
    return;

  if (! $config['sphereit_enabled'])
    return;

  if ($config['sphereit_widget_type'])
    $widget = '&amp;t='.$config['sphereit_widget_type'];

  echo '
  <style type="text/css">
  .iconsphere {
    background: url(http://www.sphere.com/images/sphereicon.gif) top left no-repeat;
    padding-left: 20px;
    padding-bottom: 10px;
    font-size: 10px;
    white-space: nowrap;
  }
  </style>

  <script type="text/javascript" src="http://www.sphere.com/widgets/sphereit/js?p=movabletype'.$widget.'"></script>';
}
?>
