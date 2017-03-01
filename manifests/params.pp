# 

class vmwaretools::params {

    if $::operatingsystemmajrelease {
        $major_release = $::operatingsystemmajrelease
    } elsif $::lsbmajdistrelease {
        $major_release = $::lsbmajdistrelease
    } else {
        fail('Unable to determine major release.')
    }
    $os_version = "${::osfamily} ${major_release}"
    
    # Tarball cleanup
    $tarball_installer = '/etc/vmware-tools/installer.sh'
    $tarball_uninstall_opt = ' uninstall'


    # Default for service
    $service_enable = true

    # OS dependent
    case $os_version {
        /^RedHat 7$/: {
            $conflicting_packages = [
                'vmware-tools-core',
                'vmware-tools-esx-nox',
                'vmware-tools-nox',
            ]
            $required_packages = 'open-vm-tools'
            $service_name = 'vmtoolsd'
        }

        /^RedHat (5|6)$/: {

            $conflicting_packages = [
                'open-vm-tools',
                'VMwareTools'
            ]
        
            # ESXi specific settings
            case $::esxi_version {
                /^(5.(1|5)|6.0)$/: {

                    case $::architecture {
                        'x86_64': { $arch = 'x86_64' }
                        'i386':   { $arch = 'i386' }
                        default:  { fail("No support for ${::architecture}" ) }
                    }

                    $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel${major_release}/${arch}/"
                    $required_packages = [
                        'vmware-tools-esx-nox',
                        'vmware-tools-esx-kmods',
                    ]
                    $service_name = 'vmware-tools-services'
                    if $os_version == 'RedHat 6' {
                        $service_provider = 'upstart'
                    }
                }
                /^4.(0|1)$/: {

                    case $::architecture {
                        'x86_64': { $arch = 'x86_64' }
                        'i386':   { $arch = 'i686' }
                        default:  { fail("No support for ${::architecture}" ) }
                    }

                    $repo_url = "http://packages.vmware.com/tools/esx/${::esxi_version}latest/rhel${major_release}/${arch}/"
                    $required_packages = [
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

        default: {
            notice("Unsupported OS: ${os_version}")
        }
    }
}
