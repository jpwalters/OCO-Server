<?php

class DatabaseMigrationController {

	/*
		Class DatabaseMigrationController

		Executes automatic database schema upgrades.
	*/

	protected $dbh;
	private $stmt;
	private $debug;

	function __construct($dbh, $debug=false) {
		$this->dbh = $dbh;
		$this->debug = $debug;
	}

	public function upgrade() {
		$upgraded = false;
		// Note: PDO::beginTransaction() is useless for schema changes in MySQL and corresponding commit() will throw an error since PHP 8, that's why no transactions are used here.

		// upgrade from 0.15.0 to 0.15.1
		// upgrade from 0.15.1 to 0.15.2
		$this->stmt = $this->dbh->prepare('SHOW TABLES LIKE "domain_user_role"');
		$this->stmt->execute();
		if($this->stmt->rowCount() != 1) {
			if($this->debug) echo 'Upgrading to 0.15.2...'."\n";

			$this->stmt = $this->dbh->prepare(
				"CREATE TABLE IF NOT EXISTS `domain_user_role` (
				`id` int(11) NOT NULL AUTO_INCREMENT,
				`name` text NOT NULL,
				`permissions` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
				PRIMARY KEY (`id`),
				CONSTRAINT `c_domain_user_role_1` CHECK(JSON_VALID(permissions))
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				"ALTER TABLE `domain_user`
				ADD COLUMN `domain_user_role_id` int(11) DEFAULT NULL,
				ADD COLUMN `password` text DEFAULT NULL,
				ADD COLUMN `ldap` tinyint(4) NOT NULL DEFAULT 0,
				ADD COLUMN `last_login` datetime DEFAULT NULL,
				ADD COLUMN `created` datetime NOT NULL DEFAULT current_timestamp(),
				ADD KEY `fk_domain_user_1` (`domain_user_role_id`),
				ADD CONSTRAINT `fk_domain_user_1` FOREIGN KEY (`domain_user_role_id`) REFERENCES `domain_user_role` (`id`) ON DELETE SET NULL ON UPDATE CASCADE");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				"CREATE TABLE IF NOT EXISTS `event_query_rule` (
				  `id` bigint(11) NOT NULL AUTO_INCREMENT,
				  `log` text NOT NULL,
				  `query` text NOT NULL,
				  PRIMARY KEY (`id`)
				) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				"CREATE TABLE IF NOT EXISTS `computer_event` (
					`id` bigint(11) NOT NULL AUTO_INCREMENT,
					`computer_id` int(11) NOT NULL,
					`timestamp` datetime NOT NULL,
					`level` tinyint(4) NOT NULL,
					`event_id` int(11) NOT NULL,
					`data` longtext NOT NULL,
					PRIMARY KEY (`id`),
					KEY `computer_id` (`computer_id`),
					CONSTRAINT `fk_computer_event_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
				  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$upgraded = true;
		}

		// upgrade from 0.15.2 to 0.15.3
		// upgrade from 0.15.3 to 0.15.4
		// upgrade from 0.15.4 to 0.15.5
		$this->stmt = $this->dbh->prepare('SHOW TABLES LIKE "computer_service"');
		$this->stmt->execute();
		if($this->stmt->rowCount() != 1) {
			if($this->debug) echo 'Upgrading to 0.15.3...'."\n";

			$this->stmt = $this->dbh->prepare(
				"CREATE TABLE IF NOT EXISTS `computer_service` (
					`id` bigint(11) NOT NULL AUTO_INCREMENT,
					`computer_id` int(11) NOT NULL,
					`log` text NOT NULL,
					`timestamp` datetime NOT NULL DEFAULT current_timestamp(),
					`updated` datetime NOT NULL DEFAULT current_timestamp(),
					`provider` text NOT NULL,
					`status` tinyint(4) NOT NULL,
					`name` text NOT NULL,
					`metrics` text NOT NULL,
					`details` text NOT NULL,
					PRIMARY KEY (`id`),
					KEY `computer_id` (`computer_id`),
					CONSTRAINT `fk_computer_service_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
				  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				<<<EOF
				REPLACE INTO `system_user_role` (`id`, `name`, `permissions`) VALUES
				(1, 'Superadmin', '{\"Special\\\\\\\\ClientApi\": true, \"Special\\\\\\\\WebFrontend\": true, \"Special\\\\\\\\GeneralConfiguration\": true, \"Special\\\\\\\\EventQueryRules\": true, \"Special\\\\\\\\DeletedObjects\": true, \"Models\\\\\\\\Computer\": {\"*\": {\"read\": true, \"write\": true, \"wol\": true, \"delete\": true, \"deploy\": true}, \"create\": true}, \"Models\\\\\\\\ComputerGroup\": {\"*\": {\"read\": true, \"write\": true, \"create\": true, \"delete\": true}, \"create\": true}, \"Models\\\\\\\\Package\": {\"*\": {\"read\": true, \"write\": true, \"download\": true, \"delete\": true, \"deploy\": true}, \"create\": true}, \"Models\\\\\\\\PackageGroup\": {\"create\": true, \"*\": {\"read\": true, \"write\": true, \"delete\": true}}, \"Models\\\\\\\\PackageFamily\": {\"*\": {\"read\": true, \"write\": true, \"create\": true, \"delete\": true, \"deploy\": true}, \"create\": true}, \"Models\\\\\\\\DomainUser\": {\"read\": true, \"delete\": true}, \"Models\\\\\\\\SystemUser\": true, \"Models\\\\\\\\Report\": {\"create\": true, \"*\": {\"read\": true, \"write\": true, \"delete\": true} }, \"Models\\\\\\\\ReportGroup\": {\"create\":true, \"*\": {\"read\": true, \"write\": true, \"create\": true, \"delete\": true}}, \"Models\\\\\\\\JobContainer\": {\"*\": {\"read\": true, \"write\": true, \"create\": true, \"delete\": true}, \"create\": true}, \"Models\\\\\\\\Software\": true, \"Models\\\\\\\\DeploymentRule\": {\"*\": {\"read\": true, \"write\": true, \"delete\": true}, \"create\": true}}');
				EOF);
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				"CREATE TABLE IF NOT EXISTS `setting` (
					`id` int(11) NOT NULL AUTO_INCREMENT,
					`key` text NOT NULL,
					`value` text NOT NULL,
					PRIMARY KEY (`id`)
				  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");
			if(!$this->stmt->execute()) throw new Exception('SQL error');


			if($this->debug) echo 'Upgrading to 0.15.5...'."\n";

			$this->stmt = $this->dbh->prepare(
				"ALTER TABLE `report` AUTO_INCREMENT=1000");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$this->stmt = $this->dbh->prepare(
				"REPLACE INTO `report` (`id`, `report_group_id`, `name`, `notes`, `query`) VALUES
				(13, 1, 'report_critical_services', '', 'SELECT cs.computer_id, c.hostname, cs.status, cs.timestamp, cs.updated, cs.details FROM computer_service cs INNER JOIN computer c ON c.id = cs.computer_id WHERE cs.id IN (SELECT MAX(cs2.id) FROM computer_service cs2 GROUP BY cs2.computer_id, cs2.name) AND cs.status != 0 ORDER BY c.hostname ASC'),
				(14, 1, 'report_critical_events', '', 'SELECT timestamp, computer_id, hostname, event_id, IF(level=2, \"ERROR\", IF(level=3, \"WARNING\", level)) AS \"level\", data AS \"Error Description\" FROM computer_event ce INNER JOIN computer c ON c.id = ce.computer_id ORDER BY timestamp DESC');");
			if(!$this->stmt->execute()) throw new Exception('SQL error');

			$upgraded = true;
		}

		return $upgraded;
	}

}
