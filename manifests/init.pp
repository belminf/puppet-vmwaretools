# Get repository from:
# https://www.vmware.com/support/packages
# http://packages.vmware.com/tools/esx/index.html
# http://packages.vmware.com/tools/docs/manuals/osp-esxi-51-install-guide.pdf

class vmware::tools {

	case "${osfamily} ${operatingsystemmajrelease}" {
		/^RedHat (6|7)$/: {
			$repo_url = "http://packages.vmware.com/tools/esx/${esxi_version}latest/rhel6/${architecture}/"
			$service_cmd = '/etc/vmware-tools/init/vmware-tools-services'
		}
	}

	if $repo_url {
		yumrepo { 'vmware-osp':
			baseurl => $repo_url,
			descr => 'VMware OSD repository',
			enabled => 1,
			gpgcheck => 0,
		}

		# Remove other tools
		package { 'open-vm-tools':
			ensure => absent,
		}

		package { 'vmware-tools-esx-nox':
			ensure => latest,
			require => [
				Yumrepo['vmware-osp'],
				Package['open-vm-tools'],
			],
		}

		service { 'vmware-tools':
			provider => 'base',
			ensure => running,
			start => "/usr/bin/sh -c '${service_cmd} start'",
			stop => "/usr/bin/sh -c '${service_cmd} stop'",
			status => "/usr/bin/sh -c '${service_cmd} status'",
			restart => "/usr/bin/sh -c '${service_cmd} restart'",
		}

	} else {
		notify { "OS not configured: ${osfamily} ${operatingsystemmajrelease}": }
	}
}
