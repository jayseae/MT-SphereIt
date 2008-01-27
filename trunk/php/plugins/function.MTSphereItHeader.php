<?php

# Copyright Everitz Consulting.  Not to be redistributed without permission.

function smarty_function_MTSphereItHeader($args, &$ctx) {
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

  <script type="text/javascript" src="http://www.sphere.com/widgets/sphereit/js?siteid=movabletype"></script>';
}
?>
