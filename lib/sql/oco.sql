-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Erstellungszeit: 20. Okt 2020 um 21:01
-- Server-Version: 5.7.31-0ubuntu0.18.04.1
-- PHP-Version: 7.2.24-0ubuntu0.18.04.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `oco`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer`
--

CREATE TABLE `computer` (
  `id` int(11) NOT NULL,
  `hostname` text NOT NULL,
  `os` text NOT NULL,
  `os_version` text NOT NULL,
  `kernel_version` text NOT NULL,
  `architecture` text NOT NULL,
  `cpu` text NOT NULL,
  `gpu` text NOT NULL,
  `ram` text NOT NULL,
  `agent_version` text NOT NULL,
  `serial` text NOT NULL,
  `manufacturer` text NOT NULL,
  `model` text NOT NULL,
  `bios_version` text NOT NULL,
  `boot_type` text NOT NULL,
  `secure_boot` text NOT NULL,
  `last_ping` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_update` datetime DEFAULT CURRENT_TIMESTAMP,
  `notes` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_command`
--

CREATE TABLE `computer_command` (
  `id` int(11) NOT NULL,
  `command` text NOT NULL,
  `notes` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_group`
--

CREATE TABLE `computer_group` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_group_member`
--

CREATE TABLE `computer_group_member` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `computer_group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_network`
--

CREATE TABLE `computer_network` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `nic_number` int(11) NOT NULL,
  `addr` text NOT NULL,
  `netmask` text NOT NULL,
  `broadcast` text,
  `mac` text,
  `domain` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_package`
--

CREATE TABLE `computer_package` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `installed_procedure` text NOT NULL,
  `installed` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_partition`
--

CREATE TABLE `computer_partition` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `device` text NOT NULL,
  `mountpoint` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_printer`
--

CREATE TABLE `computer_printer` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_screen`
--

CREATE TABLE `computer_screen` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `manufacturer` text NOT NULL,
  `type` text NOT NULL,
  `resolution` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `computer_software`
--

CREATE TABLE `computer_software` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `name` text NOT NULL,
  `version` text NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `domainuser`
--

CREATE TABLE `domainuser` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `domainuser_logon`
--

CREATE TABLE `domainuser_logon` (
  `id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `domainuser_id` int(11) NOT NULL,
  `console` text,
  `timestamp` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `job`
--

