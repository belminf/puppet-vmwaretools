class vmwaretools_osp::params {

    $os_version = "${::osfamily} ${::operatingsystemmajrelease}"
    case $os_version {
        /^RedHat (7)$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel6/${::architecture}/"
            $service_cmd = '/etc/vmware-tools/init/vmware-tools-services'
        }
        /^RedHat 5$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel5/${::architecture}/"
            $osp_package = 'vmware-tools-esx-nox'
            $service_name = 'vmware-tools-services'
            $service_enable = true
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
