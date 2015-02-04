# = Class: vmware::tools
#
# Adds the proper OSP repository to a VMware VM. This is then used to install
# VMware tools.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
# class { 'vmware::tools': }
#
# == Resources:
#
# https://www.vmware.com/support/packages
# http://packages.vmware.com/tools/esx/index.html
# http://packages.vmware.com/tools/docs/manuals/osp-esxi-51-install-guide.pdf
#

class vmware::tools {

    $os_version = "${::osfamily} ${::operatingsystemmajrelease}"
    case $os_version {
        /^RedHat (6|7)$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel6/${::architecture}/"
            $service_cmd = '/etc/vmware-tools/init/vmware-tools-services'
        }
        /^RedHat (4|5)$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel${::operatingsystemmajrelease}/${::architecture}/"
            $service_cmd = '/etc/vmware-tools/init/vmware-tools-services'
        }
        default: {
            fail("No repository for OS: ${os_version}")
        }
    }

    yumrepo { 'vmware-osp':
        baseurl  => $repo_url,
        descr    => 'VMware OSP repository',
        enabled  => 1,
        gpgcheck => 0,
    }

    # Remove other tools
    package { 'open-vm-tools':
        ensure => absent,
    }

    package { 'vmware-tools-esx-nox':
        ensure  => latest,
        require => [
            Yumrepo['vmware-osp'],
            Package['open-vm-tools'],
        ],
    }

    service { 'vmware-tools':
        ensure   => running,
        provider => 'base',
        start    => "/usr/bin/sh -c '${service_cmd} start'",
        stop     => "/usr/bin/sh -c '${service_cmd} stop'",
        status   => "/usr/bin/sh -c '${service_cmd} status'",
        restart  => "/usr/bin/sh -c '${service_cmd} restart'",
    }
}
