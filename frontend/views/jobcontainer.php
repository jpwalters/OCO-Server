<?php
$SUBVIEW = 1;
require_once('../../lib/loader.php');
require_once('../session.php');

if(!empty($_POST['remove_container_id'])) {
	$db->removeJobContainer($_POST['remove_container_id']);
}

if(!empty($_GET['id'])) {

	$container = $db->getJobContainer($_GET['id']);
	$jobs = $db->getAllJobByContainer($_GET['id']);
	if($container === null) die('not found');

	$icon = $db->getJobContainerIcon($container->id);
	echo "<h1><img src='img/$icon.svg'>".htmlspecialchars($container->name)."</h1>";

	echo "<p>";
	echo "<button onclick='confirmRemoveJobContainer(".htmlspecialchars($container->id).")'><img src='img/delete.svg'>&nbsp;Container löschen</button>";
	echo "</p>";

	echo "<p>";
	echo "<table class='list'>";
	echo "<tr><th>Start</th><td>".htmlspecialchars($container->start_time)."</td></tr>";
	echo "<tr><th>Ende</th><td>".htmlspecialchars($container->end_time ?? "-")."</td></tr>";
	echo "<tr><th>Beschreibung</th><td>".htmlspecialchars($container->notes)."</td></tr>";
	echo "</table>";
	echo "</p>";

	echo "<table class='list'>";
	echo "<tr><th>Computer</th><th>Paket</th><th>Prozedur</th><th>Reihenfolge</th><th>Status</th><th>Letzte Änderung</th></tr>";
	foreach($jobs as $job) {
		echo "<tr>";
		echo "<td><a href='#' onclick='refreshContentComputerDetail(".$job->computer_id.")'>".htmlspecialchars($job->computer)."</a></td>";
		echo "<td><a href='#' onclick='refreshContentPackageDetail(".$job->package_id.")'>".htmlspecialchars($job->package)."</a></td>";
		echo "<td>".htmlspecialchars($job->package_procedure)."</td>";
		echo "<td>".htmlspecialchars($job->sequence)."</td>";
		if(!empty($job->message)) {
			echo "<td><a href='#' onclick=\"alert('".addslashes($job->message)."')\">".getJobStateString($job->state)."</a></td>";
		} else {
			echo "<td>".getJobStateString($job->state)."</td>";
		}
		echo "<td>".htmlspecialchars($job->last_update);
		echo "</tr>";
	}
	echo "</table>";

} else {

	echo "<h1>"."Jobs"."</h1>";

	echo "<p>";
	echo "<button onclick='refreshContentDeploy()'><img src='img/add.svg'>&nbsp;Neuer Bereitstellungsauftrag</button>";
	echo "</p>";

	echo "<table class='list'>";
	echo "<tr><th></th><th>Name</th><th>Start</th><th>Ende</th><th>Erstellt</th></tr>";
	foreach($db->getAllJobContainer() as $jc) {
		echo "<tr>";
		echo "<td><img src='img/".$db->getJobContainerIcon($jc->id).".svg'></td>";
		echo "<td><a href='#' onclick='refreshContentJobContainer(".$jc->id.")'>".htmlspecialchars($jc->name)."</a></td>";
		echo "<td>".htmlspecialchars($jc->start_time)."</td>";
		echo "<td>".htmlspecialchars($jc->end_time ?? "-")."</td>";
		echo "<td>".htmlspecialchars($jc->created);
		echo "</tr>";
	}
	echo "</table>";

}

function getJobStateString($state) {
	if($state == 0) return "Wartet auf Client";
	elseif($state == -1) return "Fehlgeschlagen";
	elseif($state == 1) return "Ausführung begonnen";
	elseif($state == 2) return "Erfolgreich";
	else return $state;
}
?>