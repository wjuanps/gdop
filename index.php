<!DOCTYPE html>
<html lang="pt-br" ng-app="gdop">
    <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="Juan Soares">
        <!-- Meta Description -->
        <meta name="description" content="">
        <!-- Meta Keyword -->
        <meta name="keywords" content="">
        <!-- meta character set -->
        <meta charset="UTF-8">

        <title>GdOP - Gerenciador de Ocorrências Policiais</title>

        <link rel="icon" href="favicon.png" type="image/x-icon" />

        <link rel="stylesheet" href="web/lib/bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="web/lib/ionicons/css/ionicons.css">
        <link rel="stylesheet" href="web/css/linearicons.css">
        <link rel="stylesheet" href="web/lib/font-awesome/css/font-awesome.min.css">
        <link rel="stylesheet" href="web/css/nice-select.css">
        <link rel="stylesheet" href="web/css/main.css">
        <link rel="stylesheet" href="web/lib/MomentPicker/angular-moment-picker.css">
        <link rel="stylesheet" href="web/lib/morrisjs/morris.css">
        <link rel="stylesheet" href="web/css/custom-style.css">
    </head>

    <body class="dup-body">

        <div class="dup-body-wrap" ng-controller="gdopCtrl" ng-init="initUser()">
            <?php
                require_once 'web/view/includes/header.html';
                require_once 'src/com/wjuan/gdop/app/webFilter.php';
            ?>

            <div ng-include="'web/view/includes/footer.html'"></div>
        </div>
        <?php require_once 'web/view/includes/scripts.html'; ?>
    </body>
</html>