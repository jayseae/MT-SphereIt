<?php

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
