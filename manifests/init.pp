# = Class: vmwaretools
#
# Adds the proper VMware tools from either OSP or OS repository.

# == Requires:
#
# Puppet 2.7 or greater (due to: class_inherits_from_params_class)
#
# == Sample Usage:
#
# class { 'vmwaretools': }
#

class vmwaretools (
    $repo_url              = $vmwaretools::params::repo_url,
    $required_packages     = $vmwaretools::params::required_packages,
    $conflicting_packages  = $vmwaretools::params::conflicting_packages,
    $service_name          = $vmwaretools::params::service_name,
    $service_enable        = $vmwaretools::params::service_enable,
    $service_provider      = $vmwaretools::params::service_provider,
    $service_start         = $vmwaretools::params::service_start,
    $service_stop          = $vmwaretools::params::service_stop,
    $service_status        = $vmwaretools::params::service_status,
    $tarball_installer     = $vmwaretools::params::tarball_installer,
    $tarball_uninstall_opt = $vmwaretools::params::tarball_uninstall_opt
) inherits vmwaretools::params {

    if versioncmp($::puppetversion, '3.6.0') >= 0 {
        Package { allow_virtual => true, }
    }

    if $::virtual == 'vmware' {

        # If we have a service, do everything before that
        if $service_name {
            $uninstall_before = Service[$service_name]
        } else {
            $uninstall_before = undef
        }

        # Tarball cleanup
        if $tarball_installer {
            exec { 'remove tarball':
                command => "${tarball_installer}${tarball_uninstall_opt}",
                onlyif  => "test -f ${tarball_installer}",
                path    => '/usr/bin:/bin',
                before  => $uninstall_before,
            }
        }

        # Uninstall conflicting
        if $conflicting_packages {
            package { $conflicting_packages:
                ensure   => absent,
                provider => 'rpm',
                before   => $uninstall_before,
            }
        }

        # Add repository
        if $repo_url {
            yumrepo { 'vmware-tools':
                baseurl  => $repo_url,
                descr    => 'VMware Tools',
                enabled  => 1,
                gpgcheck => 0,
                before   => $uninstall_before,
            }
        }
    
        # Add packages
        if $required_packages {
            package { $required_packages:
                ensure => latest,
                before => $uninstall_before,
            }
        }

        # Manage service
        if $service_name {
            service { $service_name:
                ensure   => running,
                enable   => $service_enable,
                provider => $service_provider,
                start    => $service_start,
                stop     => $service_stop,
                status   => $service_status,
            }
        }
    }
}
