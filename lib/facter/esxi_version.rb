require 'facter'

Facter.add(:esxi_version) do
    confine :virtual => :vmware
    confine :kernel => :Linux
    setcode do
        dmi_path = Facter::Util::Resolution.exec('which dmidecode 2> /dev/null')
        if dmi_path.nil?
            'unknown:no_dmidecode'
        else
            begin
                bios_output = Facter::Util::Resolution.exec("#{dmi_path} -t bios 2> /dev/null")
                if bios_output.nil?
                    'unknown:dmidecode_empty_output'
                else
                    bios_address = bios_output.match(/Address: 0x(.*)/i)[1]
                    case bios_address
                        
                        when 'E72C0'
                            '5.0'
                        when 'EA0C0'
                            '5.1'
                        when 'EA050'
                            '5.5'
                        else
                            "unknown:unrecognized_bios_address:#{bios_address}"
                    end
                end
            rescue
                'unknown:dmidecode_parsing_error'
            end
        end
    end
end
