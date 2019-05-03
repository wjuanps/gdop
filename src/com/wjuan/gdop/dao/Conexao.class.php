<?php
	final class Connection {
		private static $db = "mysql:host=localhost;dbname=db_gdop";
		private static $username = "root";
		private static $password = "";

		public static function connect() {
			try {
				$pdo = new PDO(self::$db, self::$username, self::$password);
				return $pdo;
			}  catch (PDOException $e) {
				echo $e->getMessage();
			}
		}
	}
?>