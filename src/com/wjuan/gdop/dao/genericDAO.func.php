<?php

/**
 *
 */
function select($tabela, $coluna = "*", $where = NULL, $order = NULL, $limit = NULL) {
    try {
        $pdo = Connection::connect();
        $sql = $pdo->prepare("SELECT {$coluna} FROM {$tabela} {$where} {$order} {$limit}");
        $sql->execute();
        if ($pdo) {
            $query = $sql->fetchAll(PDO::FETCH_OBJ);
            return ($query) ? $query : false;
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}

function selectFunction($funcao) {
    try {
        $pdo = Connection::connect();
        if ($pdo) {
            $sql = $pdo->prepare("SELECT {$funcao} AS value");
            $sql->execute();
            $query = $sql->fetchAll(PDO::FETCH_OBJ);
            return ($query) ? $query : false;
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();   
    }
}

/**
 *
 */
function callProcedure($procedure) {
    try {
        $pdo = Connection::connect();
        if ($pdo) {
            $sql = $pdo->prepare("CALL {$procedure}");
            $sql->execute();
            $query = $sql->fetchAll(PDO::FETCH_OBJ);
            return ($query) ? $query : false;
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();   
    }
}

/**
 *
 */
function inserir($coluna, $valor, $tabela) {
    try {
        $pdo = Connection::connect();
        if ((is_array($coluna)) && (is_array($valor))) {
            if (count($coluna) == count($valor)) {
                $inserir = $pdo->prepare("INSERT INTO {$tabela} (" . implode(', ', $coluna) . ") VALUES ('" . implode('\', \'', $valor) . "')");
            } else {
                return false;
            }
        } else {
            $inserir = $pdo->prepare("INSERT INTO {$tabela} ({$coluna}) VALUES ('{$valor}'");
        }
        if ($pdo) {
            if ($inserir->execute()) {
                return $pdo;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}

/**
 *
 */
function update($coluna, $valor, $tabela, $where) {
    try {
        $pdo = Connection::connect();
        if ((is_array($coluna)) && (is_array($valor))) {
            if (count($coluna) == count($valor)) {
                $valorColuna = \NULL;
                for ($i = 0; $i < count($coluna); $i++) {
                    $valorColuna .= "{$coluna[$i]} = '{$valor[$i]}',";
                }
                $valorColuna = substr($valorColuna, 0, -1);
                $atualizar = $pdo->prepare("UPDATE {$tabela} SET {$valorColuna} {$where}");
            } else {
                return false;
            }
        } else {
            $atualizar = $pdo->prepare("UPDATE {$tabela} SET {$coluna} = '{$valor}' {$where}");
        }
        if ($pdo) {
            if ($atualizar->execute()) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}

/**
 *
 */
function delete($tabela, $where = NULL) {    
    try {
        $pdo = Connection::connect();
        $delete = $pdo->prepare("DELETE FROM {$tabela} {$where}");
        if ($pdo) {
             if ($delete->execute()) {
                 return true;
             } else {
                 return false;
             }
        } else {
            return false;
        }
    } catch (PDOException $e) {
        echo $e->getMessage();
    }
}