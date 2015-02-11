require 'facter'

Facter.add(:esxi_version) do
  confine :virtual => :vmware
  confine :kernel => :Linux
  setcode do
    bios_lookup_table = {
      'EA550' => '4.0',
      'EA2E0' => '4.1',
      'E72C0' => '5.0',
      'EA0C0' => '5.1',
      'EA050' => '5.5'
    }
    dmi_path = Facter::Util::Resolution.exec('which dmidecode 2> /dev/null')
    if dmi_path.nil?
      raise Puppet::ParserError, 'Unable to find dmidecode'
    else
      bios_output = Facter::Util::Resolution.exec("#{dmi_path} -t bios 2> /dev/null")
      if bios_output.nil?
        raise Puppet::ParseError, 'DMI did not return output'
      else
        bios_address_line = bios_output.match(/Address: 0x(.*)/i)
        if bios_address_line.nil?
           raise Puppet::ParseError, 'DMI did not return address line'
        else
          bios_lookup_table[bios_address_line[1]] or raise Puppet::ParseError, 'Address not mapped to an esxi version'
        end
      end
    end
  end
end
