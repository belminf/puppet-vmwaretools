# = Class: vmware::tools
#
# Adds the proper OSP repository to a VMware VM. This is then used to install
# VMware tools.
#
# == Requires:
#
# Puppet 2.7 or greater (due to: class_inherits_from_params_class)
#
# == Sample Usage:
#
# class { 'vmware::tools': }
#

class vmwaretools_osp (
    $repo_url              = $vmwaretools_osp::params::repo_url,
    $osp_packages          = $vmwaretools_osp::params::osp_packages,
    $conflicting_packages  = $vmwaretools_osp::params::conflicting_packages,
    $service_name          = $vmwaretools_osp::params::service_name,
    $service_enable        = $vmwaretools_osp::params::service_enable,
    $service_provider      = $vmwaretools_osp::params::service_provider,
    $service_start         = $vmwaretools_osp::params::service_start,
    $service_stop          = $vmwaretools_osp::params::service_stop,
    $service_status        = $vmwaretools_osp::params::service_status,
    $tarball_installer     = $vmwaretools_osp::params::tarball_installer,
    $tarball_uninstall_opt = $vmwaretools_osp::params::tarball_uninstall_opt
) inherits vmwaretools_osp::params {

    yumrepo { 'vmware-osp':
        baseurl  => $repo_url,
        descr    => 'VMware OSP repository',
        enabled  => 1,
        gpgcheck => 0,
    }

    if $tarball_installer {
        exec { 'remove tarball':
            command => "${tarball_installer}${tarball_uninstall_opt}",
            onlyif  => "test -f ${tarball_installer}",
            before  => Package[$osp_packages],
            path    => '/usr/bin:/bin',
        }
    }

    package { $conflicting_packages:
        ensure => absent,
        before => Package[$osp_packages]
    }

    package { $osp_packages:
        ensure  => latest,
        require => Yumrepo['vmware-osp'],
        before  => Service[$service_name]
    }

    service { $service_name:
        ensure   => running,
        enable   => $service_enable,
        provider => $service_provider,
        start    => $service_start,
        stop     => $service_stop,
        status   => $service_status,
    }
}
