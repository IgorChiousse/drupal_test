<?php

namespace Drupal\annonce\Services;

use Drupal\node\Entity\Node;

class AnnonceService {

    public function getTitle($nid) {
        $node = Node::load($nid);
        return $node->getTitle();
    }

}