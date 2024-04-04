<?php

namespace Drupal\annonce\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\node\Entity\Node;
use Symfony\Component\HttpFoundation\Response;

/**
 * Returns responses for Node routes.
 */
class AnnonceController extends ControllerBase {

 
  public function interrested(int $nid) {

    $title = \Drupal::service("annonce.service")->getTitle($nid);

    return [
        "#theme" => "interrested",
        "#title" => $title,
    ];
    
  }


}
