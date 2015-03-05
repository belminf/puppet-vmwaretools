class vmwaretools_osp::params {

    $os_version = "${::osfamily} ${::lsbmajdistrelease}"
    
    # General settings
    $tarball_installer = '/etc/vmware-tools/installer.sh'
    $tarball_uninstall_opt = ' uninstall'
    $conflicting_packages = [
        'open-vm-tools',
        'VMwareTools'
    ]
    $service_enable = true
    
    case $::architecture {
        'x86_64': { $arch = 'x86_64' }
        'i386':   { $arch = 'i686' }
        default:  { fail("No support for ${::architecture}" ) }
    }

    # ESXi specific settings
    case "${::esxi_version} - ${os_version}" {
        /^5.(1|5) - RedHat (5|6)$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel${::lsbmajdistrelease}/${arch}/"
            $osp_packages = [
                'vmware-tools-esx-nox',
                'vmware-tools-esx-kmods',
            ]
            $service_name = 'vmware-tools-services'
            if $os_version == 'RedHat 6' {
                $service_provider = 'upstart'
            }
        }
        /^4.(0|1) - RedHat (5|6)$/: {
            $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel${::lsbmajdistrelease}/${arch}/"
            $osp_packages = [
                'vmware-tools-nox',
                'vmware-open-vm-tools-kmod',
            ]
            $service_name = 'vmware-tools'
        }
        default: {
            fail("No setup for ESXi and OS: ${::esxi_version} ${os_version}")
        }
    }

}
