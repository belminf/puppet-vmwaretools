# puppet-vmwaretools_osp

Puppet module for installing VMware tools via OSP. See [init.pp](manifests/init.pp) for more.

Adding new ESXi version:
--
Get address from the VM:

    dmidecode -t bios 2> /dev/null | grep Address

Map it to a version in [facter code](lib/facter/esxi_version.rb).

Resources:
--
- https://www.vmware.com/support/packages
- http://packages.vmware.com/tools/esx/index.html
- http://packages.vmware.com/tools/docs/manuals/osp-esxi-51-install-guide.pdf
