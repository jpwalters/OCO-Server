<?php
$SUBVIEW = 1;
require_once('../../lib/Loader.php');
require_once('../session.php');

try {

	// ----- refresh list content if requested -----
	$select_computer_ids = [];
	$select_package_ids = [];
	if(!empty($_GET['computer_id']) && is_array($_GET['computer_id'])) {
		$select_computer_ids = $_GET['computer_id'];
		// compile job name
		foreach($select_computer_ids as $id) {
			$c = $db->getComputer($id);
			if($c == null) continue;
			if(empty($default_job_container_name)) $default_job_container_name = LANG['install'].' '.$c->hostname;
			else $default_job_container_name .= ', '.$c->hostname;
		}
	}
	if(!empty($_GET['package_id']) && is_array($_GET['package_id'])) {
		$select_package_ids = $_GET['package_id'];
		// compile job name
		foreach($select_package_ids as $id) {
			$p = $db->getPackage($id);
			if($p == null) continue;
			if(empty($default_job_container_name)) $default_job_container_name = LANG['install'].' '.$p->package_family_name;
			else $default_job_container_name .= ', '.$p->package_family_name;
		}
	}
	if(isset($_GET['get_computer_group_members'])) {
		$group = $db->getComputerGroup($_GET['get_computer_group_members']);
		$computers = [];
		if(empty($group)) $computers = $db->getAllComputer();
		else $computers = $db->getComputerByGroup($group->id);
		foreach($computers as $c) {
			$selected = '';
			if(!empty($group) || in_array($c->id, $select_computer_ids)) $selected = 'selected';
			echo "<option value='".$c->id."' ".$selected.">".htmlspecialchars($c->hostname)."</option>";
		}
		die();
	}
	if(isset($_GET['get_package_group_members'])) {
		$group = $db->getPackageGroup($_GET['get_package_group_members']);
		$packages = [];
		if(empty($group)) $packages = $db->getAllPackage(true);
		else $packages = $db->getPackageByGroup($group->id);
		foreach($packages as $p) {
			$selected = '';
			if(!empty($group) || in_array($p->id, $select_package_ids)) $selected = 'selected';
			echo "<option value='".$p->id."' ".$selected.">".htmlspecialchars($p->name)." (".htmlspecialchars($p->version).")"."</option>";
		}
		die();
	}

	// ----- create install jobs if requested -----
	if(isset($_POST['create_install_job_container'])) {
		$jcid = $cl->deploy(
			$_POST['create_install_job_container'], $_POST['description'], $_SESSION['um_username'],
			$_POST['computer_id'] ?? [], $_POST['computer_group_id'] ?? [], $_POST['package_id'] ?? [], $_POST['package_group_id'] ?? [],
			$_POST['date_start'], $_POST['date_end'] ?? null,
			$_POST['use_wol'] ?? 1, $_POST['shutdown_waked_after_completion'] ?? 0, $_POST['restart_timeout'] ?? 5,
			$_POST['auto_create_uninstall_jobs'] ?? 1, $_POST['force_install_same_version'] ?? 0,
			$_POST['sequence_mode'] ?? 0, $_POST['priority'] ?? 0
		);
		die(strval(intval($jcid)));
	}

	// ----- create uninstall jobs if requested -----
	if(isset($_POST['create_uninstall_job_container'])
	&& !empty($_POST['uninstall_package_assignment_id'])
	&& is_array($_POST['uninstall_package_assignment_id'])
	&& isset($_POST['notes'])
	&& isset($_POST['start_time'])
	&& isset($_POST['end_time'])
	&& isset($_POST['use_wol'])
	&& isset($_POST['shutdown_waked_after_completion'])
	&& isset($_POST['restart_timeout'])
	&& isset($_POST['priority'])) {
		$cl->uninstall(
			$_POST['create_uninstall_job_container'], $_POST['notes'], $_SESSION['um_username'],
			$_POST['uninstall_package_assignment_id'], $_POST['start_time'], $_POST['end_time'],
			$_POST['use_wol'], $_POST['shutdown_waked_after_completion'], $_POST['restart_timeout'],
			0/*sequence mode*/, $_POST['priority']
		);
		die();
	}

	// ----- remove package-computer assignment if requested -----
	if(!empty($_POST['remove_package_assignment_id'])
	&& is_array($_POST['remove_package_assignment_id'])) {
		foreach($_POST['remove_package_assignment_id'] as $id) {
			$cl->removeComputerAssignedPackage($id);
		}
		die();
	}

} catch(Exception $e) {
	header('HTTP/1.1 400 Invalid Request');
	die($e->getMessage());
}

header('HTTP/1.1 400 Invalid Request');
die(LANG['unknown_method']);
