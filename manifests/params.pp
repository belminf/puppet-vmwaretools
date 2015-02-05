class vmwaretools_osp::params {

    $os_version = "${::osfamily} ${::lsbmajdistrelease}"
    case $os_version {
        /^RedHat 6$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel6/${::architecture}/"
            $osp_packages = [
                'vmware-tools-esx-nox',
                'kmod-vmware-tools-pvscsi',
                'kmod-vmware-tools-vmci',
                'kmod-vmware-tools-vmsync',
                'kmod-vmware-tools-vmxnet',
                'kmod-vmware-tools-vmxnet3',
            ]
            $service_name = 'vmware-tools-services'
            $tarball_installer = '/etc/vmware-tools/installer.sh'
            $tarball_uninstall_opt = ' uninstall'
            $conflicting_packages = [
                'open-vm-tools',
                'VMwareTools'
            ]
            $service_provider = 'upstart'
        }
        /^RedHat 5$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel5/${::architecture}/"
            $osp_packages = [
                'vmware-tools-esx-nox',
                'kmod-vmware-tools-pvscsi',
                'kmod-vmware-tools-vmci',
                'kmod-vmware-tools-vmsync',
                'kmod-vmware-tools-vmxnet',
                'kmod-vmware-tools-vmxnet3',
            ]
            $service_name = 'vmware-tools-services'
            $service_enable = true
            $tarball_installer = '/etc/vmware-tools/installer.sh'
            $tarball_uninstall_opt = ' uninstall'
            $conflicting_packages = [
                'open-vm-tools',
                'VMwareTools'
            ]
        }
        default: {
            fail("No repository for OS: ${os_version}")
        }
    }
}
