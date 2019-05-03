<?php
    require_once 'src/com/wjuan/gdop/util/Config.ini.php';
    require_once 'src/com/wjuan/gdop/services/sessionService.php';
    require_once 'src/com/wjuan/gdop/util/urlAmigavel.php';

    if (isset($url[1])) {
        header("Location: /gdop/".$url[0]);
    }

    $usuario = getObjetoNaSessao('usuario');

    if ($url[0] == 'index' || $url[0] == 'home' || $url[0] == 'início' || $url[0] == 'inicio') {
        require_once 'web/view/gdop.html';
    } else if(file_exists("web/view/".$url[0].".html")) {

        $pages = array('sobre', 'termos-de-uso', 'politicas-de-privacidade', 'acessar-sistema');
        if (is_null($usuario) && !in_array($url[0], $pages)) {
            header("Location: acessar-sistema");
        }

        if ($url[0] == "acessar-sistema" && !is_null($usuario)) {
            header("Location: /gdop/");
        }

        if ($url[0] == 'cadastro-usuario' && !is_null($usuario) && $usuario['tipo'] != "Administrador") {
            header("Location: /gdop/");
        }

        if ($url[0] == "404") {
            header("Location: /gdop/");
        }

        require_once 'web/view/'.$url[0].".html";

    } else {
        if ($url[0] === "editar-ocorrencia") {
            if (is_null(getObjetoNaSessao('editarOcorrencia'))) {
                header("Location: cadastro-ocorrencia");
            } else {
                require_once 'web/view/cadastro-ocorrencia.html';
            }
        } else if (!is_null($usuario) && $url[0] == urlAmigavel($usuario['nome'])) {
            if (is_null(getObjetoNaSessao('editarPerfil'))) {
                header("Location: cadastro-usuario");
            } else {
                require_once 'web/view/cadastro-usuario.html';
            }
        } else {
            require_once 'web/view/404.html';
        }
    }