CREATE TABLE `job` (
  `id` int(11) NOT NULL,
  `job_container_id` int(11) NOT NULL,
  `computer_id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `package_procedure` text NOT NULL,
  `sequence` int(11) NOT NULL DEFAULT '0',
  `state` int(11) NOT NULL DEFAULT '0',
  `message` text NOT NULL,
  `last_update` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `job_container`
--

CREATE TABLE `job_container` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `start_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime DEFAULT NULL,
  `notes` text NOT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `package`
--

CREATE TABLE `package` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL,
  `notes` text NOT NULL,
  `version` text NOT NULL,
  `author` text NOT NULL,
  `filename` text NOT NULL,
  `install_procedure` text NOT NULL,
  `uninstall_procedure` text NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `package_group`
--

CREATE TABLE `package_group` (
  `id` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `package_group_member`
--

CREATE TABLE `package_group_member` (
  `id` int(11) NOT NULL,
  `package_id` int(11) NOT NULL,
  `package_group_id` int(11) NOT NULL,
  `sequence` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `setting`
--

CREATE TABLE `setting` (
  `id` int(11) NOT NULL,
  `setting` text NOT NULL,
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `setting`
--

INSERT INTO `setting` (`id`, `setting`, `value`) VALUES
(1, 'client-key', '123'),
(2, 'client-update-interval', '7200'),
(3, 'client-registration-enabled', '1'),
(4, 'purge-successful-jobs', '7200'),
(5, 'purge-failed-jobs', '7200');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `systemuser`
--

CREATE TABLE `systemuser` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL,
  `fullname` text NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Daten für Tabelle `systemuser`
--

INSERT INTO `systemuser` (`id`, `username`, `fullname`, `password`) VALUES
(1, 'admin', 'Admin', '$2y$10$B92cbIK8NlK54DxTdvx8bOz.ymLWR7wmkfh7X0SyfgZW.ar9oZl4G');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `computer`
--
ALTER TABLE `computer`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `computer_command`
--
ALTER TABLE `computer_command`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `computer_group`
--
ALTER TABLE `computer_group`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `computer_group_member`
--
ALTER TABLE `computer_group_member`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_computer_group_member_1` (`computer_group_id`),
  ADD KEY `fk_computer_group_member_2` (`computer_id`);

--
-- Indizes für die Tabelle `computer_network`
--
ALTER TABLE `computer_network`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_computer_network_1` (`computer_id`);

--
-- Indizes für die Tabelle `computer_package`
--
ALTER TABLE `computer_package`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_computer_package_1` (`computer_id`),
  ADD KEY `fk_computer_package_2` (`package_id`);

--
-- Indizes für die Tabelle `computer_partition`
--
ALTER TABLE `computer_partition`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `computer_printer`
--
ALTER TABLE `computer_printer`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `computer_screen`
--
ALTER TABLE `computer_screen`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_computer_screen_1` (`computer_id`);

--
-- Indizes für die Tabelle `computer_software`
--
ALTER TABLE `computer_software`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_computer_software_1` (`computer_id`);

--
-- Indizes für die Tabelle `domainuser`
--
ALTER TABLE `domainuser`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `domainuser_logon`
--
ALTER TABLE `domainuser_logon`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_domainuser_logon_1` (`domainuser_id`),
  ADD KEY `fk_domainuser_logon_2` (`computer_id`);

--
-- Indizes für die Tabelle `job`
--
ALTER TABLE `job`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_job_1` (`job_container_id`),
  ADD KEY `fk_job_2` (`computer_id`),
  ADD KEY `fk_job_3` (`package_id`);

--
-- Indizes für die Tabelle `job_container`
--
ALTER TABLE `job_container`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `package`
--
ALTER TABLE `package`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `package_group`
--
ALTER TABLE `package_group`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `package_group_member`
--
ALTER TABLE `package_group_member`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_package_group_1` (`package_group_id`),
  ADD KEY `fk_package_group_2` (`package_id`);

--
-- Indizes für die Tabelle `setting`
--
ALTER TABLE `setting`
  ADD PRIMARY KEY (`id`);

--
-- Indizes für die Tabelle `systemuser`
--
ALTER TABLE `systemuser`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `computer`
--
ALTER TABLE `computer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;
--
-- AUTO_INCREMENT für Tabelle `computer_command`
--
ALTER TABLE `computer_command`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT für Tabelle `computer_group`
--
ALTER TABLE `computer_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT für Tabelle `computer_group_member`
--
ALTER TABLE `computer_group_member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `computer_network`
--
ALTER TABLE `computer_network`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=269;
--
-- AUTO_INCREMENT für Tabelle `computer_package`
--
ALTER TABLE `computer_package`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT für Tabelle `computer_partition`
--
ALTER TABLE `computer_partition`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT für Tabelle `computer_printer`
--
ALTER TABLE `computer_printer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT für Tabelle `computer_screen`
--
ALTER TABLE `computer_screen`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT für Tabelle `computer_software`
--
ALTER TABLE `computer_software`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124032;
--
-- AUTO_INCREMENT für Tabelle `domainuser`
--
ALTER TABLE `domainuser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT für Tabelle `domainuser_logon`
--
ALTER TABLE `domainuser_logon`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=353;
--
-- AUTO_INCREMENT für Tabelle `job`
--
ALTER TABLE `job`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `job_container`
--
ALTER TABLE `job_container`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;
--
-- AUTO_INCREMENT für Tabelle `package`
--
ALTER TABLE `package`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT für Tabelle `package_group`
--
ALTER TABLE `package_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT für Tabelle `package_group_member`
--
ALTER TABLE `package_group_member`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT für Tabelle `setting`
--
ALTER TABLE `setting`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT für Tabelle `systemuser`
--
ALTER TABLE `systemuser`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `computer_group_member`
--
ALTER TABLE `computer_group_member`
  ADD CONSTRAINT `fk_computer_group_member_1` FOREIGN KEY (`computer_group_id`) REFERENCES `computer_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_computer_group_member_2` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `computer_network`
--
ALTER TABLE `computer_network`
  ADD CONSTRAINT `fk_computer_network_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `computer_package`
--
ALTER TABLE `computer_package`
  ADD CONSTRAINT `fk_computer_package_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_computer_package_2` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `computer_screen`
--
ALTER TABLE `computer_screen`
  ADD CONSTRAINT `fk_computer_screen_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `computer_software`
--
ALTER TABLE `computer_software`
  ADD CONSTRAINT `fk_computer_software_1` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `domainuser_logon`
--
ALTER TABLE `domainuser_logon`
  ADD CONSTRAINT `fk_domainuser_logon_1` FOREIGN KEY (`domainuser_id`) REFERENCES `domainuser` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_domainuser_logon_2` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `job`
--
ALTER TABLE `job`
  ADD CONSTRAINT `fk_job_1` FOREIGN KEY (`job_container_id`) REFERENCES `job_container` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_job_2` FOREIGN KEY (`computer_id`) REFERENCES `computer` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_job_3` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints der Tabelle `package_group_member`
--
ALTER TABLE `package_group_member`
  ADD CONSTRAINT `fk_package_group_1` FOREIGN KEY (`package_group_id`) REFERENCES `package_group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_package_group_2` FOREIGN KEY (`package_id`) REFERENCES `package` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;