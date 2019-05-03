<?php
class ItemRoubo extends GenericDomain {

    private $item;
    private $quantidade;
    
    public function ItemRoubo($codigo, $item, $quantidade) {
        parent::setCodigo($codigo);
        $this->item       = utf8_encode($item);
        $this->quantidade = (int) $quantidade;
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    public function getItem() {
        return $item;
    }

    public function setItem($item) {
        $this->item = $item;
    }

    public function getQuantidade() {
        if ($this->quantidade == null) {
            $this->quantidade = 1;
        }
        return $this->quantidade;
    }

    public function setQuantidade($quantidade) {
        $this->quantidade = $quantidade;
    }
}